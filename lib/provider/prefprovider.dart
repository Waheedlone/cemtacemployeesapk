import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:flutter/material.dart';
import 'package:cnattendance/data/source/network/model/login/Login.dart';
import 'package:cnattendance/data/source/network/model/login/User.dart';

class PrefProvider with ChangeNotifier {
  var _userName = '';
  var _fullname = '';
  var _avatar = '';
  var _auth = false;

  String get userName {
    return _userName;
  }

  String get fullname {
    return _fullname;
  }

  String get avatar {
    return _avatar;
  }

  bool get auth {
    return _auth;
  }

  void getUser() async {
    Preferences preferences = Preferences();

    _userName = await preferences.getUsername();
    _fullname = await preferences.getFullName();
    _avatar = await preferences.getAvatar();
    notifyListeners();
  }

  Future<bool> getUserAuth() async {
    Preferences preferences = Preferences();
    return await preferences.getUserAuth();
  }

  void saveUser(Login data) async {
    Preferences preferences = Preferences();
    preferences.saveUser(data);
    notifyListeners();
  }

  void saveBasicUser(User user) async {
    Preferences preferences = Preferences();
    preferences.saveBasicUser(user);
    notifyListeners();
  }

  void saveAuth(bool value) async {
    Preferences preferences = Preferences();
    preferences.saveUserAuth(value);

    _auth = await preferences.getUserAuth();
    notifyListeners();
  }
}
