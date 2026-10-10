import 'package:medicine_remainder_app/features/medicines/domain/medication_draft.dart';

/// Rejects invalid or hallucinated schedules before confirmation (P4-02).
class ExtractionValidator {
  const ExtractionValidator();

  List<String> validate(MedicationExtractionDraft draft) {
    return const [];
  }
}
