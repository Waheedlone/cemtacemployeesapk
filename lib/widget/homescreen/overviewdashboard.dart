import 'package:cnattendance/provider/dashboardprovider.dart';
import 'package:cnattendance/screen/dashboard/attendancescreen.dart';
import 'package:cnattendance/screen/dashboard/leavescreen.dart';
import 'package:cnattendance/screen/gatepassscreen.dart';
import 'package:cnattendance/screen/holidayscreen.dart';
import 'package:cnattendance/screen/internal_requisition/internal_requisition_list_screen.dart';
import 'package:cnattendance/screen/profile/leavecalendarscreen.dart';
import 'package:cnattendance/screen/projectscreen/tasklistscreen/tasklistscreen.dart';
import 'package:cnattendance/screen/overtimescreen.dart';
import 'package:cnattendance/screen/shifthandoverscreen.dart';
import 'package:cnattendance/screen/substitutionscreen.dart';
import 'package:cnattendance/screen/dashboard/shift_roster_screen.dart';
import 'package:cnattendance/utils/responsive.dart';
import 'package:cnattendance/widget/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:cnattendance/widget/homescreen/cardoverview.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OverviewDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dashBoardProvider = Provider.of<DashboardProvider>(context);
    final _overview = dashBoardProvider.overviewList;

    if (dashBoardProvider.isLoading) {
      return ShimmerLoading(child: ShimmerLoading.buildGridShimmer(itemCount: 8));
    }

    if (dashBoardProvider.errorMessage.isNotEmpty && !dashBoardProvider.isUsingCache) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: 10),
            Text(
              "Oops! Something went wrong",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red.shade800),
            ),
            SizedBox(height: 5),
            Text(
              dashBoardProvider.errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red.shade700),
            ),
            SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () => dashBoardProvider.getDashboard(),
              icon: Icon(Icons.refresh),
              label: Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      );
    }

    final List<Map<String, dynamic>> overviewItems = [
      {'type': 'Present', 'value': _overview['present'] ?? '0', 'icon': Icons.business_center},
      {'type': 'Holidays', 'value': _overview['holiday'] ?? '0', 'icon': Icons.card_giftcard},
      {'type': 'Leave', 'value': _overview['leave'] ?? '0', 'icon': Icons.person_off},
      {'type': 'Request', 'value': _overview['request'] ?? '0', 'icon': Icons.pending_actions},
      {'type': 'Gate-Pass', 'value': _overview['gate_pass'] ?? '0', 'icon': Icons.local_activity},
      {'type': 'Requisitions Request', 'value': _overview['internal_requisition'] ?? '0', 'icon': Icons.assignment_late},
      {'type': 'Substitution', 'value': _overview['substitution'] ?? '0', 'icon': Icons.swap_horiz},
      {'type': 'Shift Handover', 'value': _overview['shift_handover'] ?? '0', 'icon': Icons.sync_alt},
      {'type': 'Overtime', 'value': _overview['overtime'] ?? '0', 'icon': Icons.more_time},
      {'type': 'Shift Roster', 'value': dashBoardProvider.officeTime['shift_name'] ?? 'Schedule', 'icon': Icons.calendar_view_month},
      {'type': 'Admin Dashboard', 'value': 'Login', 'icon': Icons.admin_panel_settings},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (dashBoardProvider.isUsingCache)
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 15),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.sync_problem, color: Colors.amber.shade800, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Live data unavailable. Showing last results.",
                    style: TextStyle(color: Colors.amber.shade900, fontSize: 13),
                  ),
                ),
                TextButton(
                  onPressed: () => dashBoardProvider.getDashboard(),
                  child: Text("Retry", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Responsive.isDesktop(context) ? 4 : Responsive.isTablet(context) ? 3 : 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.0,
          ),
          itemCount: overviewItems.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (overviewItems[index]['type'] == 'Leave') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveCalendarScreen()));
                } else if (overviewItems[index]['type'] == 'Holidays') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HolidayScreen()));
                } else if (overviewItems[index]['type'] == 'Present') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AttendanceScreen()));
                } else if (overviewItems[index]['type'] == 'Request') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveScreen()));
                } else if (overviewItems[index]['type'] == 'Gate-Pass') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GatePassScreen()));
                } else if (overviewItems[index]['type'] == 'Total-Task') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TaskListScreen()));
                } else if (overviewItems[index]['type'] == 'Requisitions Request') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => InternalRequisitionListScreen()));
                } else if (overviewItems[index]['type'] == 'Substitution') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SubstitutionScreen()));
                } else if (overviewItems[index]['type'] == 'Shift Handover') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ShiftHandoverScreen()));
                } else if (overviewItems[index]['type'] == 'Overtime') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OvertimeScreen()));
                } else if (overviewItems[index]['type'] == 'Shift Roster') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ShiftRosterScreen()));
                } else if (overviewItems[index]['type'] == 'Admin Dashboard') {
                  final Uri _url = Uri.parse('https://hrcemtac.in/admin/login');
                  launchUrl(_url, mode: LaunchMode.externalApplication);
                }
              },
              child: CardOverView(
                type: overviewItems[index]['type'],
                value: overviewItems[index]['value'],
                icon: overviewItems[index]['icon'],
              ),
            );
          },
        ),
      ],
    );
  }
}
