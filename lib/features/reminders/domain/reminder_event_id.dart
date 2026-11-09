/// Stable local notification ids scoped per user + reminder event row.
abstract final class ReminderNotificationIds {
  static int forEvent({
    required String userId,
    required String reminderEventId,
  }) {
    return Object.hash(userId, reminderEventId) & 0x7fffffff;
  }
}
