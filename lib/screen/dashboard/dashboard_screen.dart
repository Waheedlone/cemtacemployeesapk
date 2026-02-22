import 'package:cnattendance/provider/prefprovider.dart';
import 'package:cnattendance/screen/dashboard/homescreen.dart';
import 'package:cnattendance/screen/dashboard/leavescreen.dart';
import 'package:cnattendance/screen/dashboard/attendancescreen.dart';
import 'package:cnattendance/screen/dashboard/morescreen.dart';
import 'package:cnattendance/screen/gatepassscreen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';

class DashboardScreen extends StatefulWidget {
  static const String routeName = '/dashboard';

  @override
  State<StatefulWidget> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {

  List<PersistentTabConfig> _buildTabs() {
    return [
      PersistentTabConfig(
        screen: HomeScreen(),
        item: ItemConfig(
          icon: Icon(Icons.home),
          activeForegroundColor: HexColor("#ED1C24"),
          inactiveForegroundColor: Colors.grey,
        ),
      ),
      PersistentTabConfig(
        screen: GatePassScreen(),
        item: ItemConfig(
          icon: Icon(Icons.local_activity),
          activeForegroundColor: HexColor("#ED1C24"),
          inactiveForegroundColor: Colors.grey,
        ),
      ),
      PersistentTabConfig(
        screen: AttendanceScreen(),
        item: ItemConfig(
          icon: Icon(Icons.lock),
          activeForegroundColor: HexColor("#ED1C24"),
          inactiveForegroundColor: Colors.grey,
        ),
      ),
      PersistentTabConfig(
        screen: LeaveScreen(),
        item: ItemConfig(
          icon: Icon(Icons.search),
          activeForegroundColor: HexColor("#ED1C24"),
          inactiveForegroundColor: Colors.grey,
        ),
      ),
      PersistentTabConfig(
        screen: MoreScreen(),
        item: ItemConfig(
          icon: Icon(Icons.menu),
          activeForegroundColor: HexColor("#ED1C24"),
          inactiveForegroundColor: Colors.grey,
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    final prefProvider = Provider.of<PrefProvider>(context);
    prefProvider.getUser();
    return Scaffold(
      body: PersistentTabView(
        controller: _controller,
        tabs: _buildTabs(),
        navBarBuilder: (navBarConfig) => Style11BottomNavBar(
          navBarConfig: navBarConfig,
          navBarDecoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(0.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(0, -1),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
      ),
    );
  }
}
