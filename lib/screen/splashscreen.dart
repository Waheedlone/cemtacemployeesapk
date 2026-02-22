import 'dart:async';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/screen/auth/login_screen.dart';
import 'package:cnattendance/screen/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashState();
}

class SplashState extends State<SplashScreen> {
  @override
  void initState() {

    Timer(
      const Duration(milliseconds: 800),
      () async {
        Preferences preferences = Preferences();
        if (await preferences.getToken() == '') {
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        } else {
          Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Image.asset(
        "assets/icons/cemtac.png",
        width: 160,
        height: 160,
      )),
    );
  }
}
