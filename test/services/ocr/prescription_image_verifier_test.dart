import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/services/ocr/prescription_image_verifier.dart';
import 'package:medicine_remainder_app/shared/models/prescription_likelihood.dart';

void main() {
  test('likely when medication and clinician cues present', () async {
    final verifier = PrescriptionImageVerifier();
    final result = await verifier.verify(
      imagePath: '/tmp/rx.jpg',
      ocrText: '''
Dr. Patel
City Hospital
Amoxicillin 500 mg tablet
Take 1 tab twice daily for 7 days
''',
    );

    expect(result.likelihood, PrescriptionLikelihood.likely);
    expect(result.vlmAssisted, isFalse);
  });

  test('unlikely when OCR text is too short', () async {
    final verifier = PrescriptionImageVerifier();
    final result = await verifier.verify(
      imagePath: '/tmp/x.jpg',
      ocrText: 'hello',
    );

    expect(result.likelihood, PrescriptionLikelihood.unlikely);
  });
}
