import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_remainder_app/data/database/app_database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw StateError('appDatabaseProvider must be overridden in ProviderScope');
});
