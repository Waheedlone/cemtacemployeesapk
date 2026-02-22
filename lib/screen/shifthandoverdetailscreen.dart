import 'package:cnattendance/model/shifthandover.dart';
import 'package:flutter/material.dart';

class ShiftHandoverDetailScreen extends StatelessWidget {
  static const String routeName = '/shifthandover-detail';
  final ShiftHandover handover;

  const ShiftHandoverDetailScreen({Key? key, required this.handover})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Handover Details",
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
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow("Handover Date", handover.handoverDate),
                  _buildDetailRow("Handed Over To", handover.handoverToName ?? "N/A"),
                  _buildDetailRow("Created At", handover.createdAt),
                ],
              ),
            ),
            SizedBox(height: 30),
            _buildSection("Summary", handover.summary),
            if (handover.pendingTasks != null && handover.pendingTasks!.isNotEmpty)
              _buildSection("Pending Tasks", handover.pendingTasks!),
            if (handover.criticalIssues != null && handover.criticalIssues!.isNotEmpty)
              _buildSection("Critical Issues", handover.criticalIssues!),
            if (handover.remarks != null && handover.remarks!.isNotEmpty)
              _buildSection("Remarks", handover.remarks!),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text(
          content,
          style: TextStyle(color: Colors.grey.shade700, height: 1.5),
        ),
        SizedBox(height: 25),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          Text(value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}

