import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/features/medicines/domain/medication_draft.dart';
import 'package:medicine_remainder_app/services/inference/medication_extraction_service.dart';
import 'package:medicine_remainder_app/services/inference/ocr_rules_extraction_service.dart';
import 'package:medicine_remainder_app/shared/models/field_confidence.dart';

void main() {
  test('extract parses strength and name from a medicine line', () async {
    final service = OcrRulesExtractionService();

    final draft = await service.extract(
      const ExtractionRequest(
        imagePath: '/tmp/rx.jpg',
        ocrText: 'Metformin 500mg\nTake after meals',
      ),
    );

    expect(draft.schemaVersion, OcrRulesExtractionService.medicationSchemaVersion);
    expect(draft.prescriptionId, isNotEmpty);
    expect(draft.extractionMethod, ExtractionMethod.ocrRules);
    expect(draft.medicines, hasLength(1));

    final medicine = draft.medicines.single;
    expect(medicine.name.value, 'Metformin');
    expect(medicine.strength.value, '500');
    expect(medicine.strengthUnit.value, 'mg');
    expect(medicine.frequency.confidence, FieldConfidence.missing);
  });

  test('extract uses missing confidence when OCR text is empty', () async {
    final service = OcrRulesExtractionService();

    final draft = await service.extract(
      const ExtractionRequest(imagePath: '/tmp/blank.jpg', ocrText: '   '),
    );

    final medicine = draft.medicines.single;
    expect(medicine.name.confidence, FieldConfidence.missing);
    expect(medicine.originalSourceText.confidence, FieldConfidence.missing);
  });

  test('extract creates one row per medicine line', () async {
    final service = OcrRulesExtractionService();

    final draft = await service.extract(
      const ExtractionRequest(
        imagePath: '/tmp/rx.jpg',
        ocrText: 'Amoxicillin 500 mg\nIbuprofen 200 mg',
      ),
    );

    expect(draft.medicines, hasLength(2));
    expect(draft.medicines[0].name.value, 'Amoxicillin');
    expect(draft.medicines[1].name.value, 'Ibuprofen');
  });
}
