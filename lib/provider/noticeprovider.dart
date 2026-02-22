import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/model/notice/NoticeDomain.dart';
import 'package:cnattendance/data/source/network/model/notice/NoticeResponse.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:cnattendance/model/notification.dart' as Not;
import 'package:intl/intl.dart';

class NoticeProvider with ChangeNotifier {
  static int per_page = 10;
  int page = 1;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  final List<Not.Notification> _notificationList = [];

  List<Not.Notification> get notificationList {
    return [..._notificationList];
  }

  Future<NoticeResponse> getNotice() async {
    _isLoading = true;
    notifyListeners();
    var uri = Uri.parse(Constant.NOTICE_URL).replace(queryParameters: {
      'page': page.toString(),
      'per_page': per_page.toString(),
    });

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect().getResponse(uri.toString(), headers);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final jsonResponse = NoticeResponse.fromJson(responseData);

        makeNotificationList(jsonResponse.data);

        _isLoading = false;
        notifyListeners();
        return jsonResponse;
      } else {
        _isLoading = false;
        notifyListeners();
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  void makeNotificationList(List<NoticeDomain> data) {
    if (page == 1) {
      _notificationList.clear();
    }

    if (data.isNotEmpty) {
      for (var item in data) {
        DateTime tempDate =
            DateFormat("yyyy-MM-dd").parse(item.noticePublishedDate);
        _notificationList.add(Not.Notification(
            id: item.id,
            title: item.noticeTitle,
            description: item.description,
            month: DateFormat('MMM').format(tempDate),
            day: tempDate.day,
            date: tempDate));
      }

      page++;
    }

    notifyListeners();
  }
}
