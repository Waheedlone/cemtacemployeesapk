import 'package:cnattendance/provider/leavecalendarprovider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:hexcolor/hexcolor.dart';

class LeaveCalendarView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LeaveCalendarViewState();
}

class _LeaveCalendarViewState extends State<LeaveCalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LeaveCalendarProvider>(context);

    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.black),
        rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.black),
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: HexColor('#ED1C24').withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: HexColor('#ED1C24'),
          shape: BoxShape.circle,
        ),
        markerDecoration: BoxDecoration(
          color: HexColor('#ED1C24'),
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
        defaultTextStyle: const TextStyle(color: Colors.black),
        weekendTextStyle: const TextStyle(color: Colors.red),
      ),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          provider.getLeavesByDay(DateFormat('yyyy-MM-dd').format(selectedDay));
        }
      },
      eventLoader: (day) {
        return provider.employeeLeaveList[DateFormat('yyyy-MM-dd').format(day)] ?? [];
      },
    );
  }
}
