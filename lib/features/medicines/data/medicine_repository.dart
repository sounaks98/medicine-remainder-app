import 'package:medicine_remainder_app/features/medicines/domain/medication_record.dart';

/// CRUD for confirmed medications (Drift-backed in P5-02).
abstract class MedicineRepository {
  Future<List<MedicationRecord>> listConfirmed();

  Future<MedicationRecord> save(MedicationRecord record);

  Future<void> delete(String id);
}
