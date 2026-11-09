import 'package:medicine_remainder_app/data/database/app_database.dart';

class DriftReminderRepository {
  DriftReminderRepository(this._db);

  final AppDatabase _db;

  Future<void> insertPendingEvent({
    required String id,
    required String userId,
    required String medicineId,
    required DateTime fireAt,
  }) async {
    await _db.into(_db.reminderEvents).insert(
      ReminderEventsCompanion.insert(
        id: id,
        userId: userId,
        medicineId: medicineId,
        fireAt: fireAt.toUtc(),
        status: 'pending',
        createdAt: DateTime.now().toUtc(),
      ),
    );
  }

  Future<List<String>> listEventIdsForMedicine(String medicineId) async {
    final query = _db.select(_db.reminderEvents)
      ..where((tbl) => tbl.medicineId.equals(medicineId));
    final rows = await query.get();
    return rows.map((row) => row.id).toList();
  }

  Future<void> deleteEventsForMedicine(String medicineId) async {
    await (_db.delete(_db.reminderEvents)
          ..where((tbl) => tbl.medicineId.equals(medicineId)))
        .go();
  }
}
