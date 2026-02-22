class NotificationService {
  static Future<void> showFromFCM({
    required String title,
    required String body,
    Map<String, String>? payload,
  }) async {
    print('NotificationService: Web stub - showFromFCM skipped');
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final dynamic actionType,
    final dynamic notificationLayout,
    final dynamic category,
    final String? bigPicture,
    final List<dynamic>? actionButtons,
    final bool scheduled = false,
    final Duration? interval,
  }) async {
    print('NotificationService: Web stub - showNotification skipped');
  }
}
