import 'package:drift/drift.dart';
import 'package:medicine_remainder_app/data/database/app_database.dart';
import 'package:medicine_remainder_app/data/database/user_bootstrap.dart';
import 'package:medicine_remainder_app/features/prescription/data/prescription_image_store.dart';
import 'package:medicine_remainder_app/shared/models/field_confidence.dart';

class PrescriptionRecord {
  const PrescriptionRecord({
    required this.id,
    required this.userId,
    required this.capturedAt,
    required this.source,
    this.imagePath,
    required this.reviewStatus,
    this.humanReviewedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final DateTime capturedAt;
  final String source;
  final String? imagePath;
  final ReviewStatus reviewStatus;
  final DateTime? humanReviewedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
}

/// Prescription container persistence and image cleanup (P5-02).
class PrescriptionRepository {
  PrescriptionRepository({
    required AppDatabase database,
    required PrescriptionImageStore imageStore,
  })  : _db = database,
        _imageStore = imageStore;

  final AppDatabase _db;
  final PrescriptionImageStore _imageStore;

  Future<PrescriptionRecord> save(PrescriptionRecord record) async {
    await ensureUserExists(_db, record.userId);
    await _db.into(_db.prescriptions).insertOnConflictUpdate(
      PrescriptionsCompanion(
        id: Value(record.id),
        userId: Value(record.userId),
        capturedAt: Value(record.capturedAt),
        source: Value(record.source),
        imagePath: Value(record.imagePath),
        reviewStatus: Value(record.reviewStatus.name),
        humanReviewedAt: Value(record.humanReviewedAt),
        createdAt: Value(record.createdAt),
        updatedAt: Value(record.updatedAt),
      ),
    );
    return record;
  }

  Future<PrescriptionRecord?> findById(String id) async {
    final row = await (_db.select(_db.prescriptions)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    if (row == null) {
      return null;
    }
    return _mapRow(row);
  }

  Future<void> deletePrescription(String prescriptionId) async {
    final existing = await findById(prescriptionId);
    if (existing?.imagePath != null) {
      await _imageStore.delete(existing!.imagePath!);
    }
    await (_db.delete(_db.prescriptions)
          ..where((tbl) => tbl.id.equals(prescriptionId)))
        .go();
  }

  PrescriptionRecord _mapRow(Prescription row) {
    return PrescriptionRecord(
      id: row.id,
      userId: row.userId,
      capturedAt: row.capturedAt,
      source: row.source,
      imagePath: row.imagePath,
      reviewStatus: ReviewStatus.values.firstWhere(
        (e) => e.name == row.reviewStatus,
        orElse: () => ReviewStatus.draft,
      ),
      humanReviewedAt: row.humanReviewedAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
