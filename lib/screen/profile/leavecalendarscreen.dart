import 'package:cnattendance/provider/leavecalendarprovider.dart';
import 'package:cnattendance/widget/leavecalendar/LeaveCalendarView.dart';
import 'package:cnattendance/widget/leavecalendar/LeaveListview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaveCalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LeaveCalendarProvider(),
      child: LeaveCalendarScreenContent(),
    );
  }
}

class LeaveCalendarScreenContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LeaveCalendarScreenContentState();
}

class _LeaveCalendarScreenContentState extends State<LeaveCalendarScreenContent> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLeaveData();
    });
  }

  Future<void> _fetchLeaveData() async {
    try {
      await Provider.of<LeaveCalendarProvider>(context, listen: false).getLeaves();
    } catch (e) {
      // Handle error if needed
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Leave Calendar", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                LeaveCalendarView(),
                Expanded(child: LeaveListview()),
              ],
            ),
    );
  }
}
