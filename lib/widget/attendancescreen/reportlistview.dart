import 'package:cnattendance/provider/attendancereportprovider.dart';
import 'package:cnattendance/widget/attendancescreen/attendancecardview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AttendanceReportProvider>(context);
    final report = provider.attendanceReport;

    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (report.isEmpty) {
      return Center(child: Text("No attendance records found."));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: report.length,
      itemBuilder: (ctx, index) {
        final item = report[index];
        return AttendanceCardView(
          index,
          item.attendance_date,
          item.week_day,
          item.check_in,
          item.check_out,
        );
      },
    );
  }
}
