import 'package:medicine_remainder_app/features/medicines/domain/medication_draft.dart';
import 'package:medicine_remainder_app/shared/models/field_confidence.dart';

/// EHR-style fields extracted from the prescription (unified review copy).
class PrescriptionEhrDraft {
  const PrescriptionEhrDraft({
    required this.doctorName,
    required this.facilityName,
    required this.diagnosis,
    required this.testsSuggested,
    required this.notes,
  });

  final MedicationField<String> doctorName;
  final MedicationField<String> facilityName;
  final MedicationField<String> diagnosis;
  final MedicationField<String> testsSuggested;
  final MedicationField<String> notes;

  static PrescriptionEhrDraft empty() {
    return const PrescriptionEhrDraft(
      doctorName: _missing,
      facilityName: _missing,
      diagnosis: _missing,
      testsSuggested: _missing,
      notes: _missing,
    );
  }

  static const _missing = MedicationField<String>(
    confidence: FieldConfidence.missing,
    provenance: Provenance.rules,
  );
}
