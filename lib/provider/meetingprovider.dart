import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/model/meeting/MeetingDomain.dart';
import 'package:cnattendance/data/source/network/model/meeting/MeetingReponse.dart';
import 'package:cnattendance/services/notification_service.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:cnattendance/data/source/network/connect.dart';

class MeetingProvider extends ChangeNotifier {
  static int per_page = 10;
  int page = 1;
  int _newMeetings = 0;

  int get newMeetings => _newMeetings;

  List<MeetingDomain> _meetingList = [];

  List<MeetingDomain> get meetingList {
    return [..._meetingList];
  }

  Future<MeetingReponse> getMeetingList() async {
    var uri = Uri.parse(Constant.MEETING_URL).replace(queryParameters: {
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

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        debugPrint(responseData.toString());

        final responseJson = MeetingReponse.fromJson(responseData);

        makeMeetingList(responseJson.data);
        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      throw error;
    }
  }

  void makeMeetingList(List<MeetingDomain> data) {
    if (page == 1) {
      _meetingList.clear();
      _newMeetings = 0;
    }

    if (data.isNotEmpty) {
      for (var item in data) {
        _meetingList.add(item);
        NotificationService.showNotification(title: 'New Meeting', body: item.title);
      }
      _newMeetings = data.length;
      page++;
    }

    notifyListeners();
  }

  void clearNewMeetings() {
    _newMeetings = 0;
    notifyListeners();
  }
}
