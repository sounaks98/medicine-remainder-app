import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Must run before [NotificationScheduler] schedules anything.
Future<void> configureReminderLocalTimezone() async {
  tz_data.initializeTimeZones();
  try {
    final timeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone.identifier));
  } catch (_) {
    tz.setLocalLocation(tz.UTC);
  }
}
