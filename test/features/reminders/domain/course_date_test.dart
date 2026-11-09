import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/features/reminders/domain/medication_course.dart';

void main() {
  group('CourseDateMath.inclusiveEndDate', () {
    test('7-day course from Oct 16 ends Oct 22', () {
      final start = DateTime(2026, 10, 16);
      final end = CourseDateMath.inclusiveEndDate(start, 7);
      expect(CourseDateMath.toDateString(end), '2026-10-22');
    });

    test('1-day course ends same day', () {
      final start = DateTime(2026, 3, 1);
      expect(
        CourseDateMath.toDateString(
          CourseDateMath.inclusiveEndDate(start, 1),
        ),
        '2026-03-01',
      );
    });

    test('3- and 14-day courses', () {
      final start = DateTime(2026, 1, 10);
      expect(
        CourseDateMath.toDateString(
          CourseDateMath.inclusiveEndDate(start, 3),
        ),
        '2026-01-12',
      );
      expect(
        CourseDateMath.toDateString(
          CourseDateMath.inclusiveEndDate(start, 14),
        ),
        '2026-01-23',
      );
    });

    test('month boundary', () {
      final start = DateTime(2026, 1, 30);
      expect(
        CourseDateMath.toDateString(
          CourseDateMath.inclusiveEndDate(start, 3),
        ),
        '2026-02-01',
      );
    });
  });
}
