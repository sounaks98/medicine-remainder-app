import 'package:medicine_remainder_app/features/medicines/domain/medication_draft.dart';
import 'package:medicine_remainder_app/services/ocr/ocr_result.dart';

/// Use cases: import image, run OCR, request structured extraction.
class PrescriptionImport {
  const PrescriptionImport();

  Future<String> importFromGallery() {
    throw UnimplementedError('P1-01');
  }

  Future<OcrResult> runOcr(String imagePath) {
    throw UnimplementedError('P1-03');
  }

  Future<MedicationExtractionDraft> requestExtraction({
    required String imagePath,
    required OcrResult ocr,
  }) {
    throw UnimplementedError('P1-06');
  }
}
