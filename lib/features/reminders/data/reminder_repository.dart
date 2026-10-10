/// Persist scheduled reminder events (P6).
abstract class ReminderRepository {
  Future<void> upsertEventsForMedicine(String medicineId);

  Future<void> cancelForMedicine(String medicineId);
}
