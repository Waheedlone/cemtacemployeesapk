import 'package:cnattendance/model/notification.dart' as Not;
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'package:cnattendance/screen/dashboard/leavescreen.dart';
import 'package:cnattendance/screen/gatepassscreen.dart';
import 'package:cnattendance/screen/noticescreen.dart';
import 'package:cnattendance/screen/tadascreen/tadascreen.dart';
import 'package:cnattendance/screen/dashboard/attendancescreen.dart';
import 'package:cnattendance/screen/projectscreen/tasklistscreen/tasklistscreen.dart';
import 'package:cnattendance/screen/shifthandoverscreen.dart';
import 'package:cnattendance/screen/substitutionscreen.dart';
import 'package:cnattendance/screen/overtimescreen.dart';

class NotificationRow extends StatelessWidget {
  final Not.Notification notification;

  NotificationRow(this.notification);

  void navigateBasedOnType(BuildContext context, String type) {
    Widget? targetScreen;
    switch (type) {
      case 'leave':
        targetScreen = LeaveScreen();
        break;
      case 'gate_pass':
        targetScreen = GatePassScreen();
        break;
      case 'notice':
        targetScreen = NoticeScreen();
        break;
      case 'tada':
        targetScreen = TadaScreen();
        break;
      case 'attendance':
        targetScreen = AttendanceScreen();
        break;
      case 'project_management':
      case 'task':
      case 'comment':
        targetScreen = TaskListScreen();
        break;
      case 'shift_handover':
        targetScreen = ShiftHandoverScreen();
        break;
      case 'substitution':
        targetScreen = SubstitutionScreen();
        break;
      case 'overtime':
        targetScreen = OvertimeScreen();
        break;
      default:
        // No specific screen or unknown type
        break;
    }

    if (targetScreen != null) {
      pushScreen(
        context,
        screen: targetScreen,
        withNavBar: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          navigateBasedOnType(context, notification.type);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.1),
                ),
                child: Column(
                  children: [
                    Text(
                      notification.day.toString(),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    Text(
                      notification.month,
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      notification.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
