/// Small helper for scheduling reminders.
/// Platform-specific scheduling should be implemented in a separate service.
class ReminderHelper {
  Future<void> scheduleReminder(String assignmentId, DateTime at) async {
    // TODO: Implement platform-specific notifications
  }

  Future<void> cancelReminder(String assignmentId) async {}
}
