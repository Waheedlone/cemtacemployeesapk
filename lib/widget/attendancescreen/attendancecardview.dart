import 'package:flutter/material.dart';

class AttendanceCardView extends StatelessWidget {
  final int index;
  final String date;
  final String day;
  final String start;
  final String end;

  AttendanceCardView(this.index, this.date, this.day, this.start, this.end);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLabeledText("Date", date),
                _buildLabeledText("Day", day, alignItems: CrossAxisAlignment.center),
                _buildLabeledText("Start Time", start, alignItems: CrossAxisAlignment.end),
              ],
            ),
            SizedBox(height: 16),
            Divider(color: Colors.grey.shade200),
            SizedBox(height: 16),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLabeledText("End Time", end),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledText(String label, String value, {CrossAxisAlignment alignItems = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: alignItems,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
