import 'package:cnattendance/utils/responsive.dart';
import 'package:cnattendance/data/source/network/model/login/User.dart';
import 'package:cnattendance/provider/dashboardprovider.dart';
import 'package:cnattendance/provider/prefprovider.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:cnattendance/widget/homescreen/checkattendance.dart';
import 'package:cnattendance/widget/homescreen/overviewdashboard.dart';
import 'package:cnattendance/widget/homescreen/weeklyreportchart.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cnattendance/widget/headerprofile.dart';
import 'package:cnattendance/services/notification_service.dart';
import 'package:cnattendance/provider/notificationprovider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Listen for foreground FCM messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received: ${message.notification?.title}");
      NotificationService.showFromFCM(
        title: message.notification?.title ?? message.data['title'] ?? 'Digital HR',
        body: message.notification?.body ?? message.data['body'] ?? 'New notification',
        payload: message.data.map((key, value) => MapEntry(key, value.toString())),
      );
      
      // Update badge count immediately
      Provider.of<NotificationProvider>(context, listen: false).increment();
    });
  }

  @override
  void didChangeDependencies() {
    loadDashboard();
    super.didChangeDependencies();
  }

  Future<String> loadDashboard() async {
    try {
      // Load cached attendance status first for immediate UI feedback
      await Provider.of<DashboardProvider>(context, listen: false).loadAttendanceStatus();

      // Refresh notification badge count
      Provider.of<NotificationProvider>(context, listen: false).fetchUnreadCount();

      // Attempt to get FCM token with a slight delay and retry
      // This helps mitigate 'SERVICE_NOT_AVAILABLE' errors during early startup
      String? fcm;
      for (int i = 0; i < 3; i++) {
        try {
          fcm = await FirebaseMessaging.instance.getToken();
          if (fcm != null) break;
        } catch (e) {
          print("FCM Token attempt ${i + 1} failed: $e");
          await Future.delayed(Duration(seconds: 2 * (i + 1)));
        }
      }
      print("FCM Token: $fcm");
    } catch (e) {
      print("Failed to get FCM token in HomeScreen: $e");
    }

    try {
      final dashboardResponse =
          await Provider.of<DashboardProvider>(context, listen: false)
               .getDashboard();

       final user = dashboardResponse.data.user;

       Provider.of<PrefProvider>(context, listen: false).saveBasicUser(User(
           id: user.id,
           name: user.name,
           email: user.email,
           username: user.username,
           avatar: user.avatar));

       return 'loaded';
    } catch (e) {
      print("Dashboard load error: $e");
      return 'loaded';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        color: Colors.white,
        backgroundColor: Colors.blueGrey,
        edgeOffset: 50,
        onRefresh: () {
          return loadDashboard();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 1200),
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 20 : 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderProfile(),
                    SizedBox(height: 20),
                    if (Responsive.isMobile(context))
                      CheckAttendance()
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: CheckAttendance()),
                          SizedBox(width: 20),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Attendance History',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          DateFormat('MMMM').format(DateTime.now()),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (Responsive.isMobile(context)) ...[
                      SizedBox(height: 20),
                      Text(
                        'Attendance History',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('MMMM').format(DateTime.now()),
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 20),
                    OverviewDashboard(),
                    SizedBox(height: 20),
                  //  WeeklyReportChart(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
