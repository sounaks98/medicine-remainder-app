import 'dart:io';

import 'package:medicine_remainder_app/services/inference/gemma/gemma_platform_client.dart';
import 'package:medicine_remainder_app/shared/platform/device_abi.dart';

/// Idempotent install-time Gemma weights: concat packaged chunks on device.
class ModelAssetManager {
  ModelAssetManager({GemmaPlatformClient? client})
      : _client = client ?? GemmaPlatformClient();

  final GemmaPlatformClient _client;
  GemmaModelStatus? _lastStatus;

  GemmaModelStatus? get lastStatus => _lastStatus;

  Future<GemmaModelStatus> refreshStatus() async {
    final status = await _client.checkModelStatus();
    _lastStatus = status;
    return status;
  }

  /// Weights are present in the APK/AAB (CHECKSUM in assets).
  Future<bool> isPackagedInApp() async {
    final status = await refreshStatus();
    return deviceSupportsLitertLm && status.packaged;
  }

  /// Packaged and passes native RAM / ABI checks before loading weights.
  Future<bool> isModelReady() async {
    final status = await refreshStatus();
    return status.isCompatible && deviceSupportsLitertLm && status.packaged;
  }

  Future<bool> isMaterialized() async {
    final status = await refreshStatus();
    return status.materialized;
  }

  Future<String> ensureMaterialized({
    void Function(double progress)? onProgress,
  }) async {
    final status = await refreshStatus();
    if (!status.packaged) {
      throw StateError('Gemma model not packaged in this build');
    }
    status.compatibilityError?.let((message) => throw StateError(message));

    _client.listen((event, data) {
      if (event == 'modelInitializationProgress') {
        final fraction = (data['fraction'] as num?)?.toDouble() ?? 0;
        onProgress?.call(fraction);
      }
    });

    if (status.materialized) {
      onProgress?.call(1);
      return '';
    }
    return _client.materializeModel();
  }

  Future<void> initializeEngine({
    void Function(double progress)? onProgress,
  }) async {
    await ensureMaterialized(onProgress: onProgress);
    await _client.initializeModel();
  }

  Future<void> release() async {
    await _client.releaseModel();
  }

  Future<void> dispose() async {
    await _client.dispose();
  }
}

extension<T> on T {
  R let<R>(R Function(T value) block) => block(this);
}
