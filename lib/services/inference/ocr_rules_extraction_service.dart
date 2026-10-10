import 'package:medicine_remainder_app/features/medicines/domain/medication_draft.dart';
import 'package:medicine_remainder_app/services/inference/medication_extraction_service.dart';

/// Baseline parser over OCR text (P1-06).
class OcrRulesExtractionService implements MedicationExtractionService {
  @override
  Future<ExtractionCapability> getCapability() async {
    return const ExtractionCapability(
      supportsVlm: false,
      modelDownloaded: false,
    );
  }

  @override
  Future<MedicationExtractionDraft> extract(ExtractionRequest request) {
    throw UnimplementedError('P1-06');
  }

  @override
  Future<void> dispose() async {}
}
