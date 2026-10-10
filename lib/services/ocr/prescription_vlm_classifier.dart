import 'package:medicine_remainder_app/shared/models/prescription_likelihood.dart';

/// Optional SmolVLM assist for document-type classification (Phase 3+).
abstract class PrescriptionVlmClassifier {
  Future<PrescriptionLikelihood?> classifyPrescription({
    required String imagePath,
  });
}

/// Placeholder until ONNX models are installed and Phase 2 go/no-go is complete.
class UnavailablePrescriptionVlmClassifier implements PrescriptionVlmClassifier {
  @override
  Future<PrescriptionLikelihood?> classifyPrescription({
    required String imagePath,
  }) async {
    return null;
  }
}
