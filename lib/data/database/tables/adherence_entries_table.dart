import 'package:drift/drift.dart';
import 'package:medicine_remainder_app/data/database/tables/reminder_events_table.dart';
import 'package:medicine_remainder_app/data/database/tables/users_table.dart';

class AdherenceEntries extends Table {
  TextColumn get id => text()();
  TextColumn get userId =>
      text().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get reminderEventId =>
      text().references(ReminderEvents, #id, onDelete: KeyAction.cascade)();
  TextColumn get status => text()();
  DateTimeColumn get recordedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
