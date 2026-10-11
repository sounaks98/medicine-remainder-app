import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/data/database/app_database.dart';
import 'package:medicine_remainder_app/features/medicines/data/drift_medicine_repository.dart';
import 'package:medicine_remainder_app/features/medicines/domain/medication_record.dart';
import 'package:medicine_remainder_app/features/prescription/data/prescription_image_store.dart';
import 'package:medicine_remainder_app/features/prescription/data/prescription_repository.dart';
import 'package:medicine_remainder_app/services/security/prescription_image_cipher.dart';
import 'package:medicine_remainder_app/shared/models/field_confidence.dart';

void main() {
  late Directory root;
  late AppDatabase db;
  late PrescriptionImageStore imageStore;
  late PrescriptionRepository prescriptionRepository;
  late DriftMedicineRepository medicineRepository;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('rx_delete_cascade');
    db = AppDatabase.forTesting();
    final cipher = await PrescriptionImageCipher.loadOrCreate(
      testKeyBytes: List<int>.generate(32, (i) => i + 1),
    );
    imageStore = PrescriptionImageStore(
      rootDirectory: root,
      cipher: cipher,
      encryptAtRest: true,
    );
    prescriptionRepository = PrescriptionRepository(
      database: db,
      imageStore: imageStore,
    );
    medicineRepository = DriftMedicineRepository(db);
  });

  tearDown(() async {
    await db.close();
    if (await root.exists()) {
      await root.delete(recursive: true);
    }
  });

  test('deletePrescription removes medicines and encrypted image file', () async {
    const userId = 'user-cascade';
    const prescriptionId = 'rx-cascade';
    final imagePath = await imageStore.saveTemporary(
      [9, 8, 7],
      mimeType: 'image/jpeg',
    );
    expect(File(imagePath).existsSync(), isTrue);

    final now = DateTime.utc(2026, 2, 1);
    await prescriptionRepository.save(
      PrescriptionRecord(
        id: prescriptionId,
        userId: userId,
        capturedAt: now,
        source: 'gallery',
        imagePath: imagePath,
        reviewStatus: ReviewStatus.confirmed,
        humanReviewedAt: now,
        createdAt: now,
        updatedAt: now,
      ),
    );

    await medicineRepository.save(
      MedicationRecord(
        id: 'med-1',
        userId: userId,
        prescriptionId: prescriptionId,
        name: 'Drug',
        strength: '10',
        strengthUnit: 'mg',
        doseInstructions: '',
        route: '',
        frequency: 'daily',
        duration: '',
        timing: '',
        reviewStatus: ReviewStatus.confirmed,
        confirmedAt: now,
        confirmedByUser: true,
        frequencyConfidence: FieldConfidence.known,
      ),
    );

    await prescriptionRepository.deletePrescription(prescriptionId);

    final medicines = await (db.select(db.medicines)).get();
    expect(medicines, isEmpty);
    expect(File(imagePath).existsSync(), isFalse);
  });
}
