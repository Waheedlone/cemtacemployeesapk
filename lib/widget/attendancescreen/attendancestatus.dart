import 'package:cnattendance/provider/attendancereportprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final status = Provider.of<AttendanceReportProvider>(context).todayReport;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Check In | Check out',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  status['production_hour'] ?? '0 hr 0 min',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
