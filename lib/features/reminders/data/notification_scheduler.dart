/// Schedules local notifications from confirmed medicines (P6-02).
class NotificationScheduler {
  const NotificationScheduler();

  Future<void> schedule({
    required int notificationId,
    required DateTime fireAt,
    required String title,
    required String body,
  }) {
    throw UnimplementedError('P6-02');
  }

  Future<void> cancel(int notificationId) {
    throw UnimplementedError('P6-02');
  }
}
