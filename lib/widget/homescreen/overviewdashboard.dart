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

class OverviewDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dashBoardProvider = Provider.of<DashboardProvider>(context);
    final _overview = dashBoardProvider.overviewList;

    if (dashBoardProvider.isLoading) {
      return ShimmerLoading(child: ShimmerLoading.buildGridShimmer(itemCount: 8));
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
      {'type': 'Shift Roster', 'value': 'View', 'icon': Icons.calendar_month},
      {'type': 'Download Shift', 'value': 'Action', 'icon': Icons.download_for_offline},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isDesktop(context) ? 4 : Responsive.isTablet(context) ? 3 : 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.2, // Adjusted for the new card design
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
            }
          },
          child: CardOverView(
            type: overviewItems[index]['type'],
            value: overviewItems[index]['value'],
            icon: overviewItems[index]['icon'],
          ),
        );
      },
    );
  }
}
