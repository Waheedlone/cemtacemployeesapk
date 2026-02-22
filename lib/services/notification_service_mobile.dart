import 'package:awesome_notifications/awesome_notifications.dart';
import 'dart:math';

class NotificationService {
  static Future<void> showFromFCM({
    required String title,
    required String body,
    Map<String, String>? payload,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random().nextInt(100000),
        channelKey: 'digital_hr_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Message,
        payload: payload,
        wakeUpScreen: true,
        autoDismissible: true,
      ),
    );
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final dynamic actionType = null, // Default value would need the type which might be missing on web
    final dynamic notificationLayout = null, 
    final dynamic category = null,
    final String? bigPicture,
    final List<dynamic>? actionButtons,
    final bool scheduled = false,
    final Duration? interval,
  }) async {
    // Mobile implementation remains as it was
     await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random().nextInt(100000),
        channelKey: 'digital_hr_channel',
        title: title,
        body: body,
        // actionType: actionType ?? ActionType.Default,
        // ... more mappings if needed
      ),
    );
  }
}
