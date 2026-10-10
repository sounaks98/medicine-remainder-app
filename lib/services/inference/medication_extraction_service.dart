import 'package:medicine_remainder_app/features/medicines/domain/medication_draft.dart';

/// Swappable on-device extraction (OCR rules vs SmolVLM ONNX).
abstract class MedicationExtractionService {
  Future<ExtractionCapability> getCapability();

  Future<MedicationExtractionDraft> extract(ExtractionRequest request);

  Future<void> dispose();
}

class ExtractionRequest {
  const ExtractionRequest({
    required this.imagePath,
    required this.ocrText,
  });

  final String imagePath;
  final String ocrText;
}

class ExtractionCapability {
  const ExtractionCapability({
    required this.supportsVlm,
    required this.modelDownloaded,
  });

  final bool supportsVlm;
  final bool modelDownloaded;
}
