import 'package:cnattendance/provider/dashboardprovider.dart';
import 'package:cnattendance/widget/customalertdialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class AttedanceBottomSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AttendanceBottomSheetState();
}

class AttendanceBottomSheetState extends State<AttedanceBottomSheet> {
  bool isEnabled = true;
  bool isLoading = false;

  void onCheckOut() async {
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    try {
      setState(() {
        isLoading = true;
        EasyLoading.show(
            status: "Requesting...", maskType: EasyLoadingMaskType.black);
      });
      var status = await provider.getCheckInStatus();
      if (status) {
        final response = await provider.checkOutAttendance();
        isEnabled = true;
        if (!mounted) {
          return;
        }
        setState(() {
          EasyLoading.dismiss(animation: true);
          isLoading = false;
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: CustomAlertDialog(response.message),
              );
            },
          );
        });
      }
    } catch (e) {
      setState(() {
        EasyLoading.dismiss(animation: true);
        isLoading = false;
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: CustomAlertDialog(e.toString()),
            );
          },
        );
      });
    }
  }

  void onCheckIn() async {
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    try {
      isLoading = true;
      setState(() {
        EasyLoading.show(
            status: "Requesting...", maskType: EasyLoadingMaskType.black);
      });
      var status = await provider.getCheckInStatus();
      if (status) {
        final response = await provider.checkInAttendance();
        isEnabled = true;
        if (!mounted) {
          return;
        }
        setState(() {
          EasyLoading.dismiss(animation: true);
          isLoading = false;
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: CustomAlertDialog(response.message),
              );
            },
          );
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        EasyLoading.dismiss(animation: true);
        isLoading = false;
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: CustomAlertDialog(e.toString()),
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
    final lastCheckIn = provider.attendanceList['check-in'];
    final lastCheckOut = provider.attendanceList['check-out'];

    bool hasCheckedIn = lastCheckIn != null &&
        lastCheckIn != '-' &&
        lastCheckIn != '' &&
        lastCheckIn != 'null';
    bool hasCheckedOut = lastCheckOut != null &&
        lastCheckOut != '-' &&
        lastCheckOut != '' &&
        lastCheckOut != 'null';

    Widget button = const SizedBox.shrink();
    if (!hasCheckedIn) {
      button = ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: HexColor('#070532'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        onPressed: () {
          if (isEnabled) onCheckIn();
          isEnabled = false;
        },
        child: const Text(
          'Check in',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    } else if (hasCheckedIn && !hasCheckedOut) {
      button = ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: HexColor('#ED1C24'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        onPressed: () {
          if (isEnabled) onCheckOut();
          isEnabled = false;
        },
        child: const Text(
          'Check out',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        return !isLoading;
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Check in/out',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: button,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
