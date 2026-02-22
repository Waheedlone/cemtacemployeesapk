import 'package:flutter/material.dart';

class EmployeeAttendanceReport with ChangeNotifier {
  int id;
  String attendance_date;
  String week_day;
  String check_in;
  String check_out;

  EmployeeAttendanceReport(
      {required this.id,
      required this.attendance_date,
      required this.week_day,
      required this.check_in,
      required this.check_out});
}
