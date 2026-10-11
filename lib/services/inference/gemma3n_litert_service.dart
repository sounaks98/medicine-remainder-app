import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_edge_ai/flutter_edge_ai.dart';
import 'package:medicine_remainder_app/services/inference/gemma3n_litert_client.dart';
import 'package:medicine_remainder_app/services/inference/gemma3n_manifest.dart';
import 'package:medicine_remainder_app/services/inference/inference_result.dart';
import 'package:medicine_remainder_app/shared/config/huggingface_token.dart';
import 'package:medicine_remainder_app/shared/platform/device_abi.dart';

/// Default prescription spike prompt — no medical guessing.
const String kGemma3nPrescriptionSpikePrompt = '''
Read only the text visible in this prescription image.
List medicine names, strengths, and dosage instructions exactly as written.
If a field is illegible or missing, say "uncertain" or "missing" for that field.
Do not infer doses, frequency, or duration that are not explicitly written.
Do not claim the prescription is medically verified.
''';

enum Gemma3nServiceState {
  unavailable,
  notLoaded,
  loading,
  ready,
  running,
  failed,
  disposed,
}

/// On-device Gemma 3n E2B spike service (LiteRT-LM). Not wired to production extraction.
class Gemma3nLitertService extends ChangeNotifier {
  Gemma3nLitertService({
    Gemma3nLitertClient? client,
    String? huggingFaceToken,
  })  : _client = client ?? FlutterEdgeGemma3nClient(),
        _huggingFaceToken = resolveHuggingFaceToken(huggingFaceToken);

  final Gemma3nLitertClient _client;
  final String? _huggingFaceToken;
  Gemma3nManifest? _manifest;
  Gemma3nServiceState _state = Gemma3nServiceState.notLoaded;
  String? _lastError;
  CancelToken? _installCancelToken;
  int _generationEpoch = 0;

  Gemma3nServiceState get state => _state;
  String? get lastError => _lastError;
  Gemma3nManifest? get manifest => _manifest;

  Future<void> ensureManifestLoaded() async {
    _manifest ??= await Gemma3nManifest.load();
  }

  Future<bool> isModelReady() async {
    if (_state == Gemma3nServiceState.disposed ||
        _state == Gemma3nServiceState.unavailable) {
      return false;
    }
    await ensureManifestLoaded();
    final installed =
        await _client.isModelInstalled(_manifest!.artifactFileName);
    if (installed && _state == Gemma3nServiceState.notLoaded) {
      _state = Gemma3nServiceState.ready;
      notifyListeners();
    }
    return installed;
  }

  Future<void> loadModel({void Function(int percent)? onProgress}) async {
    if (_state == Gemma3nServiceState.disposed) {
      throw StateError('Service disposed');
    }
    if (_state == Gemma3nServiceState.loading ||
        _state == Gemma3nServiceState.running) {
      return;
    }
    if (!deviceSupportsLitertLm) {
      final abi = deviceAbiDescription() ?? 'unknown';
      _fail(
        Gemma3nServiceState.unavailable,
        InferenceErrorKind.unavailable,
        'Gemma LiteRT-LM requires an arm64-v8a Android device '
        '(physical phone or ARM 64-bit emulator). This device reports: $abi. '
        'x86/x86_64 emulators cannot run .litertlm models.',
      );
      return;
    }
    await ensureManifestLoaded();
    if (await isModelReady()) {
      _state = Gemma3nServiceState.ready;
      notifyListeners();
      return;
    }
    if (_huggingFaceToken == null) {
      _fail(
        Gemma3nServiceState.failed,
        InferenceErrorKind.modelFile,
        'Hugging Face token missing. Set environment variable HUGGINGFACE_TOKEN '
        '(e.g. Android Studio Run configuration) or '
        '--dart-define=HUGGINGFACE_TOKEN=…',
      );
      return;
    }

    _state = Gemma3nServiceState.loading;
    _lastError = null;
    notifyListeners();
    _installCancelToken = CancelToken();
    final loadStart = DateTime.now();
    try {
      await _client.installFromHuggingFace(
        hfRepo: _manifest!.hfRepo,
        artifactFileName: _manifest!.artifactFileName,
        huggingFaceToken: _huggingFaceToken,
        onProgress: onProgress,
        cancelToken: _installCancelToken,
      );
      await _client.warmUpRuntime(
        hfRepo: _manifest!.hfRepo,
        huggingFaceToken: _huggingFaceToken,
      );
      final loadDuration = DateTime.now().difference(loadStart);
      _state = Gemma3nServiceState.ready;
      _lastError = null;
      notifyListeners();
      debugPrint(
        'Gemma3nLitertService: model installed in ${loadDuration.inMilliseconds}ms',
      );
    } on DownloadCancelledException {
      _fail(
        Gemma3nServiceState.notLoaded,
        InferenceErrorKind.cancelled,
        'Model download cancelled',
      );
    } catch (e, st) {
      final kind = _mapInstallError(e);
      _fail(Gemma3nServiceState.failed, kind, _formatInstallError(e));
      debugPrint('Gemma3nLitertService install stack: $st');
    } finally {
      _installCancelToken = null;
    }
  }

  void cancelDownload() {
    _installCancelToken?.cancel('User cancelled download');
  }

  Future<InferenceResult> analyzeImage({
    required String imagePath,
    String instruction = kGemma3nPrescriptionSpikePrompt,
    void Function(String partial)? onPartial,
  }) async {
    if (_state == Gemma3nServiceState.disposed) {
      return const InferenceResult(
        errorKind: InferenceErrorKind.disposed,
        errorMessage: 'Service disposed',
      );
    }
    if (!await isModelReady()) {
      return const InferenceResult(
        errorKind: InferenceErrorKind.notLoaded,
        errorMessage: 'Model not installed',
      );
    }
    final epoch = ++_generationEpoch;
    _state = Gemma3nServiceState.running;
    _lastError = null;
    notifyListeners();

    Uint8List bytes;
    try {
      bytes = await File(imagePath).readAsBytes();
    } catch (_) {
      _state = Gemma3nServiceState.ready;
      notifyListeners();
      return const InferenceResult(
        errorKind: InferenceErrorKind.imageDecode,
        errorMessage: 'Could not read image file',
      );
    }

    final inferStart = DateTime.now();
    try {
      await ensureManifestLoaded();
      final text = await _client.analyzeImage(
        hfRepo: _manifest!.hfRepo,
        imageBytes: bytes,
        instruction: instruction,
        huggingFaceToken: _huggingFaceToken,
        onToken: onPartial,
      );
      if (epoch != _generationEpoch || _state == Gemma3nServiceState.disposed) {
        return const InferenceResult(
          errorKind: InferenceErrorKind.cancelled,
          errorMessage: 'Stale inference result discarded',
        );
      }
      _state = Gemma3nServiceState.ready;
      notifyListeners();
      return InferenceResult(
        text: text,
        inferenceDuration: DateTime.now().difference(inferStart),
        tokensApprox: text.split(RegExp(r'\s+')).length,
      );
    } catch (e, st) {
      if (epoch != _generationEpoch) {
        return const InferenceResult(
          errorKind: InferenceErrorKind.cancelled,
          errorMessage: 'Inference cancelled',
        );
      }
      final kind = _mapInferError(e);
      final message = _formatInferError(e);
      _state = Gemma3nServiceState.failed;
      _lastError = message;
      notifyListeners();
      debugPrint('Gemma3nLitertService inference stack: $st');
      return InferenceResult(
        errorKind: kind,
        errorMessage: message,
        inferenceDuration: DateTime.now().difference(inferStart),
      );
    }
  }

  Future<void> cancelInference() async {
    _generationEpoch++;
    await _client.cancelInference();
    if (_state == Gemma3nServiceState.running) {
      _state = Gemma3nServiceState.ready;
      notifyListeners();
    }
  }

  @override
  Future<void> dispose() async {
    _generationEpoch++;
    _installCancelToken?.cancel('Service disposed');
    await _client.cancelInference();
    await _client.releaseRuntime();
    _state = Gemma3nServiceState.disposed;
    super.dispose();
  }

  void _fail(
    Gemma3nServiceState next,
    InferenceErrorKind kind,
    String message,
  ) {
    _state = next;
    _lastError = message;
    notifyListeners();
    debugPrint('Gemma3nLitertService: $kind — $message');
  }

  static String _formatInstallError(Object e) {
    final detail = e.toString().trim();
    if (detail.isEmpty) return 'Model install failed (unknown error)';
    if (detail.contains('DownloadException') ||
        detail.contains('ModelDownloadException')) {
      return detail;
    }
    return 'Model install failed: $detail';
  }

  InferenceErrorKind _mapInstallError(Object e) {
    final s = e.toString().toLowerCase();
    if (s.contains('memory') || s.contains('oom')) {
      return InferenceErrorKind.insufficientMemory;
    }
    if (s.contains('401') || s.contains('403') || s.contains('gated')) {
      return InferenceErrorKind.modelFile;
    }
    return InferenceErrorKind.modelFile;
  }

  static String _formatInferError(Object e) {
    final detail = e.toString().trim();
    if (detail.isEmpty) return 'Inference failed (unknown error)';
    return detail.startsWith('Inference failed')
        ? detail
        : 'Inference failed: $detail';
  }

  InferenceErrorKind _mapInferError(Object e) {
    final s = e.toString().toLowerCase();
    if (s.contains('memory') || s.contains('oom')) {
      return InferenceErrorKind.insufficientMemory;
    }
    if (s.contains('decode')) {
      return InferenceErrorKind.imageDecode;
    }
    return InferenceErrorKind.inference;
  }
}
