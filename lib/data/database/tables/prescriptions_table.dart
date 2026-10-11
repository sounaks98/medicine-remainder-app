import 'package:drift/drift.dart';
import 'package:medicine_remainder_app/data/database/tables/users_table.dart';

class Prescriptions extends Table {
  TextColumn get id => text()();
  TextColumn get userId =>
      text().references(Users, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get capturedAt => dateTime()();
  DateTimeColumn get validFrom => dateTime().nullable()();
  DateTimeColumn get validTo => dateTime().nullable()();
  TextColumn get source => text()();
  TextColumn get imagePath => text().nullable()();
  TextColumn get reviewStatus => text()();
  DateTimeColumn get humanReviewedAt => dateTime().nullable()();
  TextColumn get doctorName => text().nullable()();
  TextColumn get diagnosis => text().nullable()();
  TextColumn get testsSuggested => text().nullable()();
  TextColumn get facilityName => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get prescriptionLikelihood => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
