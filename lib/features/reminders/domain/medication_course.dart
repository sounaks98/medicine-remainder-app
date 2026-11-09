/// Inclusive calendar course boundaries for a medicine (local dates).
class MedicationCourse {
  const MedicationCourse({
    required this.startDate,
    required this.durationDays,
  }) : assert(durationDays > 0);

  final DateTime startDate;
  final int durationDays;

  DateTime get inclusiveEndDate =>
      CourseDateMath.inclusiveEndDate(startDate, durationDays);

  MedicationCourse copyWith({
    DateTime? startDate,
    int? durationDays,
  }) {
    return MedicationCourse(
      startDate: startDate ?? this.startDate,
      durationDays: durationDays ?? this.durationDays,
    );
  }

  Map<String, Object?> toJson() => {
        'startDate': CourseDateMath.toDateString(startDate),
        'durationDays': durationDays,
      };

  factory MedicationCourse.fromJson(Map<String, Object?> json) {
    return MedicationCourse(
      startDate: CourseDateMath.parseDateString(json['startDate'] as String),
      durationDays: json['durationDays'] as int,
    );
  }

  static MedicationCourse startingToday({int durationDays = 7}) {
    return MedicationCourse(
      startDate: CourseDateMath.todayLocal(),
      durationDays: durationDays,
    );
  }
}

abstract final class CourseDateMath {
  static DateTime todayLocal() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  /// Inclusive end: start + (durationDays - 1) calendar days.
  static DateTime inclusiveEndDate(DateTime startDate, int durationDays) {
    if (durationDays < 1) {
      throw ArgumentError.value(durationDays, 'durationDays', 'Must be >= 1');
    }
    final start = dateOnly(startDate);
    return DateTime(start.year, start.month, start.day + durationDays - 1);
  }

  static String toDateString(DateTime date) {
    final d = dateOnly(date);
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  static DateTime parseDateString(String value) {
    final parts = value.split('-');
    if (parts.length != 3) {
      throw FormatException('Invalid date: $value');
    }
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  static bool isWithinInclusiveCourse(
    DateTime instantLocal,
    MedicationCourse course,
  ) {
    final day = dateOnly(instantLocal);
    final start = dateOnly(course.startDate);
    final end = inclusiveEndDate(course.startDate, course.durationDays);
    return !day.isBefore(start) && !day.isAfter(end);
  }
}
