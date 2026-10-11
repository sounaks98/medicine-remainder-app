import 'package:drift/drift.dart';
import 'package:medicine_remainder_app/data/database/app_database.dart';

Future<void> ensureUserExists(
  AppDatabase db,
  String userId, {
  String displayName = 'Default profile',
}) async {
  final now = DateTime.now().toUtc();
  await db.into(db.users).insertOnConflictUpdate(
    UsersCompanion(
      id: Value(userId),
      displayName: Value(displayName),
      createdAt: Value(now),
      updatedAt: Value(now),
    ),
  );
}
