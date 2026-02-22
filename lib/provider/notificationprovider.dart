import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/model/notification/NotifiactionDomain.dart';
import 'package:cnattendance/data/source/network/model/notification/NotificationResponse.dart';
import 'package:cnattendance/model/notification.dart' as model;
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {
  static const _seenKey = 'notification_seen_total';
  static int per_page = 10;

  int page = 1;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Total notifications we have fetched from the server most recently.
  int _serverTotal = 0;

  /// How many notifications the user has already seen (persisted).
  int _seenTotal = 0;

  /// Extra notifications from FCM push that arrived after the last fetch.
  int _fcmDelta = 0;

  /// The badge count the user sees on the bell icon.
  int get unreadCount => (_serverTotal - _seenTotal + _fcmDelta).clamp(0, 999);

  List<model.Notification> _notificationList = [];
  List<model.Notification> get notificationList => [..._notificationList];

  NotificationProvider() {
    _loadSeenTotal();
  }

  Future<void> _loadSeenTotal() async {
    final prefs = await SharedPreferences.getInstance();
    _seenTotal = prefs.getInt(_seenKey) ?? 0;
    notifyListeners();
  }

  Future<void> _saveSeenTotal(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_seenKey, value);
  }

  /// Called when a new FCM push notification arrives.
  void increment() {
    _fcmDelta++;
    notifyListeners();
  }

  /// Called when the user opens the notification screen — resets badge to 0.
  void markAllRead() {
    // Mark everything seen: seenTotal = serverTotal + fcmDelta
    _seenTotal = _serverTotal + _fcmDelta;
    _fcmDelta = 0;
    _saveSeenTotal(_seenTotal);
    notifyListeners();
  }

  /// Lightweight fetch to update badge count in the header.
  Future<void> fetchUnreadCount() async {
    try {
      final token = await Preferences().getToken();
      if (token.isEmpty) return;

      final uri = Uri.parse(Constant.NOTIFICATION_URL).replace(queryParameters: {
        'page': '1',
        'per_page': '1',
      });

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      };

      final response = await Connect().getResponse(uri.toString(), headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        int total = 0;
        // Try meta.total (paginated response)
        if (data['meta'] is Map && data['meta']['total'] != null) {
          total = data['meta']['total'] as int;
        } else if (data['data'] is List) {
          total = (data['data'] as List).length;
        }

        _serverTotal = total;

        // If seenTotal is somehow higher than current total, reset it
        if (_seenTotal > _serverTotal) {
          _seenTotal = _serverTotal;
          _saveSeenTotal(_seenTotal);
        }

        notifyListeners();
      }
    } catch (e) {
      debugPrint('fetchUnreadCount error: $e');
    }
  }

  /// Full fetch for the notification list screen.
  Future<NotificationResponse> getNotification() async {
    _isLoading = true;
    notifyListeners();

    final uri = Uri.parse(Constant.NOTIFICATION_URL).replace(queryParameters: {
      'page': page.toString(),
      'per_page': per_page.toString(),
    });

    final token = await Preferences().getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await Connect().getResponse(uri.toString(), headers);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final responseJson = NotificationResponse.fromJson(responseData);

        // Update serverTotal from meta if available
        if (responseData['meta'] is Map && responseData['meta']['total'] != null) {
          _serverTotal = responseData['meta']['total'] as int;
        }

        makeNotificationList(responseJson.data);
        return responseJson;
      } else {
        throw responseData['message'];
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void makeNotificationList(List<NotifiactionDomain> data) {
    if (page == 1) {
      _notificationList.clear();
    }

    for (var item in data) {
      DateTime? parsedDate;

      try {
        parsedDate = DateFormat("MMM dd yyyy HH:mm").parse(item.notificationPublishedDate);
      } catch (_) {}

      if (parsedDate == null) {
        try {
          parsedDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(item.notificationPublishedDate);
        } catch (_) {}
      }

      if (parsedDate != null) {
        _notificationList.add(model.Notification(
          id: item.id,
          title: item.notificationTitle,
          description: item.description,
          month: DateFormat("MMM").format(parsedDate),
          day: parsedDate.day,
          date: parsedDate,
        ));
      }
    }

    if (data.isNotEmpty) page++;
    notifyListeners();
  }
}
