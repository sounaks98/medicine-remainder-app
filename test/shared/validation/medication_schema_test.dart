import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/shared/models/field_confidence.dart';
import 'package:medicine_remainder_app/shared/models/medication_extraction_draft.dart';
import 'package:medicine_remainder_app/shared/models/medication_field.dart';
import 'package:medicine_remainder_app/shared/validation/medication_schema.dart';

void main() {
  test('encodeDraft round-trips through parseDraftJson', () {
    final draft = MedicationExtractionDraft(
      schemaVersion: MedicationSchema.currentVersion,
      prescriptionId: 'rx-1',
      userId: 'user-1',
      medicines: [
        MedicineDraft(
          name: const MedicationField<String>(
            value: 'Metformin',
            confidence: FieldConfidence.uncertain,
            provenance: Provenance.rules,
          ),
          strength: const MedicationField<String>(
            value: '500',
            confidence: FieldConfidence.uncertain,
            provenance: Provenance.rules,
          ),
          strengthUnit: const MedicationField<String>(
            value: 'mg',
            confidence: FieldConfidence.uncertain,
            provenance: Provenance.rules,
          ),
          doseInstructions: const MedicationField<String>(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          route: const MedicationField<String>(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          frequency: const MedicationField<String>(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          duration: const MedicationField<String>(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          timing: const MedicationField<String>(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          startAt: const MedicationField<String>(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          endAt: const MedicationField<String>(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          originalSourceText: const MedicationField<String>(
            value: 'Metformin 500mg',
            confidence: FieldConfidence.uncertain,
            provenance: Provenance.rules,
          ),
        ),
      ],
      rawOcrText: 'Metformin 500mg',
      extractionMethod: ExtractionMethod.ocrRules,
      createdAt: DateTime.utc(2026, 1, 2, 3, 4, 5),
    );

    final json = MedicationSchema.encodeDraft(draft);
    final parsed = MedicationSchema.parseDraftJson(json);
    expect(parsed.isSuccess, isTrue);
    expect(parsed.draft!.prescriptionId, 'rx-1');
    expect(parsed.draft!.medicines.single.name.value, 'Metformin');
  });

  test('parseDraftJson rejects malformed JSON without throwing', () {
    final result = MedicationSchema.parseDraftJson('{not json');
    expect(result.isSuccess, isFalse);
    expect(result.errorMessage, contains('Invalid JSON'));
  });

  test('parseDraftJson rejects extra root keys from VLM output', () {
    const raw = '''
{
  "schemaVersion": 1,
  "prescriptionId": "rx",
  "userId": "u",
  "medicines": [],
  "extractionMethod": "smolvlm_onnx",
  "createdAt": "2026-01-01T00:00:00.000Z",
  "hallucinatedDose": true
}
''';
    final result = MedicationSchema.parseDraftJson(raw);
    expect(result.isSuccess, isFalse);
    expect(result.errorMessage, contains('Unexpected root keys'));
  });
}
