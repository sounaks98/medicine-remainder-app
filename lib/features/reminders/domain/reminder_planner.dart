import 'package:medicine_remainder_app/features/reminders/domain/schedule_rule.dart';

/// Deterministic expansion of [ScheduleRule] into fire times.
class ReminderPlanner {
  const ReminderPlanner();

  List<DateTime> expand(ScheduleRule rule, {required DateTime from, DateTime? to}) {
    throw UnimplementedError('P6-01');
  }
}
