import 'package:medicine_remainder_app/features/medicines/domain/medication_draft.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_ehr_draft.dart';
import 'package:medicine_remainder_app/services/ocr/prescription_image_verifier.dart';
import 'package:medicine_remainder_app/shared/models/prescription_likelihood.dart';

/// Single merged output shown in review (OCR + rules + optional VLM).
class PrescriptionReviewBundle {
  const PrescriptionReviewBundle({
    required this.verification,
    required this.draft,
    required this.ehr,
    required this.extractionMethodLabel,
  });

  final PrescriptionVerificationResult verification;
  final MedicationExtractionDraft draft;
  final PrescriptionEhrDraft ehr;
  final String extractionMethodLabel;

  PrescriptionLikelihood get likelihood => verification.likelihood;
}
