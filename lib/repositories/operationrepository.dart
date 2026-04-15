import 'dart:convert';
import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';

class OperationRepository {
  Future<Map<String, dynamic>> postDailyEntry(int operationId, String date, double reading, String remarks) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    Map<String, dynamic> body = {
      'operation_id': operationId,
      'date': date,
      'reading': reading,
      'remarks': remarks,
    };

    try {
      final response = await Connect().postResponse(Constant.OPERATIONS_DAILY_ENTRIES_URL, headers, json.encode(body));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else {
        throw responseData['message'] ?? "Failed to log entry";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getAssignedUnits() async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect().getResponse(Constant.OPERATIONS_ASSIGNED_UNITS_URL, headers);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData['data'] ?? [];
      } else {
        throw responseData['message'] ?? "Failed to fetch units";
      }
    } catch (e) {
      debugPrint("OperationRepository getAssignedUnits error: $e");
      rethrow;
    }
  }

  Future<List<dynamic>> getDailyEntries(int month, int year) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect().getResponse("${Constant.OPERATIONS_DAILY_ENTRIES_URL}?month=$month&year=$year", headers);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData['data'] ?? [];
      } else {
        throw responseData['message'] ?? "Failed to fetch history";
      }
    } catch (e) {
      debugPrint("OperationRepository getDailyEntries error: $e");
      rethrow;
    }
  }
}

