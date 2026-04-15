import 'package:cnattendance/provider/holidayprovider.dart';
import 'package:cnattendance/widget/holiday/holidaycardview.dart';
import 'package:cnattendance/widget/holiday/toggleholiday.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class HolidayScreen extends StatelessWidget {
  static const routeName = '/holidays';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HolidayProvider(),
      child: Holiday(),
    );
  }
}

class Holiday extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HolidayState();
}

class HolidayState extends State<Holiday> {
  var inital = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (inital) {
      loadHolidays();
      inital = false;
    }
    super.didChangeDependencies();
  }

  Future<String> loadHolidays() async {
    setState(() {
      isLoading = true;
    });
    EasyLoading.show(status: "Loading", maskType: EasyLoadingMaskType.black);
    try {
      await Provider.of<HolidayProvider>(context, listen: false).getHolidays();
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      isLoading = false;
    });
    EasyLoading.dismiss(animation: true);

    return "loaded";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return !isLoading;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text('Holidays', style: TextStyle(color: Colors.black)),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return loadHolidays();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [ToggleHoliday(), HolidayCardView()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
