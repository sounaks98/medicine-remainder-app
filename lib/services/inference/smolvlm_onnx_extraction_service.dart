import 'package:medicine_remainder_app/features/medicines/domain/medication_draft.dart';
import 'package:medicine_remainder_app/services/inference/medication_extraction_service.dart';

/// Gated SmolVLM ONNX implementation (Phase 3, go only).
class SmolVlmOnnxExtractionService implements MedicationExtractionService {
  @override
  Future<ExtractionCapability> getCapability() async {
    return const ExtractionCapability(
      supportsVlm: true,
      modelDownloaded: false,
    );
  }

  @override
  Future<MedicationExtractionDraft> extract(ExtractionRequest request) {
    throw UnimplementedError('P3-06');
  }

  @override
  Future<void> dispose() async {}
}
