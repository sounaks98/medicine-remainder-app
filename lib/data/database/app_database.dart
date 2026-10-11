import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:medicine_remainder_app/data/database/migrations.dart';
import 'package:medicine_remainder_app/data/database/tables/adherence_entries_table.dart';
import 'package:medicine_remainder_app/data/database/tables/medicines_table.dart';
import 'package:medicine_remainder_app/data/database/tables/prescriptions_table.dart';
import 'package:medicine_remainder_app/data/database/tables/reminder_events_table.dart';
import 'package:medicine_remainder_app/data/database/tables/users_table.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Prescriptions,
    Medicines,
    ReminderEvents,
    AdherenceEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => DatabaseMigrations.currentVersion;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 1 && to >= 1) {
          await m.createAll();
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  static AppDatabase forTesting({File? file}) {
    if (file != null) {
      return AppDatabase(NativeDatabase.createInBackground(file));
    }
    return AppDatabase(NativeDatabase.memory());
  }

  static AppDatabase openFile(File file) {
    return AppDatabase(NativeDatabase.createInBackground(file));
  }

  static Future<AppDatabase> openDefault({required String filePath}) async {
    final dir = Directory(p.dirname(filePath));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return openFile(File(filePath));
  }
}
