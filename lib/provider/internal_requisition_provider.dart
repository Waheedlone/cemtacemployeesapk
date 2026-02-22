import 'dart:convert';
import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:cnattendance/model/internal_requisition.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';

class InternalRequisitionProvider with ChangeNotifier {
  List<InternalRequisition> _requisitions = [];
  bool _isLoading = false;

  List<InternalRequisition> get requisitions => _requisitions;
  bool get isLoading => _isLoading;

  Future<void> fetchRequisitions() async {
    _isLoading = true;
    notifyListeners();

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await Connect().getResponse(
          Constant.INTERNAL_REQUISITIONS_FOR_APPROVAL, headers);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final data = responseData['data'];
        if (data is Map && data['data'] is List) {
          _requisitions = (data['data'] as List)
              .map((item) => InternalRequisition.fromJson(item))
              .toList();
        } else if (data is List) {
          _requisitions = data.map((item) => InternalRequisition.fromJson(item)).toList();
        } else {
          _requisitions = [];
        }
      } else {
        throw responseData['message'] ?? 'Failed to load requisitions';
      }
    } catch (e) {
      debugPrint("Error fetching requisitions: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<InternalRequisition> fetchRequisitionDetail(int id) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await Connect().getResponse(
          "${Constant.INTERNAL_REQUISITIONS_FOR_APPROVAL}/$id", headers);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return InternalRequisition.fromJson(responseData['data']);
      } else {
        throw responseData['message'] ?? 'Failed to load requisition detail';
      }
    } catch (e) {
      debugPrint("Error fetching requisition detail: $e");
      rethrow;
    }
  }

  Future<void> approveRequisition(int id) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await Connect().postResponse(
          "${Constant.INTERNAL_REQUISITIONS_APPROVE}/$id/approve", headers, {});

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        _requisitions.removeWhere((item) => item.id == id);
        notifyListeners();
      } else {
        throw responseData['message'] ?? 'Failed to approve requisition';
      }
    } catch (e) {
      debugPrint("Error approving requisition: $e");
      rethrow;
    }
  }

  Future<void> rejectRequisition(int id, String remarks) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    Map<String, String> body = {
      'remarks': remarks,
    };

    try {
      final response = await Connect().postResponse(
          "${Constant.INTERNAL_REQUISITIONS_REJECT}/$id/reject", headers, body);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        _requisitions.removeWhere((item) => item.id == id);
        notifyListeners();
      } else {
        throw responseData['message'] ?? 'Failed to reject requisition';
      }
    } catch (e) {
      debugPrint("Error rejecting requisition: $e");
      rethrow;
    }
  }
}
