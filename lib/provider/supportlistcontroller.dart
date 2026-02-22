import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/model/departmentlistresponse/departmentlistresponse.dart';
import 'package:cnattendance/data/source/network/model/support/SupportResponse.dart';
import 'package:cnattendance/data/source/network/model/supportlistresponse/supportlistresponse.dart';
import 'package:cnattendance/model/department.dart';
import 'package:cnattendance/model/support.dart';
import 'package:cnattendance/screen/profile/supportdetailscreen.dart';
import 'package:cnattendance/screen/profile/supportlistscreen.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:cnattendance/widget/customalertdialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:intl/intl.dart';

class SupportListController extends GetxController {
  var supportList = <Support>[].obs;
  final filteredList = <Support>[].obs;

  final selected = "All".obs;

  Future<void> getSupportList() async {
    var uri = Uri.parse(Constant.SUPPORT_LIST_URL + "?per_page=50&page=1");

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      EasyLoading.show(
          status: 'Loading....', maskType: EasyLoadingMaskType.black);
      final response = await Connect().getResponse(uri.toString(), headers);
      debugPrint(response.body.toString());
      EasyLoading.dismiss(animation: true);

      final responseData = json.decode(response.body);
      print(responseData);

      if (response.statusCode == 200) {
        final supportResponse = supportlistresponse.fromJson(responseData);
        final list = <Support>[];
        for (var support in supportResponse.data.data) {
          final date = new DateFormat('MMMM dd yyyy').parse(support.query_date);
          list.add(Support(
              support.title,
              support.description,
              support.query_date,
              support.status,
              support.requested_department,
              date.day.toString(),
              DateFormat("MMMM").format(date),
              support.updated_by,
              support.updated_at));
        }

        supportList.value = list;
        filterList();
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (e) {
      EasyLoading.dismiss(animation: true);
      throw e;
    }
  }

  void filterList() {
    filteredList.clear();
    if (selected.value == "All") {
      filteredList.addAll(supportList);
    } else {
      for (var support in supportList) {
        if (support.status == selected.value) {
          filteredList.add(support);
        }
      }
    }
  }

  @override
  Future<void> onInit() async {
    await getSupportList();
    super.onInit();
  }

  void onSupportClicked(Support support){
    Get.to(SupportDetailScreen(support),transition: Transition.cupertino);
  }
}
