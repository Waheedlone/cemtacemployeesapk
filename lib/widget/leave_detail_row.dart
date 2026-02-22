import 'package:cnattendance/provider/leaveprovider.dart';
import 'package:cnattendance/widget/cancel_leave_bottom_sheet.dart';
import 'package:cnattendance/widget/delete_leave_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class LeaveDetailRow extends StatelessWidget {
  final int id;
  final String name;
  final String from;
  final String to;
  final String status;
  final String authorization;
  final String requestedAt;

  LeaveDetailRow(
      {required this.id,
      required this.name,
      required this.from,
      required this.to,
      required this.status,
      required this.authorization,
      required this.requestedAt});

  @override
  Widget build(BuildContext context) {
    void onLeaveCancelledClicked(int id) {
      showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          builder: (context) {
            return CancelLeaveBottomSheet(id);
          });
    }

    void onLeaveDeleteClicked(int id) {
      showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          builder: (context) {
            return DeleteLeaveBottomSheet(id);
          });
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (status.toLowerCase() == "pending") {
                          onLeaveCancelledClicked(id);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: getStatusColor(),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        onLeaveDeleteClicked(id);
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(color: Colors.grey.shade200),
            SizedBox(height: 10),
            _buildInfoRow(Icons.date_range, "From", from),
            SizedBox(height: 10),
            _buildInfoRow(Icons.date_range, "To", to),
            SizedBox(height: 10),
            _buildInfoRow(Icons.person_outline, "By", authorization == '' ? "N/A" : authorization),
            SizedBox(height: 10),
            _buildInfoRow(Icons.timer_outlined, "Requested At", requestedAt),

          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 18),
        SizedBox(width: 10),
        Text(
          '$label: ',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Color getStatusColor() {
    switch (status) {
      case "Approved":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      case "Pending":
        return Colors.orange;
      case "Cancelled":
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}
