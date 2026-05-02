import 'package:cnattendance/data/source/network/model/login/User.dart';
import 'package:cnattendance/data/source/network/model/login/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences with ChangeNotifier {
  final String USER_ID = "user_id";
  final String USER_AVATAR = "user_avatar";
  final String USER_TOKEN = "user_token";
  final String USER_EMAIL = "user_email";
  final String USER_NAME = "user_name";
  final String USER_FULLNAME = "user_fullname";
  final String USER_AUTH = "user_auth";
  final String APP_IN_ENGLISH = "eng_date";
  final String USER_FACE_REGISTERED = "user_face_registered";
  final String LAST_CHECK_IN = "last_check_in";
  final String LAST_CHECK_OUT = "last_check_out";
  final String DASHBOARD_DATA = "dashboard_data";

  Future<bool> saveUser(Login data) async {
    // Obtain shared preferences.
    User user = data.user;
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(USER_TOKEN, data.tokens);
    await prefs.setInt(USER_ID, user.id);
    await prefs.setString(USER_AVATAR, user.avatar);
    await prefs.setString(USER_EMAIL, user.email);
    await prefs.setString(USER_NAME, user.username);
    await prefs.setString(USER_FULLNAME, user.name);

    notifyListeners();

    return true;
  }

  void saveBasicUser(User user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(USER_ID, user.id);
    await prefs.setString(USER_AVATAR, user.avatar);
    await prefs.setString(USER_EMAIL, user.email);
    await prefs.setString(USER_NAME, user.username);
    await prefs.setString(USER_FULLNAME, user.name);

    notifyListeners();
  }

  Future<void> clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(USER_ID, 0);
    await prefs.setString(USER_TOKEN, '');
    await prefs.setString(USER_AVATAR, '');
    await prefs.setString(USER_EMAIL, '');
    await prefs.setString(USER_NAME, '');
    await prefs.setString(USER_FULLNAME, '');
    await prefs.setBool(USER_AUTH, false);
    await prefs.setBool(APP_IN_ENGLISH, true);
    await prefs.setBool(USER_FACE_REGISTERED, false);
    await prefs.setString(LAST_CHECK_IN, '-');
    await prefs.setString(LAST_CHECK_OUT, '-');

    notifyListeners();
  }

  void saveUserAuth(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(USER_AUTH, value);
  }
  void saveAppEng(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(APP_IN_ENGLISH, value);
  }

  Future<void> saveFaceRegistered(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(USER_FACE_REGISTERED, value);
  }

  Future<bool> getFaceRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(USER_FACE_REGISTERED) ?? false;
  }

  Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    return User(
        id: prefs.getInt(USER_ID) ?? 0,
        name: prefs.getString(USER_FULLNAME) ?? "",
        email: prefs.getString(USER_EMAIL) ?? "",
        username: prefs.getString(USER_NAME) ?? "",
        avatar: prefs.getString(USER_AVATAR) ?? "");
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(USER_TOKEN) ?? "";
  }

  Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(USER_ID) ?? 0;
  }

  Future<bool> getUserAuth() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(USER_AUTH) ?? false;
  }

  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_NAME) ?? "";
  }

  Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_EMAIL) ?? "";
  }

  Future<String> getAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_AVATAR) ?? "";
  }

  Future<String> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_FULLNAME) ?? "";
  }

  Future<bool> getEnglishDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(APP_IN_ENGLISH) ?? true;
  }

  Future<void> saveAttendanceStatus(String checkIn, String checkOut) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LAST_CHECK_IN, checkIn);
    await prefs.setString(LAST_CHECK_OUT, checkOut);
  }

  Future<Map<String, String>> getAttendanceStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'check-in': prefs.getString(LAST_CHECK_IN) ?? '-',
      'check-out': prefs.getString(LAST_CHECK_OUT) ?? '-',
    };
  }

  Future<void> saveDashboardCache(String json) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(DASHBOARD_DATA, json);
  }

  Future<String?> getDashboardCache() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(DASHBOARD_DATA);
  }
}
