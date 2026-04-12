import 'package:cnattendance/provider/shiftrosterprovider.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ShiftRosterScreen extends StatefulWidget {
  static const String routeName = '/shift-roster';

  @override
  State<ShiftRosterScreen> createState() => _ShiftRosterScreenState();
}

class _ShiftRosterScreenState extends State<ShiftRosterScreen> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<ShiftRosterProvider>(context, listen: false)
          .fetchShiftRoster(month: selectedMonth, year: selectedYear);
    });
  }

  @override
  Widget build(BuildContext context) {
    final rosterProvider = Provider.of<ShiftRosterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Shift Roster', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: HexColor("#00002B"),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildMonthPicker(),
          Expanded(
            child: rosterProvider.isLoading
                ? Center(child: CircularProgressIndicator(color: HexColor("#ED1C24")))
                : rosterProvider.shifts.isEmpty
                    ? Center(child: Text('No shifts assigned for this month', style: TextStyle(color: Colors.grey, fontSize: 16)))
                    : ListView.builder(
                        padding: EdgeInsets.all(15),
                        itemCount: rosterProvider.shifts.length,
                        itemBuilder: (context, index) {
                          final shift = rosterProvider.shifts[index];
                          return _buildShiftCard(shift);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthPicker() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: HexColor("#00002B"),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                if (selectedMonth == 1) {
                  selectedMonth = 12;
                  selectedYear--;
                } else {
                  selectedMonth--;
                }
                Provider.of<ShiftRosterProvider>(context, listen: false)
                    .fetchShiftRoster(month: selectedMonth, year: selectedYear);
              });
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          ),
          Text(
            DateFormat('MMMM yyyy').format(DateTime(selectedYear, selectedMonth)),
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                if (selectedMonth == 12) {
                  selectedMonth = 1;
                  selectedYear++;
                } else {
                  selectedMonth++;
                }
                Provider.of<ShiftRosterProvider>(context, listen: false)
                    .fetchShiftRoster(month: selectedMonth, year: selectedYear);
              });
            },
            icon: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftCard(dynamic shift) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              width: 50,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: shift.isWeeklyOff ? Colors.grey.withOpacity(0.1) : HexColor("#ED1C24").withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat('dd').format(DateTime.parse(shift.date)),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: shift.isWeeklyOff ? Colors.grey : HexColor("#ED1C24")),
                  ),
                  Text(
                    DateFormat('E').format(DateTime.parse(shift.date)),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shift.isWeeklyOff ? "Weekly Off" : shift.shiftName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: HexColor("#00002B")),
                  ),
                  if (!shift.isWeeklyOff) ...[
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey),
                        SizedBox(width: 5),
                        Text(
                          '${shift.startTime} - ${shift.endTime}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (!shift.isWeeklyOff)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Working',
                  style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
