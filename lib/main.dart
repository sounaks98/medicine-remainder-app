import 'package:flutter/material.dart';
import 'package:flutter_edge_ai/flutter_edge_ai.dart';
import 'package:flutter_edge_ai_litertlm/flutter_edge_ai_litertlm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_remainder_app/app/app.dart';
import 'package:medicine_remainder_app/app/di/database_providers.dart';
import 'package:medicine_remainder_app/app/di/reminder_providers.dart';
import 'package:medicine_remainder_app/app/di/user_providers.dart';
import 'package:medicine_remainder_app/data/database/app_database.dart';
import 'package:medicine_remainder_app/features/reminders/data/notification_scheduler.dart';
import 'package:medicine_remainder_app/features/reminders/data/reminder_timezone.dart';
import 'package:medicine_remainder_app/shared/config/huggingface_token.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureReminderLocalTimezone();
  final notificationScheduler = await NotificationScheduler.create();
  await FlutterEdgeAi.initialize(
    inferenceEngines: const [LiteRtLmEngine()],
    huggingFaceToken: resolveHuggingFaceToken(),
  );

  final prefs = await SharedPreferences.getInstance();
  final dir = await getApplicationDocumentsDirectory();
  final dbPath = p.join(dir.path, 'medicine_reminder.db');
  final db = await AppDatabase.openDefault(filePath: dbPath);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(db),
        notificationSchedulerProvider.overrideWithValue(notificationScheduler),
      ],
      child: const MedicineReminderApp(),
    ),
  );
}
