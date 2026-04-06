import 'package:cnattendance/utils/responsive.dart';
import 'package:cnattendance/screen/gatepassscreen.dart';
import 'package:cnattendance/screen/profile/aboutscreen.dart';
import 'package:cnattendance/screen/profile/bankdetailsscreen.dart';
import 'package:cnattendance/screen/profile/changepasswordscreen.dart';
import 'package:cnattendance/screen/profile/companyrulesscreen.dart';
import 'package:cnattendance/screen/profile/holidayscreen.dart';
import 'package:cnattendance/screen/profile/leavecalendarscreen.dart';
import 'package:cnattendance/screen/profile/meetingscreen.dart';
import 'package:cnattendance/screen/profile/noticescreen.dart';
import 'package:cnattendance/screen/profile/profilescreen.dart';
import 'package:cnattendance/screen/profile/supportscreen.dart';
import 'package:cnattendance/screen/profile/teamsheetscreen.dart';
import 'package:cnattendance/screen/tadascreen/TadaScreen.dart';
import 'package:cnattendance/screen/substitutionscreen.dart';
import 'package:cnattendance/screen/overtimescreen.dart';
import 'package:cnattendance/screen/internal_requisition/internal_requisition_list_screen.dart';
import 'package:cnattendance/screen/shifthandoverscreen.dart';
import 'package:cnattendance/screen/operations/daily_entry_screen.dart';
import 'package:cnattendance/screen/dashboard/leaveconfirmationscreen.dart';
import 'package:cnattendance/screen/operations/operations_history_screen.dart';
import 'package:cnattendance/provider/prefprovider.dart';
import 'package:cnattendance/widget/headerprofile.dart';
import 'package:flutter/material.dart';
import 'package:cnattendance/widget/morescreen/services.dart';
import 'package:provider/provider.dart';

class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 1200),
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderProfile(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Services',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Services('Profile', Icons.person_outline, ProfileScreen()),
                  Services('Change Password', Icons.lock_outline, ChangePasswordScreen()),
           //       Services('Meeting', Icons.calendar_today_outlined, MeetingScreen()),
                  Services('Holiday', Icons.card_giftcard_outlined, HolidayScreen()),
                  Services('Team Sheet', Icons.group_outlined, TeamSheetScreen()),
                   Services('Leave Calendar', Icons.calendar_month_outlined, LeaveCalendarScreen()),
                  Services('Notices', Icons.notifications_outlined, NoticeScreen()),
                  Services('Daily Site Entry', Icons.edit_note, DailyEntryScreen()),
                  Services('Operations History', Icons.history, OperationsHistoryScreen()),
                  Services('Leave Confirmation', Icons.rule, LeaveConfirmationScreen()),
                  Services('Requisition', Icons.account_balance_outlined, InternalRequisitionListScreen()),
                  Services('Substitute', Icons.time_to_leave_outlined, SubstitutionScreen()),
                  Services('Gate Pass', Icons.account_balance_wallet_outlined, GatePassScreen()),
                  Services('Shift Handover', Icons.sync_alt, ShiftHandoverScreen()),
                  Services('Overtime', Icons.more_time, OvertimeScreen()),
                  Services('Support', Icons.headset_mic_outlined, SupportScreen()),
                 //  Services('Bank Details', Icons.account_balance_outlined, BankDetailsScreen()),
                //  Services('TADA', Icons.account_balance_wallet_outlined, TadaScreen()),
                  Services('Face Registration', Icons.face, ProfileScreen()),
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                    child: Text(
                      'Additional',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
//                Services('Company Rules', Icons.rule_folder_outlined, CompanyRulesScreen()),
                  Services('About Us', Icons.info_outline, AboutScreen('about-us')),
                  Services(
                      'Terms and Conditions', Icons.rule_outlined, AboutScreen('terms-and-conditions')),
                  Services('Log Out', Icons.logout, ProfileScreen()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
