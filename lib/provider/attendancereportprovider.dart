
import 'package:cnattendance/data/source/network/model/attendancereport/EmployeeAttendance.dart';
import 'package:cnattendance/data/source/network/model/attendancereport/EmployeeTodayAttendance.dart';
import 'package:cnattendance/model/employeeattendancereport.dart';
import 'package:cnattendance/model/month.dart';
import 'package:cnattendance/repositories/attendancereportrepository.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceReportProvider with ChangeNotifier {
  final List<EmployeeAttendanceReport> _attendanceReport = [];
  AttendanceReportRepository repository = AttendanceReportRepository();

  final Map<String, dynamic> _todayReport = {
    'check_in_at': '-',
    'check_out_at': '-',
    'production_hour': '0 hr 0 min',
    'production_percent': 0.0,
  };

  final List<Month> month = [
    Month(0, 'January'),
    Month(1, 'Febuary'),
    Month(2, 'March'),
    Month(3, 'April'),
    Month(4, 'May'),
    Month(5, 'June'),
    Month(6, 'July'),
    Month(7, 'August'),
    Month(8, 'September'),
    Month(9, 'October'),
    Month(10, 'November'),
    Month(11, 'December'),
  ];

  var isLoading = false;

  int selectedMonth = DateTime.now().month - 1;

  List<EmployeeAttendanceReport> get attendanceReport {
    return [..._attendanceReport];
  }

  Map<String, dynamic> get todayReport {
    return _todayReport;
  }

  Future<void> getAttendanceReport() async {
    isLoading = true;
    try {
      final responseJson = await repository.getAttendanceReport(selectedMonth);
        isLoading = false;
        makeTodayReport(responseJson.data.employeeTodayAttendance);
        makeAttendanceReport(responseJson.data.employeeAttendance);
        getProdHour(responseJson.data.employeeTodayAttendance.checkInAt,
            responseJson.data.employeeTodayAttendance.checkOutAt);
    } catch (error) {
      isLoading = false;
      throw error;
    }
  }

  void makeAttendanceReport(List<EmployeeAttendance> employeeAttendance) {
    _attendanceReport.clear();
    for (var item in employeeAttendance) {
      _attendanceReport.add(EmployeeAttendanceReport(
          id: item.id,
          attendance_date: item.attendanceDate,
          week_day: item.weekDay,
          check_in: item.checkIn,
          check_out: item.checkOut));
    }

    notifyListeners();
  }

  void makeTodayReport(EmployeeTodayAttendance employeeTodayAttendance) {
    _todayReport['check_in_at'] = employeeTodayAttendance.checkInAt;
    _todayReport['check_out_at'] = employeeTodayAttendance.checkOutAt;

    notifyListeners();
  }

  void getProdHour(String start, String end) {
    if (start == '-') {
      return;
    }

    if (start != '-' && end != '-') {
      DateTime current = DateTime.now();
      DateTime startDate = DateFormat("hh:mm a").parse(start);
      DateTime endDate = DateFormat("hh:mm a").parse(end);

      startDate = DateTime(current.year, current.month, current.day,
          startDate.hour, startDate.minute, startDate.second);

      endDate = DateTime(current.year, current.month, current.day,
          endDate.hour, endDate.minute, endDate.second);

      var value = endDate.difference(startDate).inMinutes;
      double second = value * 60.toDouble();
      double min = second / 60;
      int minGone = (min % 60).toInt();
      int hour = min ~/ 60;
      _todayReport['production_hour'] = "$hour hr $minGone min";

      double hours = value / 60;
      var hrPercent = hours / Constant.TOTAL_WORKING_HOUR;
      _todayReport['production_percent'] = hrPercent > 1.0 ? 1.0 : hrPercent;

      notifyListeners();
      return;
    }

    if (start != '-' && end == '-') {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('hh:mm a').format(now);

      DateTime endDate = DateFormat("hh:mm a").parse(formattedDate);
      DateTime startDate = DateFormat("hh:mm a").parse(start);

      var value = endDate.difference(startDate).inMinutes;

      int minGone = (value % 60).toInt();
      int hour = value ~/ 60;
      _todayReport['production_hour'] = "$hour hr $minGone min";

      double hours = value / 60;
      var hrPercent = hours / Constant.TOTAL_WORKING_HOUR;
      _todayReport['production_percent'] = hrPercent > 1.0 ? 1.0 : hrPercent;

      notifyListeners();
      return;
    }
  }
}
