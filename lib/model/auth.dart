import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/model/login/Loginresponse.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:cnattendance/utils/deviceuuid.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:cnattendance/utils/log.dart';

class Auth with ChangeNotifier {
  Future<Loginresponse> login(String username, String password) async {
    Log.d("Auth", "Login initiated for user: $username");
    var uri = Uri.parse(Constant.LOGIN_URL);
    Log.d("Auth", "Login URL: ${Constant.LOGIN_URL}");

    Map<String, String> headers = {
      "Accept": "application/json; charset=UTF-8",
      "Content-Type": "application/json"
    };

    try {
      String? fcm;
      try {
        fcm = await FirebaseMessaging.instance.getToken();
        Log.d("Auth", "FCM Token: $fcm");
      } catch (e) {
        Log.e("Auth", "Failed to get FCM token: $e");
        fcm = "no_token_available"; // Fallback to non-empty placeholder if service is unavailable
      }
      String deviceType = 'android';
      if (kIsWeb) {
        deviceType = 'web';
      } else if (Platform.isIOS) {
        deviceType = 'ios';
      } else if (Platform.isAndroid) {
        deviceType = 'android';
      } else {
        deviceType = 'desktop';
      }

      final response = await Connect().postResponse(uri.toString(), headers, json.encode({
        'username': username,
        'password': password,
        'fcm_token': fcm ?? 'no_token',
        'device_type': deviceType,
        'uuid': await DeviceUUid().getUniqueDeviceId(),
      }));

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        Log.d("Auth", "Login Successful. Response: $responseData");

        Preferences preferences = Preferences();
        final responseJson = Loginresponse.fromJson(responseData);
        await preferences.saveUser(responseJson.data);

        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        Log.e("Auth", "Login Failed: $errorMessage");
        throw errorMessage;
      }
    } catch (error) {
      Log.e("Auth", "Login Exception: $error");
      throw error;
    }
  }
}
