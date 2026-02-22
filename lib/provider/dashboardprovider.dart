import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/model/attendancestatus/AttendanceStatusResponse.dart';
import 'package:cnattendance/data/source/network/model/dashboard/Dashboardresponse.dart';
import 'package:cnattendance/data/source/network/model/dashboard/EmployeeTodayAttendance.dart';
import 'package:cnattendance/data/source/network/model/dashboard/Overview.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:cnattendance/utils/locationstatus.dart';
import 'package:cnattendance/utils/wifiinfo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:intl/intl.dart';

class DashboardProvider with ChangeNotifier {
  int _notificationCount = 0;
  bool _isLoading = false;

  int get notificationCount => _notificationCount;
  bool get isLoading => _isLoading;

  final Map<String, String> _overviewList = {
    'present': '0',
    'holiday': '0',
    'leave': '0',
    'request': '0',
    'gate_pass': '0',
    'total_task': '0',
    'internal_requisition': '0',
  };

  final Map<String, double> locationStatus = {
    'latitude': 0.0,
    'longitude': 0.0,
  };

  Map<String, String> get overviewList {
    return _overviewList;
  }

  final Map<String, dynamic> _attendanceList = {
    'check-in': '-',
    'check-out': '-',
    'production_hour': '0 hr 0 min ',
    'production-time': 0.0
  };

  Map<String, dynamic> get attendanceList {
    return _attendanceList;
  }

  final List<int> _weeklyReport = [];

  bool get isCheckIn {
    final lastCheckIn = _attendanceList['check-in'];
    final lastCheckOut = _attendanceList['check-out'];
    bool hasCheckedIn = lastCheckIn != null && lastCheckIn != '-';
    bool hasCheckedOut = lastCheckOut != null && lastCheckOut != '-';
    return hasCheckedIn && !hasCheckedOut;
  }

  List<int> get weeklyReport {
    return _weeklyReport;
  }

  List<BarChartGroupData> barchartValue = [];

  List<BarChartGroupData> rawBarGroups = [];
  List<BarChartGroupData> showingBarGroups = [];

  void buildgraph() {
    const int daysInWeek = 7;
    for (int i = 0; i < daysInWeek; i++) {
      barchartValue.add(makeGroupData(i, 0));
    }

    rawBarGroups.addAll(barchartValue);
    showingBarGroups.addAll(rawBarGroups);
  }

  Future<Dashboardresponse> getDashboard() async {
    _isLoading = true;
    notifyListeners();

    var uri = Uri.parse(Constant.DASHBOARD_URL);

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    var fcm = await FirebaseMessaging.instance.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
      'fcm_token': fcm ?? ""
    };

    try {
      final response = await Connect().getResponse(uri.toString(), headers);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final dashboardResponse = Dashboardresponse.fromJson(responseData);
        debugPrint(dashboardResponse.toString());

        updateAttendanceStatus(dashboardResponse.data.employeeTodayAttendance);
        updateOverView(dashboardResponse.data.overview);

        _notificationCount = dashboardResponse.data.notification_count;

        makeWeeklyReport(dashboardResponse.data.employeeWeeklyReport);

        DateTime startTime = DateFormat("hh:mm a")
            .parse(dashboardResponse.data.officeTime.startTime);
        DateTime endTime = DateFormat("hh:mm a")
            .parse(dashboardResponse.data.officeTime.endTime);

        await AwesomeNotifications().cancelAllSchedules();
        for (var shift in dashboardResponse.data.shift_dates) {
          scheduleNewNotification(shift, "Please check in on time ⏱️⌛️",
              startTime.hour, startTime.minute);
          scheduleNewNotification(
              shift,
              "Almost done with your shift 😄⌛️ Remember to checkout ⏱️",
              endTime.hour,
              endTime.minute);
        }
        _isLoading = false;
        notifyListeners();
        return dashboardResponse;
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

  void makeWeeklyReport(List<dynamic> employeeWeeklyReport) {
    _weeklyReport.clear();
    for (var item in employeeWeeklyReport) {
      if (item != null) {
        int hr = (item['productive_time_in_min'] / 60).toInt();
        if (hr > Constant.TOTAL_WORKING_HOUR) {
          _weeklyReport.add(Constant.TOTAL_WORKING_HOUR);
        } else {
          _weeklyReport.add(hr);
        }
      } else {
        _weeklyReport.add(0);
      }
    }

    barchartValue.clear();
    rawBarGroups.clear();
    showingBarGroups.clear();
    for (int i = 0; i < _weeklyReport.length; i++) {
      barchartValue.add(makeGroupData(i, _weeklyReport[i].toDouble()));
    }

    rawBarGroups.addAll(barchartValue);
    showingBarGroups.addAll(rawBarGroups);

    notifyListeners();
  }

  void updateAttendanceStatus(EmployeeTodayAttendance employeeTodayAttendance) {
    _attendanceList.update('production-time',
        (value) => calculateProdHour(employeeTodayAttendance.productionTime));
    _attendanceList.update(
        'check-out', (value) => employeeTodayAttendance.checkOutAt);
    _attendanceList.update('production_hour',
        (value) => calculateHourText(employeeTodayAttendance.productionTime));
    _attendanceList.update(
        'check-in', (value) => employeeTodayAttendance.checkInAt);

    notifyListeners();
  }

  void updateOverView(Overview overview) {
    _overviewList.update('present', (value) => overview.presentDays.toString());
    _overviewList.update(
        'holiday', (value) => overview.totalHolidays.toString());
    _overviewList.update(
        'leave', (value) => overview.totalLeaveTaken.toString());
    _overviewList.update(
        'request', (value) => overview.totalPendingLeaves.toString());
    _overviewList.update('gate_pass',
        (value) => overview.total_gate_pass.toString());
    _overviewList.update(
        'total_task', (value) => overview.total_pending_tasks.toString());
    _overviewList.update('internal_requisition',
        (value) => overview.total_internal_requisitions.toString());

    notifyListeners();
  }

  double calculateProdHour(int value) {
    double hour = value / 60;
    double hr = hour / Constant.TOTAL_WORKING_HOUR;

    return hr > 1 ? 1 : hr;
  }

  String calculateHourText(int value) {
    double second = value * 60.toDouble();
    double min = second / 60;
    int minGone = (min % 60).toInt();
    int hour = min ~/ 60;

    print("$hour hr $minGone min");
    return "$hour hr $minGone min";
  }

  Future<bool> getCheckInStatus() async {
    try {
      final position = await LocationStatus().determinePosition();

      locationStatus.update('latitude', (value) => position.latitude);
      locationStatus.update('longitude', (value) => position.longitude);

      if (locationStatus['latitude'] != 0.0 &&
          locationStatus['longitude'] != 0.0) {
        return true;
      } else {
        Future.error(
            'Location is not detected. Please check if location is enabled and try again.');
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AttendanceStatusResponse> checkInAttendance() async {
    var uri = Uri.parse(Constant.CHECK_IN_URL);

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect().postResponse(uri.toString(), headers, {
        'router_bssid': await WifiInfo().info.getWifiBSSID() ?? "",
        'check_in_latitude': locationStatus['latitude'].toString(),
        'check_in_longitude': locationStatus['longitude'].toString(),
      });
      debugPrint(locationStatus['latitude'].toString());
      debugPrint(locationStatus['longitude'].toString());
      debugPrint(await WifiInfo().wifiBSSID() ?? "");
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final attendanceResponse =
            AttendanceStatusResponse.fromJson(responseData);
        debugPrint(attendanceResponse.toString());

        updateAttendanceStatus(EmployeeTodayAttendance(
            checkInAt: attendanceResponse.data.checkInAt,
            checkOutAt: attendanceResponse.data.checkOutAt,
            productionTime: attendanceResponse.data.productiveTimeInMin));

        return attendanceResponse;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (e) {
      debugPrint(locationStatus['latitude'].toString());
      debugPrint(locationStatus['longitude'].toString());
      debugPrint(await WifiInfo().wifiBSSID() ?? "");
      rethrow;
    }
  }

  Future<void> scheduleNewNotification(
      String date, String message, int hour, int minute) async {
    final convertedDate = new DateFormat('yyyy-MM-dd').parse(date);

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: Random().nextInt(1000000),
            // -1 is replaced by a random number
            channelKey: 'digital_hr_channel',
            title: "Hello There",
            body: message,
            //'asset://assets/images/balloons-in-sky.jpg',
            notificationLayout: NotificationLayout.Default,
            payload: {'notificationId': '1234567890'}),
        actionButtons: [
          NotificationActionButton(
              key: 'REDIRECT', label: 'Open', actionType: ActionType.Default),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              actionType: ActionType.DismissAction,
              isDangerousOption: true)
        ],
        schedule: NotificationCalendar.fromDate(
            date: DateTime(convertedDate.year, convertedDate.month,
                convertedDate.day, hour, minute - 15)));
  }

  Future<AttendanceStatusResponse> checkOutAttendance() async {
    var uri = Uri.parse(Constant.CHECK_OUT_URL);

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect().postResponse(uri.toString(), headers, {
        'router_bssid': await WifiInfo().wifiBSSID() ?? "",
        'check_out_latitude': locationStatus['latitude'].toString(),
        'check_out_longitude': locationStatus['longitude'].toString(),
      });
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final attendanceResponse =
            AttendanceStatusResponse.fromJson(responseData);

        updateAttendanceStatus(EmployeeTodayAttendance(
            checkInAt: attendanceResponse.data.checkInAt,
            checkOutAt: attendanceResponse.data.checkOutAt,
            productionTime: attendanceResponse.data.productiveTimeInMin));

        return attendanceResponse;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (e) {
      rethrow;
    }
  }

  final Color leftBarColor = HexColor("#FFFFFF");

  final double width = 15;

  BarChartGroupData makeGroupData(int x, double y1) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        toY: y1,
        color: leftBarColor,
        width: width,
      ),
    ]);
  }
}
