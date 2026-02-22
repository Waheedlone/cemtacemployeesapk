import 'package:cnattendance/provider/holidayprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:hexcolor/hexcolor.dart';

class ToggleHoliday extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HolidayProvider>(context);
    return Center(
      child: ToggleSwitch(
        minWidth: 120,
        minHeight: 45,
        initialLabelIndex: provider.toggleValue,
        cornerRadius: 10.0,
        activeFgColor: Colors.white,
        inactiveBgColor: Colors.grey.shade200,
        inactiveFgColor: Colors.black,
        totalSwitches: 2,
        labels: ['Upcoming', 'Past'],
        activeBgColors: [
          [HexColor('#ED1C24')],
          [HexColor('#ED1C24')]
        ],
        onToggle: (index) {
          provider.toggleValue = index!;
          provider.holidayListFilter();
        },
      ),
    );
  }
}
