import 'package:cnattendance/model/overtime.dart';
import 'package:cnattendance/provider/overtimeprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class OvertimeDetailScreen extends StatelessWidget {
  static const String routeName = '/overtime-detail';

  final Overtime overtime;

  OvertimeDetailScreen({required this.overtime});

  void _approve(BuildContext context) async {
    EasyLoading.show(status: 'Approving...');
    final error = await Provider.of<OvertimeProvider>(context, listen: false)
        .approveOvertime(overtime.id);
    EasyLoading.dismiss();

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Overtime approved successfully")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  void _reject(BuildContext context) async {
    final TextEditingController remarksController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Reject Overtime"),
        content: TextField(
          controller: remarksController,
          decoration: InputDecoration(hintText: "Enter rejection reason"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text("Cancel")),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              EasyLoading.show(status: 'Rejecting...');
              final error = await Provider.of<OvertimeProvider>(context,
                      listen: false)
                  .rejectOvertime(overtime.id, remarksController.text);
              EasyLoading.dismiss();

              if (error == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Overtime rejected successfully")));
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(error)));
              }
            },
            child: Text("Reject", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Overtime Details",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusHeader(),
            SizedBox(height: 24),
            _buildDetailSection("Record Information", [
              _buildDetailRow("Employee", overtime.employeeName),
              _buildDetailRow("Period", "${overtime.month}/${overtime.year}"),
              _buildDetailRow("Request Date", overtime.createdAt),
            ]),
            SizedBox(height: 16),
            _buildDetailSection("Financials", [
              _buildDetailRow("OT Hours", "${overtime.otHours} hrs"),
              _buildDetailRow("OT Rate", "${overtime.otRate}"),
              _buildDetailRow("OT Amount", "${overtime.otAmount}"),
            ]),
            SizedBox(height: 16),
            if (overtime.remarks != null)
              _buildDetailSection("Remarks", [
                Text(overtime.remarks!, style: TextStyle(color: Colors.grey[700])),
              ]),
            if (overtime.approvedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text("Approved At: ${overtime.approvedAt}",
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
              ),
            if (overtime.status.toLowerCase() == 'pending') ...[
              SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _reject(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("Reject", style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _approve(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("Approve",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Center(
                    child: Text("(Approver Actions)",
                        style: TextStyle(fontSize: 10, color: Colors.grey))),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    Color statusColor = _getStatusColor(overtime.status);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text("Current Status", style: TextStyle(fontSize: 12, color: statusColor)),
          SizedBox(height: 4),
          Text(overtime.status.toUpperCase(),
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: statusColor)),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Divider(),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'paid':
        return Colors.blue;
      case 'pending':
      default:
        return Colors.orange;
    }
  }
}
