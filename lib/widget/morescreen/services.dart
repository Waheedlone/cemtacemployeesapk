import 'package:cnattendance/screen/profile/changepasswordscreen.dart';
import 'package:cnattendance/screen/gatepassscreen.dart';
import 'package:cnattendance/screen/holidayscreen.dart';
import 'package:cnattendance/screen/notificationscreen.dart';
import 'package:cnattendance/screen/noticescreen.dart';
import 'package:cnattendance/screen/profile/leavecalendarscreen.dart';
import 'package:cnattendance/screen/rulesscreen.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:cnattendance/widget/log_out_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/screen/auth/face_registration_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';
import 'package:cnattendance/provider/dashboardprovider.dart';
import 'package:cnattendance/widget/morescreen/createissuesheet.dart';

class Services extends StatelessWidget {
  final String name;
  final IconData icon;
  final Widget route;

  Services(this.name, this.icon, this.route);

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, color: Colors.red, size: 30),
        title: Text(
          name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
        onTap: () {
          if (name == 'Privacy Policy') {
            openBrowserTab();
          } else if (name == 'Log Out') {
            final dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
            if (dashboardProvider.isCheckIn) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Please check out before logging out.')));
              return;
            }

            showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                builder: (context) {
                  return LogOutBottomSheet();
                });
          } else if (name == 'Face Registration') {
            final pref = Provider.of<Preferences>(context, listen: false);
            pref.getUsername().then((username) {
              pushScreen(context,
                  screen: FaceRegistrationScreen(username: username),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.fade);
            });
          } else if (name == 'Issue Ticket') {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useRootNavigator: true,
                builder: (context) {
                  return CreateIssueSheet();
                });
          } else if (name == 'Leave Calendar') {
            pushScreen(context,
                screen: LeaveCalendarScreen(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.fade);
          } else if (name == 'Holidays') {
            pushScreen(context,
                screen: HolidayScreen(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.fade);
          } else if (name == 'Change Password') {
            pushScreen(context,
                screen: ChangePasswordScreen(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.fade);
          } else if (name == 'Company Rules') {
            pushScreen(context,
                screen: RulesScreen(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.fade);
          } else if (name == 'Notifications') {
            pushScreen(context,
                screen: NotificationScreen(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.fade);
          } else if (name == 'Notices') {
            pushScreen(context,
                screen: NoticeScreen(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.fade);
          } else if (name == 'Gate Pass') {
            pushScreen(context,
                screen: GatePassScreen(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.fade);
          } else {
            pushScreen(context,
                screen: route,
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.fade);
          }
        },
      ),
    );
  }

  openBrowserTab() async {
    await FlutterWebBrowser.openWebPage(
      url: Constant.PRIVACY_POLICY_URL,
      customTabsOptions: const CustomTabsOptions(
        colorScheme: CustomTabsColorScheme.dark,
        shareState: CustomTabsShareState.on,
        instantAppsEnabled: true,
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: const SafariViewControllerOptions(
        barCollapsingEnabled: true,
        preferredBarTintColor: Colors.black,
        preferredControlTintColor: Colors.grey,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  }
}
