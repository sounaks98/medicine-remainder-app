import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/shared/models/field_confidence.dart';
import 'package:medicine_remainder_app/shared/models/medication_extraction_draft.dart';
import 'package:medicine_remainder_app/shared/models/medication_field.dart';
import 'package:medicine_remainder_app/shared/validation/extraction_validator.dart';

void main() {
  const validator = ExtractionValidator();

  test('blocks auto schedule until human confirms', () {
    expect(
      validator.canAutoSchedule(
        reviewStatus: ReviewStatus.draft,
        confirmedByUser: false,
      ),
      isFalse,
    );
    expect(
      validator.canAutoSchedule(
        reviewStatus: ReviewStatus.confirmed,
        confirmedByUser: true,
      ),
      isTrue,
    );
  });

  test('validateDraft requires medicine name', () {
    final draft = MedicationExtractionDraft(
      schemaVersion: 1,
      prescriptionId: 'rx',
      userId: 'user',
      medicines: [
        MedicineDraft(
          name: const MedicationField<String>(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          strength: const MedicationField<String>(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          strengthUnit: const MedicationField<String>(
            confidence: FieldConfidence.missing,
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
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
        ),
      ],
      extractionMethod: ExtractionMethod.ocrRules,
      createdAt: DateTime.now().toUtc(),
    );

    final result = validator.validateDraft(draft);
    expect(result.canConfirm, isFalse);
    expect(result.blocksAutoSchedule, isTrue);
  });
}
