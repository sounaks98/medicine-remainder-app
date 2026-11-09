import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:medicine_remainder_app/features/medicines/domain/medication_draft.dart';
import 'package:medicine_remainder_app/features/prescription/data/prescription_image_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:medicine_remainder_app/services/inference/gemma/gemma_platform_client.dart';
import 'package:medicine_remainder_app/services/inference/gemma/gemma_prescription_mapper.dart';
import 'package:medicine_remainder_app/services/inference/gemma/model_asset_manager.dart';
import 'package:medicine_remainder_app/services/inference/medication_extraction_service.dart';
import 'package:medicine_remainder_app/shared/platform/device_abi.dart';

const _systemPromptAsset = 'assets/prompts/prescription_extraction_system.txt';

class GemmaExtractionProgress {
  const GemmaExtractionProgress(this.label);
  final String label;
}

typedef GemmaProgressCallback = void Function(GemmaExtractionProgress progress);

/// Production on-device Gemma 3n extraction (install-time weights, no HF download).
class GemmaExtractionService implements MedicationExtractionService {
  GemmaExtractionService({
    ModelAssetManager? assetManager,
    GemmaPlatformClient? client,
    GemmaPrescriptionMapper? mapper,
    PrescriptionImageStore? imageStore,
  }) {
    _client = client ?? GemmaPlatformClient();
    _assetManager = assetManager ?? ModelAssetManager(client: _client);
    _mapper = mapper ?? GemmaPrescriptionMapper();
    _imageStore = imageStore ?? const PrescriptionImageStore();
  }

  late final ModelAssetManager _assetManager;
  late final GemmaPlatformClient _client;
  late final GemmaPrescriptionMapper _mapper;
  late final PrescriptionImageStore _imageStore;

  String? _systemPrompt;

  GemmaProgressCallback? onProgress;

  Future<GemmaModelStatus> modelStatus() => _assetManager.refreshStatus();

  @override
  Future<ExtractionCapability> getCapability() async {
    if (!Platform.isAndroid || !deviceSupportsLitertLm) {
      return const ExtractionCapability(
        supportsVlm: false,
        modelDownloaded: false,
      );
    }
    final status = await _assetManager.refreshStatus();
    return ExtractionCapability(
      supportsVlm: status.isCompatible,
      modelDownloaded: status.packaged,
    );
  }

  @override
  Future<MedicationExtractionDraft> extract(
    ExtractionRequest request,
  ) async {
    onProgress?.call(const GemmaExtractionProgress('Preparing AI model'));
    await _assetManager.refreshStatus();

    onProgress?.call(const GemmaExtractionProgress('Loading Gemma 3n'));
    await _assetManager.initializeEngine();

    final systemPrompt = await _loadSystemPrompt();
    const userPrompt =
        'Extract all medicines from this prescription image as JSON.';

    onProgress?.call(const GemmaExtractionProgress('Analyzing prescription'));
    final plainImagePath = await _materializePlainImageFile(request.imagePath);
    try {
      final json = await _client.processPrescriptionImage(
        imagePath: plainImagePath,
        systemPrompt: systemPrompt,
        userPrompt: userPrompt,
      );

      onProgress?.call(
        const GemmaExtractionProgress('Extracting medicine information'),
      );

      final rawOutput = jsonEncode(json);
      onProgress?.call(
        const GemmaExtractionProgress('Validating extracted information'),
      );

      return _mapper.toDraft(
        json: json,
        rawModelOutput: rawOutput,
        ocrText: request.ocrText,
        userId: request.userId,
      );
    } finally {
      await _deletePlainImageFile(plainImagePath);
    }
  }

  /// Store paths are often encrypted `.mrx`; native BitmapFactory needs a JPEG/PNG file.
  Future<String> _materializePlainImageFile(String storePath) async {
    final bytes = await _imageStore.readBytes(storePath);
    if (bytes.length < 4) {
      throw StateError('Prescription image is empty or unreadable');
    }
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/gemma_rx_${DateTime.now().microsecondsSinceEpoch}.jpg',
    );
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Future<void> _deletePlainImageFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<String> _loadSystemPrompt() async {
    if (_systemPrompt != null) return _systemPrompt!;
    _systemPrompt = await rootBundle.loadString(_systemPromptAsset);
    return _systemPrompt!;
  }

  @override
  Future<void> dispose() async {
    await _assetManager.release();
    await _assetManager.dispose();
    await _client.dispose();
  }
}
