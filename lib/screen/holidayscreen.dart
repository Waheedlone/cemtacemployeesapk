import 'package:cnattendance/provider/holidayprovider.dart';
import 'package:cnattendance/widget/holiday_row.dart';
import 'package:cnattendance/widget/holiday/toggleholiday.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class HolidayScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HolidayScreenState();
}

class _HolidayScreenState extends State<HolidayScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHolidays();
  }

  Future<void> _fetchHolidays() async {
    try {
      await Provider.of<HolidayProvider>(context, listen: false).getHolidays();
    } catch (e) {
      // Handle error
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
    final provider = Provider.of<HolidayProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Holidays",
          style: TextStyle(color: HexColor("#011754")
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: HexColor("#011754"),
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ToggleHoliday(),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.holidayList.length,
                    itemBuilder: (context, index) {
                      final holiday = provider.holidayList[index];
                      return Container(
                        color: Colors.white,
                        child: HolidayRow(holiday),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
