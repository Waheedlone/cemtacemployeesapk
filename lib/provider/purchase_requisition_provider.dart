import 'dart:convert';
import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:cnattendance/model/purchase_requisition.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';

class PurchaseRequisitionProvider with ChangeNotifier {
  List<PurchaseRequisition> _requisitions = [];
  bool _isLoading = false;

  List<PurchaseRequisition> get requisitions => _requisitions;
  bool get isLoading => _isLoading;

  Future<void> fetchForApproval() async {
    debugPrint("Fetching PRs for approval...");
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
          "${Constant.API_URL}/purchase-requisitions/for-approval", headers);

      debugPrint("PR Approval API Status: ${response.statusCode}");
      debugPrint("PR Approval API Body: ${response.body}");

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final data = responseData['data'];
        if (data != null) {
          if (data is Map && data['data'] is List) {
            final list = data['data'] as List;
            debugPrint("Found ${list.length} PRs in response");
            _requisitions = list
                .map((item) => PurchaseRequisition.fromJson(item))
                .toList();
          } else if (data is List) {
            debugPrint("Found ${data.length} PRs in response (direct list)");
            _requisitions =
                data.map((item) => PurchaseRequisition.fromJson(item)).toList();
          } else {
            debugPrint("Data field is neither Map nor List: ${data.runtimeType}");
            _requisitions = [];
          }
        } else {
          debugPrint("Data field is null in response");
          _requisitions = [];
        }
      } else {
        throw responseData['message'] ?? 'Failed to load requisitions';
      }
    } catch (e) {
      debugPrint("Error fetching PR requisitions: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<PurchaseRequisition> fetchDetail(int id) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await Connect().getResponse(
          "${Constant.API_URL}/purchase-requisitions/$id", headers);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return PurchaseRequisition.fromJson(responseData['data']);
      } else {
        throw responseData['message'] ?? 'Failed to load requisition detail';
      }
    } catch (e) {
      debugPrint("Error fetching PR detail: $e");
      rethrow;
    }
  }

  Future<void> takeAction(int id, String action, String remarks) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    Map<String, dynamic> body = {
      'action': action,
      'remarks': remarks,
    };

    try {
      final response = await Connect().postResponse(
          "${Constant.API_URL}/purchase-requisitions/$id/action", headers, jsonEncode(body));

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        _requisitions.removeWhere((item) => item.id == id);
        notifyListeners();
      } else {
        throw responseData['message'] ?? 'Failed to process action';
      }
    } catch (e) {
      debugPrint("Error processing PR action: $e");
      rethrow;
    }
  }
}
