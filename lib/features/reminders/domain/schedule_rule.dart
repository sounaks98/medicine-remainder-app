/// Frequency, explicit times, duration, and timezone for reminders.
class ScheduleRule {
  const ScheduleRule({
    required this.id,
    required this.medicineId,
    required this.timezoneId,
    required this.timesOfDay,
    this.durationDays,
  });

  final String id;
  final String medicineId;
  final String timezoneId;
  final List<Duration> timesOfDay;
  final int? durationDays;
}
