import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/features/medicines/domain/medication_draft.dart';
import 'package:medicine_remainder_app/services/inference/gemma/gemma_prescription_mapper.dart';
import 'package:medicine_remainder_app/shared/models/field_confidence.dart';
import 'package:uuid/uuid.dart';

void main() {
  test('maps medicines into draft with gemma extraction method', () {
    final mapper = GemmaPrescriptionMapper(uuid: const Uuid());
    final draft = mapper.toDraft(
      json: {
        'medicines': [
          {
            'name': 'Metformin',
            'strength': '500 mg',
            'dose': '1 tablet',
            'frequency': 'twice daily',
            'duration': '30 days',
            'route': 'oral',
            'instructions': 'with meals',
            'confidence': 'high',
            'needs_verification': false,
          },
        ],
      },
      rawModelOutput: '{"medicines":[]}',
      ocrText: 'ocr',
      userId: 'user-1',
    );

    expect(draft.extractionMethod, ExtractionMethod.gemma3n);
    expect(draft.userId, 'user-1');
    expect(draft.medicines, hasLength(1));
    final med = draft.medicines.single;
    expect(med.name.value, 'Metformin');
    expect(med.name.confidence, FieldConfidence.known);
    expect(med.doseInstructions.value, '1 tablet');
    expect(med.frequency.value, 'twice daily');
  });

  test('downgrades confidence when needs_verification or missing dose', () {
    final mapper = GemmaPrescriptionMapper();
    final uncertain = mapper.toDraft(
      json: {
        'medicines': [
          {
            'name': 'Aspirin',
            'confidence': 'high',
            'needs_verification': true,
          },
        ],
      },
      rawModelOutput: '{}',
      ocrText: '',
      userId: 'u',
    );
    expect(uncertain.medicines.single.name.confidence, FieldConfidence.uncertain);

    final missingDose = mapper.toDraft(
      json: {
        'medicines': [
          {
            'name': 'Ibuprofen',
            'confidence': 'high',
            'needs_verification': false,
          },
        ],
      },
      rawModelOutput: '{}',
      ocrText: '',
      userId: 'u',
    );
    expect(missingDose.medicines.single.name.confidence, FieldConfidence.uncertain);
  });

  test('drops unknown medicine keys and skips non-map entries', () {
    final mapper = GemmaPrescriptionMapper();
    final draft = mapper.toDraft(
      json: {
        'medicines': [
          {
            'name': 'Paracetamol',
            'foo': 'bar',
            'confidence': 'medium',
          },
          'not-a-map',
        ],
      },
      rawModelOutput: '{}',
      ocrText: '',
      userId: 'u',
    );
    expect(draft.medicines, hasLength(1));
    expect(draft.medicines.single.name.value, 'Paracetamol');
    expect(draft.medicines.single.name.confidence, FieldConfidence.uncertain);
  });

  test('inserts empty medicine row when medicines array missing', () {
    final mapper = GemmaPrescriptionMapper();
    final draft = mapper.toDraft(
      json: const {'patient_name': 'Test'},
      rawModelOutput: '{}',
      ocrText: '',
      userId: 'u',
    );
    expect(draft.medicines, hasLength(1));
    expect(draft.medicines.single.name.confidence, FieldConfidence.missing);
  });
}
