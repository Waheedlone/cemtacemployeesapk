import 'package:cnattendance/provider/attendancereportprovider.dart';
import 'package:cnattendance/widget/headerprofile.dart';
import 'package:flutter/material.dart';
import 'package:cnattendance/widget/attendancescreen/attendancestatus.dart';
import 'package:cnattendance/widget/attendancescreen/reportlistview.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AttendanceScreenState();
}

class AttendanceScreenState extends State<AttendanceScreen> {
  var initial = true;

  @override
  void didChangeDependencies() {
    if (initial) {
      loadAttendanceReport();
      initial = false;
    }
    super.didChangeDependencies();
  }

  Future<String> loadAttendanceReport() async {
    try {
      await Provider.of<AttendanceReportProvider>(context, listen: false)
          .getAttendanceReport();
      return 'loaded';
    } catch (e) {
      return 'loaded';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return loadAttendanceReport();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderProfile(),
                  AttendanceStatus(),
                  SizedBox(height: 20),
                  Text(
                    'Attendance History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('MMMM').format(DateTime.now()),
                            style: TextStyle(fontSize: 16),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ReportListView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
