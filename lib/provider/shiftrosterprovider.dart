import 'dart:convert';
import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:cnattendance/data/source/network/model/shiftroster/ShiftRoster.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';

class ShiftRosterProvider with ChangeNotifier {
  List<ShiftRosterData> _shifts = [];
  bool _isLoading = false;

  List<ShiftRosterData> get shifts => _shifts;
  bool get isLoading => _isLoading;

  Future<void> fetchShiftRoster({int? month, int? year}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      int selectedMonth = month ?? now.month;
      int selectedYear = year ?? now.year;

      String url = "${Constant.SHIFT_ROSTER_URL}?month=$selectedMonth&year=$selectedYear";

      final token = await Preferences().getToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await Connect().getResponse(url, headers);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final shiftResponse = ShiftRosterResponse.fromJson(responseData);
        _shifts = shiftResponse.data;
      } else {
        _shifts = [];
      }
    } catch (e) {
      debugPrint("Error fetching shift roster: $e");
      _shifts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
