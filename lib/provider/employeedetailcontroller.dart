import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/model/employeedetailresponse/Data.dart';
import 'package:cnattendance/data/source/network/model/employeedetailresponse/employeedetailresponse.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:cnattendance/model/profile.dart' as up;
import 'package:cnattendance/data/source/network/connect.dart';

class EmployeeDetailController extends GetxController{
  var  profile = up.Profile(
      id: 0,
      avatar: '',
      name: '',
      username: '',
      email: '',
      post: '',
      phone: '',
      dob: '',
      gender: '',
      address: '',
      bankName: '',
      bankNumber: '',
      joinedDate: '').obs;
  
  Future<employeedetailresponse> getEmployeeDetail(String id) async {
    var uri = Uri.parse(Constant.EMPLOYEE_PROFILE_URL+"/$id");

    Preferences preferences = Preferences();

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      EasyLoading.show(
          status: 'Loading....',
          maskType: EasyLoadingMaskType.black);
      final response = await Connect().getResponse(uri.toString(), headers);
      EasyLoading.dismiss(animation: true);
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        print(responseData.toString());

        final responseJson = employeedetailresponse.fromJson(responseData);
        parseUser(responseJson.data, int.parse(id));

        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      rethrow;
    }
  }

  void parseUser(Data rprofile, int id) {
    profile.value.id = id;
    profile.value.avatar = rprofile.avatar;
    profile.value.name = rprofile.name;
    profile.value.username = rprofile.username;
    profile.value.post = rprofile.post;
    profile.value.phone = rprofile.phone;
    profile.value.dob = rprofile.dob;
    profile.value.gender = rprofile.gender;
    profile.value.address = rprofile.address;

    profile.refresh();
  }

  @override
  void onInit() {
    getEmployeeDetail(Get.arguments["employeeId"]);
    super.onInit();
  }
}