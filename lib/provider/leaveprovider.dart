import 'dart:convert';

import 'package:cnattendance/data/source/network/model/leaveissue/IssueLeaveResponse.dart';
import 'package:cnattendance/data/source/network/model/leavetype/LeaveType.dart';
import 'package:cnattendance/data/source/network/model/leavetype/Leavetyperesponse.dart';
import 'package:cnattendance/data/source/network/model/leavetypedetail/LeaveTypeDetail.dart';
import 'package:cnattendance/data/source/network/model/leavetypedetail/Leavetypedetailreponse.dart';
import 'package:cnattendance/model/LeaveDetail.dart';
import 'package:cnattendance/model/leave.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:cnattendance/data/source/datastore/preferences.dart';

class LeaveProvider with ChangeNotifier {
  final List<Leave> _leaveList = [];
  final List<LeaveDetail> _leaveDetailList = [];
  final List<LeaveDetail> _leaveForConfirmationList = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<LeaveDetail> get leaveForConfirmationList => _leaveForConfirmationList;

  var _selectedMonth = 0;
  var _selectedType = 0;

  int get selectedMonth {
    return _selectedMonth;
  }

  void setMonth(int value) {
    _selectedMonth = value;
  }

  int get selectedType {
    return _selectedType;
  }

  void setType(int value) {
    _selectedType = value;
  }

  List<Leave> get leaveList {
    return [..._leaveList];
  }

  List<LeaveDetail> get leaveDetailList {
    return [..._leaveDetailList];
  }

  Future<Leavetyperesponse> getLeaveType() async {
    _isLoading = true;
    notifyListeners();
    var uri = Uri.parse(Constant.LEAVE_TYPE_URL);

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect().getResponse(uri.toString(), headers);
      debugPrint("API Response Status: ${response.statusCode}");
      debugPrint("API Response Body: ${response.body}");

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        debugPrint("API Decoded Data: $responseData");

        final responseJson = Leavetyperesponse.fromJson(responseData);
        makeLeaveList(responseJson.data);

        _isLoading = false;
        notifyListeners();
        return responseJson;
      } else {
        _isLoading = false;
        notifyListeners();
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      throw error;
    }
  }

  void makeLeaveList(List<LeaveType> leaveList) {
    _leaveList.clear();

    for (var leave in leaveList) {
      _leaveList.add(Leave(
          id: int.parse(leave.leaveTypeId.toString()),
          name: leave.leaveTypeName,
          allocated: leave.leaveTaken,
          total: double.parse(leave.totalLeaveAllocated.toString()).toInt(),
          status: leave.leaveTypeStatus,
          isEarlyLeave: leave.earlyExit));
    }

    notifyListeners();
  }

  Future<Leavetypedetailreponse> getLeaveTypeDetail() async {
    _isLoading = true;
    notifyListeners();
    var uri =
        Uri.parse(Constant.LEAVE_TYPE_DETAIL_URL).replace(queryParameters: {
      'month': _selectedMonth != 0 ? _selectedMonth.toString() : '',
      'leave_type': _selectedType != 0 ? _selectedType.toString() : '',
    });

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect().getResponse(uri.toString(), headers);

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        debugPrint(responseData.toString());

        final responseJson = Leavetypedetailreponse.fromJson(responseData);

        makeLeaveTypeList(responseJson.data);

        _isLoading = false;
        notifyListeners();
        return responseJson;
      } else {
        _isLoading = false;
        notifyListeners();
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      throw error;
    }
  }

  void makeLeaveTypeList(List<LeaveTypeDetail> leaveList) {
    _leaveDetailList.clear();

    for (var leave in leaveList) {
      _leaveDetailList.add(LeaveDetail(
          id: leave.id,
          name: leave.leaveTypeName,
          leave_from: leave.leaveFrom,
          leave_to: leave.leaveTo,
          requested_date: leave.leaveRequestedDate,
          authorization: leave.statusUpdatedBy,
          status: leave.status));
    }

    notifyListeners();
  }

  Future<IssueLeaveResponse> issueLeave(
      String from, String to, String reason, int leaveId, {String? earlyExit, int isHalfDay = 0}) async {
    var uri = Uri.parse(Constant.ISSUE_LEAVE);

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect().postResponse(uri.toString(), headers, json.encode({
        'leave_from': from,
        'leave_to': to,
        'leave_type_id': leaveId,
        'reasons': reason,
        'is_half_day': isHalfDay,
        if (earlyExit != null) 'early_exit': earlyExit,
      }));

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final responseJson = IssueLeaveResponse.fromJson(responseData);

        debugPrint(responseJson.toString());
        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      debugPrint(error.toString());
      throw error;
    }
  }

  Future<IssueLeaveResponse> cancelLeave(int leaveId) async {
    var uri = Uri.parse(Constant.CANCEL_LEAVE);

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect().postResponse(uri.toString(), headers, json.encode({'leave_id': leaveId}));

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final responseJson = IssueLeaveResponse.fromJson(responseData);

        debugPrint(responseJson.toString());
        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      debugPrint(error.toString());
      throw error;
    }
  }
  
  Future<IssueLeaveResponse> deleteLeave(int leaveId) async {
    var uri = Uri.parse(Constant.DELETE_LEAVE_URL + "/$leaveId");

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect().deleteResponse(uri.toString(), headers);

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final responseJson = IssueLeaveResponse.fromJson(responseData);

        debugPrint(responseJson.toString());
        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      debugPrint(error.toString());
      throw error;
    }
  }

  Future<void> fetchLeaveForConfirmation() async {
    _isLoading = true;
    notifyListeners();

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect().getResponse(Constant.LEAVE_FOR_CONFIRMATION_URL, headers);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = responseData['data'];
        _leaveForConfirmationList.clear();
        for (var item in data) {
          _leaveForConfirmationList.add(LeaveDetail(
            id: item['id'],
            name: item['leave_type_name'],
            leave_from: item['leave_from'],
            leave_to: item['leave_to'],
            requested_date: item['leave_requested_date'],
            authorization: item['status_updated_by'] ?? "Pending",
            status: item['status'],
          ));
        }
      }
    } catch (e) {
      debugPrint("Error fetching leave for confirmation: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<IssueLeaveResponse> confirmLeave(int id, String status, String remarks) async {
    var url = "${Constant.LEAVE_CONFIRM_URL}/$id/confirm";

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    Map<String, String> body = {
      'status': status,
      'admin_remark': remarks,
    };

    try {
      final response = await Connect().postResponse(url, headers, json.encode(body));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return IssueLeaveResponse.fromJson(responseData);
      } else {
        throw responseData['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
