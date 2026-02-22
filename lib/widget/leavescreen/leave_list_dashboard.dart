import 'package:cnattendance/provider/leaveprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';

class LeaveListDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final leaveProvider = Provider.of<LeaveProvider>(context);
    final items = leaveProvider.leaveList;

    if (leaveProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
      return Center(child: Text("No leave types available"));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (ctx, index) {
        final leave = items[index];
        return Container(
          decoration: BoxDecoration(
            color: HexColor('#ED1C24').withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                leave.allocated.toString(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: HexColor('#ED1C24'),
                ),
              ),
              SizedBox(height: 4),
              Text(
                leave.name,
                style: TextStyle(fontSize: 11, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
