import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/features/reminders/domain/reminder_planner.dart';
import 'package:medicine_remainder_app/features/reminders/domain/schedule_rule.dart';

void main() {
  test('legacy ReminderPlanner.expand is not implemented yet', () {
    const planner = ReminderPlanner();
    expect(
      () => planner.expand(
        const ScheduleRule(
          id: 'r1',
          medicineId: 'm1',
          timezoneId: 'local',
          timesOfDay: [],
        ),
        from: DateTime.utc(2026),
      ),
      throwsUnimplementedError,
    );
  });
}
