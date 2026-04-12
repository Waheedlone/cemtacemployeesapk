import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cnattendance/utils/ssl_helper.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/model/auth.dart';
import 'package:cnattendance/provider/attendancereportprovider.dart';
import 'package:cnattendance/provider/dashboardprovider.dart';
import 'package:cnattendance/provider/gatepassprovider.dart';
import 'package:cnattendance/provider/holidayprovider.dart';
import 'package:cnattendance/provider/leaveprovider.dart';
import 'package:cnattendance/provider/meetingprovider.dart';
import 'package:cnattendance/provider/morescreenprovider.dart';
import 'package:cnattendance/provider/notificationprovider.dart';
import 'package:cnattendance/provider/shifthandoverprovider.dart';
import 'package:cnattendance/provider/operationprovider.dart';
import 'package:cnattendance/provider/overtimeprovider.dart';
import 'package:cnattendance/provider/internal_requisition_provider.dart';
import 'package:cnattendance/provider/payslipprovider.dart';
import 'package:cnattendance/provider/prefprovider.dart';
import 'package:cnattendance/provider/profileprovider.dart';
import 'package:cnattendance/provider/shiftrosterprovider.dart';
import 'package:cnattendance/provider/substitutionprovider.dart';
import 'package:cnattendance/screen/auth/login_screen.dart';
import 'package:cnattendance/screen/dashboard/dashboard_screen.dart';
import 'package:cnattendance/screen/profile/editprofilescreen.dart';
import 'package:cnattendance/screen/profile/payslipdetailscreen.dart';
import 'package:cnattendance/screen/profile/profilescreen.dart';
import 'package:cnattendance/screen/profile/meetingdetailscreen.dart';
import 'package:cnattendance/screen/profile/bankdetailsscreen.dart';
import 'package:cnattendance/screen/profile/officialdetailsscreen.dart';
import 'package:cnattendance/screen/internal_requisition/internal_requisition_list_screen.dart';
import 'package:cnattendance/screen/shifthandoverscreen.dart';
import 'package:cnattendance/screen/shifthandoverdetailscreen.dart';
import 'package:cnattendance/screen/overtimescreen.dart';
import 'package:cnattendance/screen/overtimerequestscreen.dart';
import 'package:cnattendance/screen/overtimedetailscreen.dart';
import 'package:cnattendance/screen/substitutionscreen.dart';
import 'package:cnattendance/screen/substitutionrequestscreen.dart';
import 'package:cnattendance/screen/substitutiondetailscreen.dart';
import 'package:cnattendance/screen/substitutionapprovalscreen.dart';
import 'package:cnattendance/screen/dashboard/shift_roster_screen.dart';
import 'package:cnattendance/screen/splashscreen.dart';
import 'package:cnattendance/utils/face_service.dart';
import 'package:cnattendance/utils/navigationservice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:cnattendance/services/notification_service.dart';
import 'package:cnattendance/services/tflite_service.dart';

import 'package:in_app_notification/in_app_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Firebase with a robust check to avoid duplicate-app errors
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      print("Firebase already initialized (apps list not empty)");
    }
  } catch (e) {
    print("Firebase initialization error or already initialized: $e");
  }

  final tfliteService = TfliteService();
  if (!kIsWeb) {
    await tfliteService.loadModel();
  }
  final faceService = FaceService(interpreter: tfliteService.interpreter);

  // FCM only for mobile (and web if configured)
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await NotificationService.initialize();
 
    // Request permissions for FCM
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      criticalAlert: true,
      sound: true,
    );
 
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
 
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationService.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationService.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationService.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationService.onDismissActionReceivedMethod,
    );
 
    FirebaseMessaging.onBackgroundMessage(_messageHandler);
  }

  // Firebase Messaging handlers disabled for web


  await SSLHelper.setup();

  runApp(MyApp(
    tfliteService: tfliteService,
    faceService: faceService,
  ));
  configLoading();
}

/// Top-level background message handler.
@pragma('vm:entry-point')
Future<void> _messageHandler(RemoteMessage message) async {
  // Ensure Flutter bindings are initialised for this isolate
  WidgetsFlutterBinding.ensureInitialized();
  print("Background message received: ${message.messageId}");

  // Initialise Firebase in this isolate if needed
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    // Also initialize AwesomeNotifications in this isolate
    await NotificationService.initialize();

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationService.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationService.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationService.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationService.onDismissActionReceivedMethod,
    );
  } catch (e) {
    print("Background Firebase/Notification initialization error: $e");
  }

  // Show a heads-up system notification with sound using AwesomeNotifications
  // Note: NotificationService handles the AwesomeNotifications call
  await NotificationService.showFromFCM(
    title: message.notification?.title ?? message.data['title'] ?? 'Digital HR',
    body: message.notification?.body ?? message.data['body'] ?? 'You have a new notification',
    payload: message.data.map((key, value) => MapEntry(key, value.toString())),
  );
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.cubeGrid
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 50.0
    ..radius = 0.0
    ..progressColor = Colors.blue
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.blue
    ..textColor = Colors.black
    ..maskType = EasyLoadingMaskType.none
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  final TfliteService tfliteService;
  final FaceService faceService;

  const MyApp({Key? key, required this.tfliteService, required this.faceService})
      : super(key: key);

  //  adb logcat | findstr digitalhrs This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          Provider<TfliteService>.value(
            value: tfliteService,
          ),
          Provider<FaceService>.value(
            value: faceService,
          ),
          ChangeNotifierProvider(
            create: (ctx) => Preferences(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => LeaveProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => PrefProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => ProfileProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => AttendanceReportProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => DashboardProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => MoreScreenProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => MeetingProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => PaySlipProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => NotificationProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => GatePassProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => HolidayProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => InternalRequisitionProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => ShiftHandoverProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => OvertimeProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => SubstitutionProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => OperationProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => ShiftRosterProvider(),
          ),
        ],
        child: Portal(
          child: InAppNotification(
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              onVerticalDragDown: (details) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: GetMaterialApp(
                navigatorKey: NavigationService.navigatorKey,
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  canvasColor: Colors.white,
                  cardColor: Colors.white,
                  scaffoldBackgroundColor: Colors.white,
                  fontFamily: 'GoogleSans',
                  primarySwatch: Colors.red,
                  textTheme: const TextTheme(
                    displayLarge: TextStyle(fontWeight: FontWeight.bold),
                    displayMedium: TextStyle(fontWeight: FontWeight.bold),
                    displaySmall: TextStyle(fontWeight: FontWeight.bold),
                    headlineLarge: TextStyle(fontWeight: FontWeight.bold),
                    headlineMedium: TextStyle(fontWeight: FontWeight.bold),
                    headlineSmall: TextStyle(fontWeight: FontWeight.bold),
                    titleLarge: TextStyle(fontWeight: FontWeight.bold),
                    titleMedium: TextStyle(fontWeight: FontWeight.bold),
                    titleSmall: TextStyle(fontWeight: FontWeight.bold),
                    bodyLarge: TextStyle(fontWeight: FontWeight.bold),
                    bodyMedium: TextStyle(fontWeight: FontWeight.bold),
                    bodySmall: TextStyle(fontWeight: FontWeight.bold),
                    labelLarge: TextStyle(fontWeight: FontWeight.bold),
                    labelMedium: TextStyle(fontWeight: FontWeight.bold),
                    labelSmall: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                initialRoute: '/',
                routes: {
                  '/': (_) => SplashScreen(),
                  LoginScreen.routeName: (_) => LoginScreen(),
                  DashboardScreen.routeName: (_) => DashboardScreen(),
                  ProfileScreen.routeName: (_) => ProfileScreen(),
                  EditProfileScreen.routeName: (_) => EditProfileScreen(),
                  MeetingDetailScreen.routeName: (_) => MeetingDetailScreen(),
                  PaySlipDetailScreen.routeName: (_) => PaySlipDetailScreen(),
                  BankDetailsScreen.routeName: (_) => BankDetailsScreen(),
                  OfficialDetailsScreen.routeName: (_) =>
                      OfficialDetailsScreen(),
                  ShiftHandoverScreen.routeName: (_) => ShiftHandoverScreen(),
                  ShiftHandoverDetailScreen.routeName: (ctx) {
                    final handover = ModalRoute.of(ctx)!.settings.arguments as dynamic;
                    return ShiftHandoverDetailScreen(handover: handover);
                  },
                  OvertimeScreen.routeName: (_) => OvertimeScreen(),
                  OvertimeRequestScreen.routeName: (_) => OvertimeRequestScreen(),
                  OvertimeDetailScreen.routeName: (ctx) {
                    final ot = ModalRoute.of(ctx)!.settings.arguments as dynamic;
                    return OvertimeDetailScreen(overtime: ot);
                  },
                  SubstitutionScreen.routeName: (_) => SubstitutionScreen(),
                  SubstitutionRequestScreen.routeName: (_) => SubstitutionRequestScreen(),
                  SubstitutionDetailScreen.routeName: (ctx) {
                    final substitution = ModalRoute.of(ctx)!.settings.arguments as dynamic;
                    return SubstitutionDetailScreen(substitution: substitution);
                  },
                  SubstitutionApprovalScreen.routeName: (_) => SubstitutionApprovalScreen(),
                  ShiftRosterScreen.routeName: (_) => ShiftRosterScreen(),
                },
                builder: EasyLoading.init(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
