import 'package:medicine_remainder_app/features/prescription/domain/prescription_review_bundle.dart';
import 'package:medicine_remainder_app/services/ocr/ocr_result.dart';
import 'package:medicine_remainder_app/services/ocr/prescription_image_verifier.dart';

class DocumentCheckResult {
  const DocumentCheckResult({
    required this.ocr,
    required this.verification,
  });

  final OcrResult ocr;
  final PrescriptionVerificationResult verification;
}

abstract class PrescriptionExtractionPipeline {
  Future<DocumentCheckResult> checkDocument({required String imagePath});

  Future<PrescriptionReviewBundle> extractUnified({
    required String imagePath,
    required OcrResult cachedOcr,
  });
}
