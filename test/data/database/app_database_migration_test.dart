import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/data/database/app_database.dart';
import 'package:medicine_remainder_app/data/database/migrations.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting();
  });

  tearDown(() async {
    await db.close();
  });

  test('schema version matches migration constants', () {
    expect(db.schemaVersion, DatabaseMigrations.currentVersion);
    expect(DatabaseMigrations.supportedVersions, contains(1));
  });

  test('onCreate builds all tables with foreign keys enabled', () async {
    await db.customSelect(
      "SELECT name FROM sqlite_master WHERE type='table'",
    ).get();

    final tables = await db.customSelect(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
    ).get();
    final names = tables.map((row) => row.read<String>('name')).toSet();
    expect(names, containsAll(['users', 'prescriptions', 'medicines']));
  });
}
