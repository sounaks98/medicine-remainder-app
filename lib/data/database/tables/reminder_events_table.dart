import 'package:drift/drift.dart';
import 'package:medicine_remainder_app/data/database/tables/medicines_table.dart';
import 'package:medicine_remainder_app/data/database/tables/users_table.dart';

class ReminderEvents extends Table {
  TextColumn get id => text()();
  TextColumn get userId =>
      text().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get medicineId =>
      text().references(Medicines, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get fireAt => dateTime()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
