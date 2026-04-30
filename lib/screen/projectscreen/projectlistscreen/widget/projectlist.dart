import 'package:cnattendance/screen/projectscreen/projectlistscreen/projectlistscrreencontroller.dart';
import 'package:cnattendance/screen/projectscreen/projectlistscreen/widget/projectcard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProjectListScreenController model = Get.find();
    return Obx(
      () => model.filteredList.isEmpty
          ? ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Center(child: Text("No projects found", style: TextStyle(color: Colors.white))),
                ),
              ],
            )
          : ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: model.filteredList.length,
              itemBuilder: (context, index) {
                final item = model.filteredList[index];
                return ProjectCard(item);
              },
            ),
    );
  }
}
