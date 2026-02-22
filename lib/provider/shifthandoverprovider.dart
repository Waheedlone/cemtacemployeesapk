import 'dart:convert';
import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:cnattendance/model/shifthandover.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';

class ShiftHandoverProvider with ChangeNotifier {
  List<ShiftHandover> _handovers = [];
  List<HandoverEmployee> _employees = [];
  bool _isLoading = false;
  ShiftHandover? _selectedHandover;

  List<ShiftHandover> get handovers => _handovers;
  List<HandoverEmployee> get employees => _employees;
  bool get isLoading => _isLoading;
  ShiftHandover? get selectedHandover => _selectedHandover;

  Future<void> fetchShiftHandovers({String? date}) async {
    _isLoading = true;
    notifyListeners();

    try {
      String url = Constant.SHIFT_HANDOVER_URL;
      if (date != null && date.isNotEmpty) {
        url += "?handover_date=$date";
      }

      final token = await Preferences().getToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await Connect().getResponse(url, headers);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['data'] is Map && responseData['data']['data'] is List) {
          final List<dynamic> data = responseData['data']['data'];
          _handovers = data.map((item) => ShiftHandover.fromJson(item)).toList();
        } else if (responseData['data'] is List) {
          final List<dynamic> data = responseData['data'];
          _handovers = data.map((item) => ShiftHandover.fromJson(item)).toList();
        }
      }
    } catch (e) {
      debugPrint("Error fetching shift handovers: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchShiftHandoverDetail(int id) async {
    _isLoading = true;
    _selectedHandover = null;
    notifyListeners();

    try {
      final url = "${Constant.SHIFT_HANDOVER_URL}/$id";
      final token = await Preferences().getToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await Connect().getResponse(url, headers);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['data'] is Map<String, dynamic>) {
          _selectedHandover = ShiftHandover.fromJson(responseData['data']);
        } else {
          _selectedHandover = ShiftHandover.fromJson(responseData);
        }
      }
    } catch (e) {
      debugPrint("Error fetching shift handover detail: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHandoverEmployees() async {
    try {
      final url = Constant.SHIFT_HANDOVER_EMPLOYEES_URL;
      final token = await Preferences().getToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await Connect().getResponse(url, headers);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final dynamic data = responseData['data'];
        if (data is List) {
          _employees = data.map((item) => HandoverEmployee.fromJson(item)).toList();
        } else if (data is Map && data['data'] is List) {
          final List<dynamic> list = data['data'];
          _employees = list.map((item) => HandoverEmployee.fromJson(item)).toList();
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching handover employees: $e");
    }
  }

  Future<String?> submitShiftHandover({
    required String date,
    required String summary,
    String? pendingTasks,
    String? criticalIssues,
    int? handoverToUserId,
    String? remarks,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Constant.SHIFT_HANDOVER_URL;
      final token = await Preferences().getToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final Map<String, String> body = {
        'handover_date': date,
        'summary': summary,
      };

      if (pendingTasks != null) body['pending_tasks'] = pendingTasks;
      if (criticalIssues != null) body['critical_issues'] = criticalIssues;
      if (handoverToUserId != null) body['handover_to_user_id'] = handoverToUserId.toString();
      if (remarks != null) body['remarks'] = remarks;

      final response = await Connect().postResponse(url, headers, json.encode(body));
      
      final responseData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchShiftHandovers();
        return null; // Success
      } else {
        return responseData['message'] ?? "Failed to submit handover";
      }
    } catch (e) {
      debugPrint("Error submitting shift handover: $e");
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
