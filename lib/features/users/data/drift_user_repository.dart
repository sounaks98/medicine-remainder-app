import 'package:drift/drift.dart';
import 'package:medicine_remainder_app/data/database/app_database.dart';
import 'package:medicine_remainder_app/features/users/data/user_repository.dart';
import 'package:medicine_remainder_app/features/users/domain/user_profile.dart';
import 'package:uuid/uuid.dart';

class DriftUserRepository implements UserRepository {
  DriftUserRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  @override
  Stream<List<UserProfile>> watchAllUsers() {
    final query = _db.select(_db.users)
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.displayName)]);
    return query.watch().map((rows) => rows.map(_mapRow).toList());
  }

  @override
  Stream<UserProfile?> watchUser(String id) {
    final query = _db.select(_db.users)..where((tbl) => tbl.id.equals(id));
    return query.watchSingleOrNull().map((row) => row == null ? null : _mapRow(row));
  }

  @override
  Future<UserProfile?> getUser(String id) async {
    final query = _db.select(_db.users)..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }

  @override
  Future<UserProfile> createUser(String displayName) async {
    final trimmed = displayName.trim();
    if (trimmed.isEmpty || trimmed.length > 64) {
      throw UserRepositoryException(
        'Display name must be 1–64 characters after trimming.',
      );
    }
    final now = DateTime.now().toUtc();
    final id = _uuid.v4();
    await _db.into(_db.users).insert(
      UsersCompanion.insert(
        id: id,
        displayName: trimmed,
        createdAt: now,
        updatedAt: now,
      ),
    );
    return UserProfile(
      id: id,
      displayName: trimmed,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<void> updateDisplayName(String id, String displayName) async {
    final trimmed = displayName.trim();
    if (trimmed.isEmpty || trimmed.length > 64) {
      throw UserRepositoryException(
        'Display name must be 1–64 characters after trimming.',
      );
    }
    final updated = await (_db.update(_db.users)..where((tbl) => tbl.id.equals(id)))
        .write(
      UsersCompanion(
        displayName: Value(trimmed),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
    if (updated == 0) {
      throw UserRepositoryException('User not found.');
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    final count = await _db.users.count().getSingle();
    if (count <= 1) {
      throw UserRepositoryException('Cannot delete the only profile on this device.');
    }
    final deleted = await (_db.delete(_db.users)..where((tbl) => tbl.id.equals(id))).go();
    if (deleted == 0) {
      throw UserRepositoryException('User not found.');
    }
  }

  UserProfile _mapRow(User row) {
    return UserProfile(
      id: row.id,
      displayName: row.displayName,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
