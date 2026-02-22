import 'dart:convert';
import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:cnattendance/model/overtime.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';

class OvertimeProvider with ChangeNotifier {
  List<Overtime> _records = [];
  List<Overtime> _forApprovalRecords = [];
  bool _isLoading = false;
  Overtime? _selectedRecord;

  List<Overtime> get records => _records;
  List<Overtime> get forApprovalRecords => _forApprovalRecords;
  bool get isLoading => _isLoading;
  Overtime? get selectedRecord => _selectedRecord;

  Future<void> fetchOvertimeRecords({int? month, int? year, String? status}) async {
    _isLoading = true;
    notifyListeners();

    try {
      String url = Constant.OVERTIME_URL;
      List<String> params = [];
      if (month != null) params.add("month=$month");
      if (year != null) params.add("year=$year");
      if (status != null) params.add("status=$status");

      if (params.isNotEmpty) {
        url += "?" + params.join("&");
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
          _records = data.map((item) => Overtime.fromJson(item)).toList();
        } else if (responseData['data'] is List) {
          final List<dynamic> data = responseData['data'];
          _records = data.map((item) => Overtime.fromJson(item)).toList();
        }
      }
    } catch (e) {
      debugPrint("Error fetching overtime records: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOvertimeDetail(int id) async {
    _isLoading = true;
    _selectedRecord = null;
    notifyListeners();

    try {
      final url = "${Constant.OVERTIME_URL}/$id";
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
          _selectedRecord = Overtime.fromJson(responseData['data']);
        } else {
          _selectedRecord = Overtime.fromJson(responseData);
        }
      }
    } catch (e) {
      debugPrint("Error fetching overtime detail: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> submitOvertimeRequest({
    required int month,
    required int year,
    required double otHours,
    String? remarks,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Constant.OVERTIME_REQUEST_URL;
      final token = await Preferences().getToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final Map<String, dynamic> body = {
        'month': month,
        'year': year,
        'ot_hours': otHours,
      };

      if (remarks != null) body['remarks'] = remarks;

      final response = await Connect().postResponse(url, headers, json.encode(body));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchOvertimeRecords();
        return null; // Success
      } else {
        return responseData['message'] ?? "Failed to submit overtime request";
      }
    } catch (e) {
      debugPrint("Error submitting overtime request: $e");
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOvertimeForApproval({int? month, int? year}) async {
    _isLoading = true;
    notifyListeners();

    try {
      String url = Constant.OVERTIME_FOR_APPROVAL_URL;
      List<String> params = [];
      if (month != null) params.add("month=$month");
      if (year != null) params.add("year=$year");

      if (params.isNotEmpty) {
        url += "?" + params.join("&");
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
        final dynamic data = responseData['data'];
        if (data is List) {
          _forApprovalRecords = data.map((item) => Overtime.fromJson(item)).toList();
        } else if (data is Map && data['data'] is List) {
          final List<dynamic> list = data['data'];
          _forApprovalRecords = list.map((item) => Overtime.fromJson(item)).toList();
        }
      }
    } catch (e) {
      debugPrint("Error fetching overtime for approval: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> approveOvertime(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = "${Constant.API_URL}/overtime/$id/approve";
      final token = await Preferences().getToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await Connect().postResponse(url, headers, json.encode({}));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        await fetchOvertimeForApproval();
        return null; // Success
      } else {
        return responseData['message'] ?? "Failed to approve overtime";
      }
    } catch (e) {
      debugPrint("Error approving overtime: $e");
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> rejectOvertime(int id, String? remarks) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = "${Constant.API_URL}/overtime/$id/reject";
      final token = await Preferences().getToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = remarks != null ? {'remarks': remarks} : {};

      final response = await Connect().postResponse(url, headers, json.encode(body));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        await fetchOvertimeForApproval();
        return null; // Success
      } else {
        return responseData['message'] ?? "Failed to reject overtime";
      }
    } catch (e) {
      debugPrint("Error rejecting overtime: $e");
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
