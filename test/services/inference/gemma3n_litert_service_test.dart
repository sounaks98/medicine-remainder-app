import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_edge_ai/flutter_edge_ai.dart';
import 'package:medicine_remainder_app/services/inference/gemma3n_litert_client.dart';
import 'package:medicine_remainder_app/services/inference/gemma3n_litert_service.dart';
import 'package:medicine_remainder_app/services/inference/inference_result.dart';

class _FakeGemmaClient implements Gemma3nLitertClient {
  bool installed = false;
  bool cancelInferenceCalled = false;
  bool warmUpCalled = false;

  @override
  Future<bool> isModelInstalled(String modelFileName) async => installed;

  @override
  Future<void> installFromHuggingFace({
    required String hfRepo,
    String? artifactFileName,
    String? huggingFaceToken,
    void Function(int percent)? onProgress,
    CancelToken? cancelToken,
  }) async {
    onProgress?.call(100);
    installed = true;
  }

  @override
  Future<void> warmUpRuntime({
    required String hfRepo,
    String? huggingFaceToken,
  }) async {
    warmUpCalled = true;
  }

  @override
  Future<String> analyzeImage({
    required String hfRepo,
    required Uint8List imageBytes,
    required String instruction,
    String? huggingFaceToken,
    void Function(String token)? onToken,
  }) async {
    onToken?.call('ok');
    return 'ok';
  }

  @override
  Future<void> cancelInference() async {
    cancelInferenceCalled = true;
  }

  @override
  Future<void> releaseRuntime() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loadModel transitions to ready when client reports installed', () async {
    final client = _FakeGemmaClient();
    final service = Gemma3nLitertService(
      client: client,
      huggingFaceToken: 'test-token',
    );
    await service.loadModel();
    expect(service.state, Gemma3nServiceState.ready);
    expect(client.warmUpCalled, isTrue);
    expect(await service.isModelReady(), isTrue);
    await service.dispose();
  });

  test('analyzeImage returns notLoaded when model missing', () async {
    final service = Gemma3nLitertService(client: _FakeGemmaClient());
    final result = await service.analyzeImage(imagePath: 'missing.jpg');
    expect(result.errorKind, InferenceErrorKind.notLoaded);
    await service.dispose();
  });
}
