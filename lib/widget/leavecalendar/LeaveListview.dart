import 'package:cnattendance/provider/leavecalendarprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaveListview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LeaveCalendarProvider>(context);
    final leaveList = provider.employeeLeaveByDayList;

    if (leaveList.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy_outlined, size: 60, color: Colors.grey[300]),
                    const SizedBox(height: 10),
                    const Text("No leaves for this date", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 10),
      itemCount: leaveList.length,
      itemBuilder: (context, index) {
        final leave = leaveList[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                offset: const Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.redAccent.withOpacity(0.2), width: 2),
              ),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: leave.avatar.isNotEmpty ? NetworkImage(leave.avatar) : null,
                backgroundColor: Colors.grey[200],
                child: leave.avatar.isEmpty ? const Icon(Icons.person, color: Colors.grey) : null,
              ),
            ),
            title: Text(
              leave.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                leave.post,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${leave.days} days",
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
