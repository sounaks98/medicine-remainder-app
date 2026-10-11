import 'package:drift/drift.dart';
import 'package:medicine_remainder_app/data/database/app_database.dart';
import 'package:medicine_remainder_app/data/database/user_bootstrap.dart';
import 'package:medicine_remainder_app/features/medicines/data/medicine_repository.dart';
import 'package:medicine_remainder_app/features/medicines/domain/medication_record.dart';
import 'package:medicine_remainder_app/shared/models/field_confidence.dart';

class DriftMedicineRepository implements MedicineRepository {
  DriftMedicineRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<MedicationRecord>> listConfirmed({String? userId}) async {
    final query = _db.select(_db.medicines)
      ..where((tbl) {
        Expression<bool> expr = tbl.reviewStatus.equals(ReviewStatus.confirmed.name);
        if (userId != null) {
          expr = expr & tbl.userId.equals(userId);
        }
        return expr;
      });
    final rows = await query.get();
    return rows.map(_mapRow).toList();
  }

  @override
  Future<MedicationRecord> save(MedicationRecord record) async {
    await ensureUserExists(_db, record.userId);
    await _db.into(_db.medicines).insertOnConflictUpdate(
      MedicinesCompanion(
        id: Value(record.id),
        userId: Value(record.userId),
        prescriptionId: Value(record.prescriptionId),
        name: Value(record.name),
        strength: Value(record.strength),
        strengthUnit: Value(record.strengthUnit),
        doseInstructions: Value(record.doseInstructions),
        route: Value(record.route),
        frequency: Value(record.frequency),
        duration: Value(record.duration),
        timing: Value(record.timing),
        startAt: Value(record.startAt),
        endAt: Value(record.endAt),
        reviewStatus: Value(record.reviewStatus.name),
        confirmedAt: Value(record.confirmedAt),
        confirmedByUser: Value(record.confirmedByUser),
        scheduleRuleId: Value(record.scheduleRuleId),
        frequencyConfidence: Value(record.frequencyConfidence.name),
      ),
    );
    return record;
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.medicines)..where((tbl) => tbl.id.equals(id))).go();
  }

  MedicationRecord _mapRow(Medicine row) {
    return MedicationRecord(
      id: row.id,
      userId: row.userId,
      prescriptionId: row.prescriptionId,
      name: row.name,
      strength: row.strength,
      strengthUnit: row.strengthUnit,
      doseInstructions: row.doseInstructions,
      route: row.route,
      frequency: row.frequency,
      duration: row.duration,
      timing: row.timing,
      startAt: row.startAt,
      endAt: row.endAt,
      reviewStatus: ReviewStatus.values.firstWhere(
        (e) => e.name == row.reviewStatus,
        orElse: () => ReviewStatus.draft,
      ),
      confirmedAt: row.confirmedAt,
      confirmedByUser: row.confirmedByUser,
      scheduleRuleId: row.scheduleRuleId,
      frequencyConfidence: FieldConfidence.values.firstWhere(
        (e) => e.name == row.frequencyConfidence,
        orElse: () => FieldConfidence.missing,
      ),
    );
  }
}
