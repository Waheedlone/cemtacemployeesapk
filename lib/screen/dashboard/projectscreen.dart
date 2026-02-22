import 'package:cnattendance/provider/projectdashboardcontroller.dart';
import 'package:cnattendance/screen/profile/changepasswordscreen.dart';
import 'package:cnattendance/widget/headerprofile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProjectScreen extends StatelessWidget {
  final model = Get.put(ProjectDashboardController());

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
          return model.getProjectOverview();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  HeaderProfile(),
                  SizedBox(height: 20),
                  projectOverview(),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor('#ED1C24'),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Get.to(ChangePasswordScreen());
                      },
                      child: Text(
                        'Change Password',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget projectOverview() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Obx(
                () => CircularPercentIndicator(
                  radius: 50.0,
                  animation: true,
                  animationDuration: 1200,
                  lineWidth: 12.0,
                  percent: (model.overview.value['progress']?.toDouble() ?? 0) / 100,
                  center: Obx(
                    () => Text(
                      (model.overview.value['progress']?.toString() ?? "0") + "%",
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          color: HexColor('#ED1C24')),
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.grey.shade200,
                  progressColor: HexColor('#ED1C24'),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Progress Current Task",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  SizedBox(height: 10),
                  Obx(
                    () => Text(
                        (model.overview.value['task_completed']?.toString() ?? "0") +
                            " / " +
                            (model.overview.value['total_task']?.toString() ?? "0") +
                            " Task Completed",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
