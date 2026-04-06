import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  static Future<void> initialize() async {
    print('NotificationService: Web stub - initialize skipped');
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  }

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
    final dynamic actionType = null,
    final dynamic notificationLayout = null,
    final dynamic category = null,
    final String? bigPicture,
    final List<dynamic>? actionButtons,
    final bool scheduled = false,
    final Duration? interval,
  }) async {
    print('NotificationService: Web stub - showNotification skipped');
  }
}
