import 'package:cnattendance/utils/responsive.dart';
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
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    GatePassScreen(),
    AttendanceScreen(),
    LeaveScreen(),
    MoreScreen(),
  ];

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PrefProvider>(context, listen: false).getUser();
    });
  }

  PersistentTabController _controller = PersistentTabController(initialIndex: 0);
 
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _controller.jumpToTab(index);
    });
  }
 
  @override
  Widget build(BuildContext context) {
    Provider.of<PrefProvider>(context);
 
    return Responsive(
      mobile: Scaffold(
        body: PersistentTabView(
          controller: _controller,
          tabs: _buildTabs(),
          onTabChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
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
      ),
      tablet: Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              labelType: NavigationRailLabelType.none,
              extended: false,
              backgroundColor: HexColor("#00002B").withOpacity(0.02),
              selectedIconTheme: IconThemeData(color: HexColor("#ED1C24"), size: 30),
              unselectedIconTheme: IconThemeData(color: HexColor("#00002B").withOpacity(0.5)),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.local_activity_outlined),
                  selectedIcon: Icon(Icons.local_activity),
                  label: Text('Gate Pass'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.lock_outline),
                  selectedIcon: Icon(Icons.lock),
                  label: Text('Attendance'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_off_outlined),
                  selectedIcon: Icon(Icons.person_off),
                  label: Text('Leave'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.menu_open_outlined),
                  selectedIcon: Icon(Icons.menu_open),
                  label: Text('More'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: _screens[_selectedIndex],
            ),
          ],
        ),
      ),
      desktop: Scaffold(
        body: Row(
          children: [
            Container(
              width: 250,
              color: HexColor("#00002B").withOpacity(0.03),
              child: NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onItemTapped,
                extended: true,
                backgroundColor: Colors.transparent,
                selectedIconTheme: IconThemeData(color: HexColor("#ED1C24")),
                unselectedIconTheme: IconThemeData(color: HexColor("#00002B").withOpacity(0.6)),
                selectedLabelTextStyle: TextStyle(color: HexColor("#ED1C24"), fontWeight: FontWeight.bold),
                unselectedLabelTextStyle: TextStyle(color: HexColor("#00002B").withOpacity(0.6)),
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Image.asset('assets/icons/cemtac.png', height: 80),
                ),
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: Text('Dashboard'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.local_activity_outlined),
                    selectedIcon: Icon(Icons.local_activity),
                    label: Text('Gate Pass'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.lock_outline),
                    selectedIcon: Icon(Icons.lock),
                    label: Text('Attendance'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person_off_outlined),
                    selectedIcon: Icon(Icons.person_off),
                    label: Text('Leave'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.menu_open_outlined),
                    selectedIcon: Icon(Icons.menu_open),
                    label: Text('More Settings'),
                  ),
                ],
              ),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: ClipRRect(
                child: _screens[_selectedIndex],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
