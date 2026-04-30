import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/model/departmentlistresponse/departmentlistresponse.dart';
import 'package:cnattendance/data/source/network/model/support/SupportResponse.dart';
import 'package:cnattendance/model/department.dart';
import 'package:cnattendance/screen/profile/supportlistscreen.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:cnattendance/widget/customalertdialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:cnattendance/data/source/network/connect.dart';

class SupportController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  var selected = Department("0", "").obs;

  var departments = <Department>[].obs;
  var isLoading = false.obs;

  final form = GlobalKey<FormState>();

  void onSubmitClicked() {
    if (form.currentState!.validate()) {
      if (selected.value.id != "0") {
        sendSupportMessage(titleController.text, descriptionController.text);
      } else {
        showToast("Please select a department");
      }
    }
  }

  Future<SupportResponse> sendSupportMessage(
      String title, String description) async {
    var uri = Uri.parse(Constant.SUPPORT_URL);

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      EasyLoading.show(
          status: 'Submitting, Please Wait...',
          maskType: EasyLoadingMaskType.black);
      final response = await Connect().postResponse(uri.toString(), headers, json.encode({
        "subject": title,
        "description": description,
        "department_id": selected.value.id.toString()
      }));
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      EasyLoading.dismiss(animation: true);

      if (response.statusCode == 200) {
        final supportResponse = SupportResponse.fromJson(responseData);

        titleController.clear();
        descriptionController.clear();

        Get.dialog(
            Container(
                margin: EdgeInsets.all(20),
                width: double.infinity,
                height: 500,
                child:
                    Center(child: CustomAlertDialog(supportResponse.message))),
            barrierDismissible: false);
        return supportResponse;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (e) {
      EasyLoading.dismiss(animation: true);
      throw e;
    }
  }

  Future<void> getDepartments() async {
    var uri = Uri.parse(Constant.DEPARTMENT_LIST_URL);

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      isLoading.value = true;
      final response = await Connect().getResponse(uri.toString(), headers);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);
      print(responseData);

      if (response.statusCode == 200) {
        departments.clear();
        final departmentResponse =
            departmentlistresponse.fromJson(responseData);

        for (var department in departmentResponse.data) {
          departments.add(Department(department.id, department.dept_name));
        }
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (e) {
      EasyLoading.dismiss(animation: true);
      throw e;
    } finally {
      isLoading.value = false;
    }
  }

  void showList() {
    Get.to(SupportListScreen(), transition: Transition.cupertino);
  }

  @override
  void onInit() {
    getDepartments();
    super.onInit();
  }
}
