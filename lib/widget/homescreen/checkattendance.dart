import 'package:cnattendance/provider/dashboardprovider.dart';
import 'package:cnattendance/provider/prefprovider.dart';
import 'package:cnattendance/screen/auth/face_verification_screen.dart';
import 'package:cnattendance/utils/authservice.dart';
import 'package:cnattendance/utils/firestore_service.dart';
import 'package:cnattendance/widget/attendance_bottom_sheet.dart';
import 'package:cnattendance/widget/customalertdialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class CheckAttendance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CheckAttendanceState();
}

class CheckAttendanceState extends State<CheckAttendance> {
  late Stream<DateTime> _dateTimeStream;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _dateTimeStream =
        Stream.periodic(const Duration(seconds: 1), (i) => DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final attendanceList = dashboardProvider.attendanceList;
    final pref = Provider.of<PrefProvider>(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StreamBuilder<DateTime>(
            stream: _dateTimeStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final now = snapshot.data!;
                final formattedTime = DateFormat('hh:mm').format(now);
                final formattedAmPm = DateFormat('a').format(now);
                final formattedDate =
                    DateFormat('EEEE, MMMM d, yyyy').format(now);

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          formattedTime,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          formattedAmPm,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      formattedDate,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                );
              }
              return CircularProgressIndicator();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: GestureDetector(
              onTap: () async {
                final firestoreService = FirestoreService();
                final username = pref.userName;
                bool hasFace =
                    await firestoreService.hasRegisteredFace(username);

                if (hasFace) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FaceVerificationScreen(
                      onSuccess: () {
                        showModalBottomSheet(
                            context: context,
                            useRootNavigator: true,
                            builder: (context) {
                              return AttedanceBottomSheet();
                            });
                      },
                    ),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please register your face first.')));
                }
              },
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: HexColor('#ED1C24'),
                  boxShadow: [
                    BoxShadow(
                      color: HexColor('#ED1C24').withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.face,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: dashboardProvider.isCheckIn
                  ? HexColor('#ED1C24')
                  : HexColor('#070532'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            onPressed: () async {
              if (isProcessing) return;

              final firestoreService = FirestoreService();
              final username = pref.userName;
              bool hasFace = await firestoreService.hasRegisteredFace(username);

              if (hasFace) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FaceVerificationScreen(
                    onSuccess: () async {
                      try {
                        setState(() {
                          isProcessing = true;
                          EasyLoading.show(
                              status: "Requesting...",
                              maskType: EasyLoadingMaskType.black);
                        });

                        bool hasLocation =
                            await dashboardProvider.getCheckInStatus();
                        if (hasLocation) {
                          final response = dashboardProvider.isCheckIn
                              ? await dashboardProvider.checkOutAttendance()
                              : await dashboardProvider.checkInAttendance();

                          setState(() {
                            EasyLoading.dismiss(animation: true);
                            isProcessing = false;
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: CustomAlertDialog(response.message),
                                );
                              },
                            );
                          });
                        } else {
                          setState(() {
                            isProcessing = false;
                            EasyLoading.dismiss(animation: true);
                          });
                        }
                      } catch (e) {
                        setState(() {
                          isProcessing = false;
                          EasyLoading.dismiss(animation: true);
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
                    },
                  ),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please register your face first.')));
              }
            },
            child: Text(
              dashboardProvider.isCheckIn ? 'Check Out' : 'Check In',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(height: 15),
          Text(
            attendanceList['production_hour'] ?? '0 hr 0 min',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
