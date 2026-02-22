import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/model/employeeleavecalendar/Employeeleavecalendarresponse.dart';
import 'package:cnattendance/data/source/network/model/employeeleavecalendarbyday/EmployeeLeavesByDay.dart';
import 'package:cnattendance/data/source/network/model/employeeleavecalendarbyday/EmployeeLeavesByDayResponse.dart';
import 'package:cnattendance/model/LeaveByDay.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:cnattendance/data/source/network/connect.dart';

class LeaveCalendarProvider with ChangeNotifier {
  final Map<String, List<dynamic>> _employeeLeaveList = {};

  final List<LeaveByDay> _employeeLeaveByDayList = [];

  Map<String, List<dynamic>> get employeeLeaveList {
    return _employeeLeaveList;
  }

  List<LeaveByDay> get employeeLeaveByDayList {
    return _employeeLeaveByDayList;
  }

  Future<Employeeleavecalendarresponse> getLeaves() async {
    var uri = Uri.parse(Constant.LEAVE_CALENDAR_API);

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

        final responseJson =
            Employeeleavecalendarresponse.fromJson(responseData);

        _employeeLeaveList.clear();

        for (var item in responseJson.data) {
          List<int> list = [];
          for (int i = 0; i < item.leaveCount; i++) {
            list.add(i);
          }
          _employeeLeaveList.addAll({item.date: list});
        }

        notifyListeners();

        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<EmployeeLeavesByDayResponse> getLeavesByDay(String value) async {
    var uri = Uri.parse(Constant.LEAVE_CALENDAR_BY_DAY_API)
        .replace(queryParameters: {'leave_date': value});

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

        final responseJson = EmployeeLeavesByDayResponse.fromJson(responseData);

        makeLeaveByDayList(responseJson.data);

        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      rethrow;
    }
  }

  void makeLeaveByDayList(List<EmployeeLeavesByDay> data) {
    _employeeLeaveByDayList.clear();
    for (var item in data) {
      _employeeLeaveByDayList.add(LeaveByDay(
          id: item.leaveId,
          name: item.userName,
          post: item.post,
          days: item.leaveDays,
          avatar: item.userAvatar));
    }
    notifyListeners();
  }
}
