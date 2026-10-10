import 'package:medicine_remainder_app/shared/models/field_confidence.dart';

/// Pre-confirmation extraction payload (`medication_schema_v1`).
class MedicationExtractionDraft {
  const MedicationExtractionDraft({
    required this.schemaVersion,
    required this.prescriptionId,
    required this.medicines,
    required this.rawOcrText,
    required this.extractionMethod,
    required this.createdAt,
    this.rawModelOutput,
  });

  final int schemaVersion;
  final String prescriptionId;
  final List<MedicineDraft> medicines;
  final String rawOcrText;
  final String? rawModelOutput;
  final ExtractionMethod extractionMethod;
  final DateTime createdAt;
}

enum ExtractionMethod {
  ocrOnly,
  ocrRules,
  smolvlmOnnx,
}

class MedicineDraft {
  const MedicineDraft({
    required this.name,
    required this.strength,
    required this.strengthUnit,
    required this.doseInstructions,
    required this.route,
    required this.frequency,
    required this.duration,
    required this.timing,
    required this.originalSourceText,
  });

  final MedicationField<String> name;
  final MedicationField<String> strength;
  final MedicationField<String> strengthUnit;
  final MedicationField<String> doseInstructions;
  final MedicationField<String> route;
  final MedicationField<String> frequency;
  final MedicationField<String> duration;
  final MedicationField<String> timing;
  final MedicationField<String> originalSourceText;
}

class MedicationField<T> {
  const MedicationField({
    this.value,
    required this.confidence,
    this.sourceText,
    required this.provenance,
    this.warnings = const [],
  });

  final T? value;
  final FieldConfidence confidence;
  final String? sourceText;
  final Provenance provenance;
  final List<String> warnings;
}
