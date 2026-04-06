import 'package:cnattendance/utils/responsive.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:cnattendance/widget/headerprofile.dart';
import 'package:cnattendance/widget/leavescreen/issueleavesheet.dart';
import 'package:cnattendance/widget/leavescreen/leave_list_dashboard.dart';
import 'package:cnattendance/widget/leavescreen/leave_list_detail_dashboard.dart';
import 'package:cnattendance/widget/leavescreen/leavetypefilter.dart';
import 'package:cnattendance/widget/leavescreen/toggleleavetime.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cnattendance/provider/leaveprovider.dart';
import 'package:hexcolor/hexcolor.dart';

class LeaveScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LeaveScreenState();
}

class LeaveScreenState extends State<LeaveScreen> {
  var init = true;
  var isVisible = false;

  @override
  void didChangeDependencies() {
    if (init) {
      initialState();
      init = false;
    }
    super.didChangeDependencies();
  }

  Future<String> initialState() async {
    final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);
    final leaveData = await leaveProvider.getLeaveType();

    if (!mounted) {
      return "Loaded";
    }
    if (leaveData.statusCode != 200) {
      showToast(leaveData.message);
    }

    getLeaveDetailList();
    return "Loaded";
  }

  void getLeaveDetailList() async {
    final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);
    final detailResponse = await leaveProvider.getLeaveTypeDetail();

    if (!mounted) {
      return;
    }
    if (detailResponse.statusCode == 200) {
      setState(() {
        isVisible = true;
      });
      if (detailResponse.data.isEmpty) {
        // showToast('No leave history found');
      }
    } else {
      showToast(detailResponse.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return initialState();
          },
          child: SingleChildScrollView(
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
                    Text('Leave', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    LeaveListDashboard(),
                    SizedBox(height: 20),
                    Align(
                      alignment: Responsive.isMobile(context) ? Alignment.center : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: Responsive.isMobile(context) ? double.infinity : 300),
                        child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              useRootNavigator: true,
                              builder: (context) {
                                return IssueLeaveSheet();
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor('#ED1C24'),
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Apply for Leave', style: TextStyle(color: Colors.white, fontSize: 18),)
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text("Recent Leave Activity",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    if (isVisible)
                      LeaveListdetailDashboard()
                    else
                      Center(child: CircularProgressIndicator()),
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
