import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/features/prescription/data/prescription_image_store.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_import.dart';
import 'package:medicine_remainder_app/shared/models/field_confidence.dart';
import 'package:medicine_remainder_app/shared/models/medication_extraction_draft.dart';
import 'package:medicine_remainder_app/shared/models/medication_field.dart';

void main() {
  test('confirmExtraction stores in session when repository is absent', () async {
    final import = PrescriptionImport(
      imageStore: const PrescriptionImageStore(encryptAtRest: false),
    );
    final draft = _sampleDraft();

    final records = await import.confirmExtraction(
      draft: draft,
      userId: 'user-1',
    );

    expect(records, hasLength(1));
    expect(records.single.name, 'Ibuprofen');
    expect(import.sessionConfirmed, hasLength(1));
  });

  test('confirmExtraction throws when medicine name missing', () async {
    final import = PrescriptionImport(
      imageStore: const PrescriptionImageStore(encryptAtRest: false),
    );
    final draft = _sampleDraft(name: '');

    expect(
      () => import.confirmExtraction(draft: draft, userId: 'user-1'),
      throwsA(isA<ConfirmExtractionException>()),
    );
    expect(import.sessionConfirmed, isEmpty);
  });
}

MedicationExtractionDraft _sampleDraft({String name = 'Ibuprofen'}) {
  MedicationField<String> field(String value) {
    return MedicationField<String>(
      value: value,
      confidence: FieldConfidence.known,
      provenance: Provenance.user,
    );
  }

  return MedicationExtractionDraft(
    schemaVersion: 1,
    prescriptionId: 'rx-1',
    userId: '',
    medicines: [
      MedicineDraft(
        name: field(name),
        strength: field('200'),
        strengthUnit: field('mg'),
        doseInstructions: field('1 tablet'),
        route: field('oral'),
        frequency: field('twice daily'),
        duration: field('5 days'),
        timing: field('after meals'),
        startAt: field(''),
        endAt: field(''),
        originalSourceText: field('Ibuprofen 200 mg'),
      ),
    ],
    extractionMethod: ExtractionMethod.ocrRules,
    createdAt: DateTime.utc(2026, 1, 1),
  );
}
