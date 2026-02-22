import 'package:cnattendance/provider/holidayprovider.dart';
import 'package:cnattendance/widget/holiday/holidaycard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HolidayCardView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final holidayList = Provider.of<HolidayProvider>(context).holidayList;
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: holidayList.length,
        itemBuilder: (ctx, i) {
          return Holidaycard(
              id : holidayList[i].id,
              name :holidayList[i].title,
              month :holidayList[i].month,
              day : holidayList[i].day,
              desc : holidayList[i].description);
        });
  }

}