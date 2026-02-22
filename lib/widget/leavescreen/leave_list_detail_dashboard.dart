import 'package:cnattendance/provider/leaveprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaveListdetailDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final leaveProvider = Provider.of<LeaveProvider>(context);
    final items = leaveProvider.leaveDetailList;

    if (items.isEmpty) {
      return Center(child: Text("No leave activity found."));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (ctx, index) {
        final leave = items[index];
        final Color statusColor = leave.status.toLowerCase() == 'approved'
            ? Colors.green
            : leave.status.toLowerCase() == 'rejected'
                ? Colors.red
                : Colors.orange;

        return Card(
          elevation: 1,
          margin: EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Container(
              width: 6,
              height: 40,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            title: Text(leave.name, style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text("${leave.leave_from} - ${leave.leave_to}"),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                leave.status,
                style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ),
          ),
        );
      },
    );
  }
}
