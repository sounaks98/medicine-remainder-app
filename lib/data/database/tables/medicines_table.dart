import 'package:drift/drift.dart';
import 'package:medicine_remainder_app/data/database/tables/prescriptions_table.dart';
import 'package:medicine_remainder_app/data/database/tables/users_table.dart';

class Medicines extends Table {
  TextColumn get id => text()();
  TextColumn get userId =>
      text().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get prescriptionId =>
      text().references(Prescriptions, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get strength => text()();
  TextColumn get strengthUnit => text()();
  TextColumn get doseInstructions => text()();
  TextColumn get route => text()();
  TextColumn get frequency => text()();
  TextColumn get duration => text()();
  TextColumn get timing => text()();
  TextColumn get startAt => text().nullable()();
  TextColumn get endAt => text().nullable()();
  TextColumn get reviewStatus => text()();
  DateTimeColumn get confirmedAt => dateTime().nullable()();
  BoolColumn get confirmedByUser => boolean().withDefault(const Constant(false))();
  TextColumn get scheduleRuleId => text().nullable()();
  TextColumn get frequencyConfidence => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
