import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_metadata_parser.dart';
import 'package:medicine_remainder_app/shared/models/field_confidence.dart';

void main() {
  test('parses labeled doctor and diagnosis lines', () {
    const parser = PrescriptionMetadataParser();
    final ehr = parser.parse('''
Dr: Anita Rao
Diagnosis: Type 2 diabetes
Metformin 500 mg
''');

    expect(ehr.doctorName.value, 'Anita Rao');
    expect(ehr.diagnosis.value, 'Type 2 diabetes');
    expect(ehr.doctorName.confidence, FieldConfidence.uncertain);
  });
}
