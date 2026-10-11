import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/data/database/app_database.dart';
import 'package:medicine_remainder_app/features/medicines/data/drift_medicine_repository.dart';
import 'package:medicine_remainder_app/features/medicines/domain/medication_record.dart';
import 'package:medicine_remainder_app/features/prescription/data/prescription_image_store.dart';
import 'package:medicine_remainder_app/features/prescription/data/prescription_repository.dart';
import 'package:medicine_remainder_app/shared/models/field_confidence.dart';

void main() {
  late AppDatabase db;
  late DriftMedicineRepository repository;

  setUp(() {
    db = AppDatabase.forTesting();
    repository = DriftMedicineRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('save and listConfirmed round-trip', () async {
    final record = MedicationRecord(
      id: 'med-1',
      userId: 'user-1',
      prescriptionId: 'rx-1',
      name: 'Paracetamol',
      strength: '500',
      strengthUnit: 'mg',
      doseInstructions: '1 tab',
      route: 'oral',
      frequency: 'daily',
      duration: '3 days',
      timing: 'morning',
      reviewStatus: ReviewStatus.confirmed,
      confirmedAt: DateTime.utc(2026, 3, 1),
      confirmedByUser: true,
      frequencyConfidence: FieldConfidence.known,
    );

    final prescriptionRepository = PrescriptionRepository(
      database: db,
      imageStore: const PrescriptionImageStore(encryptAtRest: false),
    );
    await prescriptionRepository.save(
      PrescriptionRecord(
        id: 'rx-1',
        userId: 'user-1',
        capturedAt: DateTime.utc(2026, 3, 1),
        source: 'manual',
        reviewStatus: ReviewStatus.confirmed,
        humanReviewedAt: DateTime.utc(2026, 3, 1),
        createdAt: DateTime.utc(2026, 3, 1),
        updatedAt: DateTime.utc(2026, 3, 1),
      ),
    );

    await repository.save(record);
    final listed = await repository.listConfirmed(userId: 'user-1');
    expect(listed.single.name, 'Paracetamol');
  });
}
