import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class GemmaModelStatus {
  const GemmaModelStatus({
    required this.packaged,
    required this.materialized,
    required this.engineReady,
    this.arm64 = false,
    this.compatibilityError,
    this.expectedSha256,
    this.expectedSizeBytes,
    this.error,
  });

  final bool packaged;
  final bool materialized;
  final bool engineReady;
  final bool arm64;
  final String? compatibilityError;
  final String? expectedSha256;
  final int? expectedSizeBytes;
  final String? error;

  bool get isCompatible =>
      arm64 && compatibilityError == null && error == null;

  factory GemmaModelStatus.fromMap(Map<dynamic, dynamic> raw) {
    return GemmaModelStatus(
      packaged: raw['packaged'] == true,
      materialized: raw['materialized'] == true,
      engineReady: raw['engineReady'] == true,
      arm64: raw['arm64'] == true,
      compatibilityError: raw['compatibilityError'] as String?,
      expectedSha256: raw['expectedSha256'] as String?,
      expectedSizeBytes: (raw['expectedSizeBytes'] as num?)?.toInt(),
      error: raw['error'] as String?,
    );
  }
}

typedef GemmaEventHandler = void Function(String event, Map<String, dynamic> data);

class GemmaPlatformClient {
  GemmaPlatformClient({
    MethodChannel? methodChannel,
    EventChannel? eventChannel,
  })  : _methodChannel =
            methodChannel ?? const MethodChannel('com.prescriptionreader/gemma'),
        _eventChannel =
            eventChannel ??
            const EventChannel('com.prescriptionreader/gemma_events');

  final MethodChannel _methodChannel;
  final EventChannel _eventChannel;

  StreamSubscription<dynamic>? _eventSub;

  void listen(GemmaEventHandler onEvent) {
    _eventSub?.cancel();
    _eventSub = _eventChannel.receiveBroadcastStream().listen(
      (payload) {
        if (payload is! Map) return;
        final event = payload['event'] as String? ?? '';
        final data = Map<String, dynamic>.from(
          (payload['data'] as Map?)?.cast<String, dynamic>() ?? const {},
        );
        onEvent(event, data);
      },
      onError: (Object error) {
        debugPrint('GemmaPlatformClient event error: $error');
      },
    );
  }

  Future<void> dispose() async {
    await _eventSub?.cancel();
    _eventSub = null;
  }

  Future<GemmaModelStatus> checkModelStatus() async {
    try {
      final raw = await _methodChannel.invokeMethod<Map<dynamic, dynamic>>(
        'checkModelStatus',
      );
      if (raw != null) {
        return GemmaModelStatus.fromMap(raw);
      }
    } on MissingPluginException {
      // Host tests drive the channel via TestDefaultBinaryMessengerBinding.
    }
    if (!Platform.isAndroid) {
      return const GemmaModelStatus(
        packaged: false,
        materialized: false,
        engineReady: false,
        error: 'Gemma packaging is Android-only',
      );
    }
    return GemmaModelStatus.fromMap(const {});
  }

  Future<void> initializeModel() async {
    await _methodChannel.invokeMethod<void>('initializeModel');
  }

  Future<String> materializeModel() async {
    final raw = await _methodChannel.invokeMethod<Map<dynamic, dynamic>>(
      'materializeModel',
    );
    return raw?['modelPath'] as String? ?? '';
  }

  Future<Map<String, dynamic>> processPrescriptionImage({
    required String imagePath,
    required String systemPrompt,
    required String userPrompt,
  }) async {
    final raw = await _methodChannel.invokeMethod<dynamic>(
      'processPrescriptionImage',
      {
        'imagePath': imagePath,
        'systemPrompt': systemPrompt,
        'userPrompt': userPrompt,
      },
    );
  if (raw is Map) {
      return Map<String, dynamic>.from(raw.cast<String, dynamic>());
    }
    throw StateError('Unexpected Gemma inference response type');
  }

  Future<void> cancelInference() async {
    await _methodChannel.invokeMethod<void>('cancelInference');
  }

  Future<void> releaseModel() async {
    await _methodChannel.invokeMethod<void>('releaseModel');
  }
}
