import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/services/inference/gemma/model_asset_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const methodChannel = MethodChannel('com.prescriptionreader/gemma');
  const eventChannel = MethodChannel('com.prescriptionreader/gemma_events');

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(eventChannel, null);
  });

  test('refreshStatus on non-Android reports Android-only error', () async {
    if (Platform.isAndroid) {
      return;
    }
    final manager = ModelAssetManager();
    final status = await manager.refreshStatus();
    expect(status.packaged, isFalse);
    expect(status.error, contains('Android-only'));
  });

  test('ensureMaterialized skips native concat when already materialized', () async {
    var materializeCalls = 0;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, (call) async {
      switch (call.method) {
        case 'checkModelStatus':
          return {
            'packaged': true,
            'materialized': true,
            'engineReady': false,
            'arm64': true,
          };
        case 'materializeModel':
          materializeCalls++;
          return {'modelPath': '/data/gemma.litertlm'};
        default:
          return null;
      }
    });

    final manager = ModelAssetManager();
    double? lastProgress;
    await manager.ensureMaterialized(onProgress: (p) => lastProgress = p);

    expect(materializeCalls, 0);
    expect(lastProgress, 1.0);
  });

  test('ensureMaterialized throws when model not packaged', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, (call) async {
      if (call.method == 'checkModelStatus') {
        return {
          'packaged': false,
          'materialized': false,
          'engineReady': false,
          'arm64': true,
        };
      }
      return null;
    });

    final manager = ModelAssetManager();
    expect(
      () => manager.ensureMaterialized(),
      throwsA(isA<StateError>()),
    );
  });

  test('ensureMaterialized throws compatibility error from native gate', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, (call) async {
      if (call.method == 'checkModelStatus') {
        return {
          'packaged': true,
          'materialized': false,
          'engineReady': false,
          'arm64': true,
          'compatibilityError': 'Not enough RAM for Gemma',
        };
      }
      return null;
    });

    final manager = ModelAssetManager();
    expect(
      () => manager.ensureMaterialized(),
      throwsA(
        predicate(
          (e) => e is StateError && e.message.contains('Not enough RAM'),
        ),
      ),
    );
  });

  test('ensureMaterialized invokes materialize once when not yet on disk', () async {
    var materializeCalls = 0;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, (call) async {
      switch (call.method) {
        case 'checkModelStatus':
          return {
            'packaged': true,
            'materialized': false,
            'engineReady': false,
            'arm64': true,
          };
        case 'materializeModel':
          materializeCalls++;
          return {'modelPath': '/data/gemma.litertlm'};
        default:
          return null;
      }
    });

    final manager = ModelAssetManager();
    final path = await manager.ensureMaterialized();
    expect(path, '/data/gemma.litertlm');
    expect(materializeCalls, 1);
  });
}
