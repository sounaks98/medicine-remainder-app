import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/services/inference/gemma/gemma_platform_client.dart';

void main() {
  test('isCompatible requires arm64 and no errors', () {
    const ok = GemmaModelStatus(
      packaged: true,
      materialized: true,
      engineReady: false,
      arm64: true,
    );
    expect(ok.isCompatible, isTrue);

    const x86 = GemmaModelStatus(
      packaged: true,
      materialized: true,
      engineReady: false,
      arm64: false,
    );
    expect(x86.isCompatible, isFalse);

    const ram = GemmaModelStatus(
      packaged: true,
      materialized: false,
      engineReady: false,
      arm64: true,
      compatibilityError: 'Insufficient RAM',
    );
    expect(ram.isCompatible, isFalse);
  });

  test('fromMap parses checksum metadata fields', () {
    final status = GemmaModelStatus.fromMap({
      'packaged': true,
      'materialized': false,
      'engineReady': false,
      'arm64': true,
      'expectedSha256': 'abc123',
      'expectedSizeBytes': 1234567890,
    });
    expect(status.packaged, isTrue);
    expect(status.expectedSha256, 'abc123');
    expect(status.expectedSizeBytes, 1234567890);
  });
}
