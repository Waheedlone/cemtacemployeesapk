import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'dart:math';

class NotificationService {
  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
        'resource://mipmap/cemtac',
        [
          NotificationChannel(
            channelGroupKey: 'digital_hr_group',
            channelKey: 'digital_hr_channel',
            channelName: 'Digital HR Notifications',
            channelDescription: 'HR alerts, leave updates, and gate pass status',
            defaultColor: Color(0xFFED1C24),
            ledColor: Color(0xFFED1C24),
            importance: NotificationImportance.Max,
            defaultRingtoneType: DefaultRingtoneType.Notification,
            playSound: true,
            enableVibration: true,
            enableLights: true,
            criticalAlerts: true,
            defaultPrivacy: NotificationPrivacy.Public,
          ),
        ],
        channelGroups: [
          NotificationChannelGroup(
            channelGroupKey: 'digital_hr_group',
            channelGroupName: 'HR Group',
          ),
        ],
        debug: true);
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // Navigate to Home or specific screen when tapped
    if (receivedAction.buttonKeyInput.isEmpty) {
      // If the app is already in the background, this will bring it to the front
      // You can also add specific navigation logic here based on payload
      print("Notification tapped: ${receivedAction.payload}");
    }
  }

  static Future<void> showFromFCM({
    required String title,
    required String body,
    Map<String, String>? payload,
  }) async {
    print("NotificationService: Displaying notification from FCM - Title: $title");
    try {
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
          criticalAlert: true,
        ),
      );
      print("NotificationService: Notification displayed successfully.");
    } catch (e) {
      print("NotificationService: Failed to display notification: $e");
    }
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
