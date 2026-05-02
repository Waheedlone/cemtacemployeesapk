import 'dart:convert';
import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:cnattendance/model/internal_requisition.dart';
import 'package:cnattendance/model/material_item.dart';
import 'package:cnattendance/model/warehouse.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';

class InternalRequisitionProvider with ChangeNotifier {
  List<InternalRequisition> _requisitions = [];
  List<InternalRequisition> _myRequisitions = [];
  List<MaterialItem> _materials = [];
  List<Warehouse> _warehouses = [];
  bool _isLoading = false;

  List<InternalRequisition> get requisitions => _requisitions;
  List<InternalRequisition> get myRequisitions => _myRequisitions;
  List<MaterialItem> get materials => _materials;
  List<Warehouse> get warehouses => _warehouses;
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
        if (data != null) {
          if (data is Map && data['data'] is List) {
            _requisitions = (data['data'] as List)
                .map((item) => InternalRequisition.fromJson(item))
                .toList();
          } else if (data is List) {
            _requisitions =
                data.map((item) => InternalRequisition.fromJson(item)).toList();
          } else {
            _requisitions = [];
          }
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

  Future<void> fetchMyRequisitions() async {
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
          Constant.INTERNAL_REQUISITIONS_URL, headers);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final data = responseData['data'];
        if (data != null) {
          if (data is Map && data['data'] is List) {
            _myRequisitions = (data['data'] as List)
                .map((item) => InternalRequisition.fromJson(item))
                .toList();
          } else if (data is List) {
            _myRequisitions =
                data.map((item) => InternalRequisition.fromJson(item)).toList();
          } else {
            _myRequisitions = [];
          }
        } else {
          _myRequisitions = [];
        }
      } else {
        throw responseData['message'] ?? 'Failed to load my requisitions';
      }
    } catch (e) {
      debugPrint("Error fetching my requisitions: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMaterials({String? search}) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    String url = Constant.IMS_MATERIALS_URL;
    if (search != null && search.isNotEmpty) {
      url += "?search=$search";
    }

    try {
      final response = await Connect().getResponse(url, headers);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final data = responseData['data'];
        if (data != null && data['data'] is List) {
          _materials = (data['data'] as List)
              .map((item) => MaterialItem.fromJson(item))
              .toList();
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint("Error fetching materials: $e");
    }
  }

  Future<void> fetchWarehouses() async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await Connect().getResponse(Constant.IMS_WAREHOUSES_URL, headers);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final data = responseData['data'];
        debugPrint("Warehouses API Response: $data");
        if (data != null) {
          if (data is List) {
            _warehouses = data.map((item) => Warehouse.fromJson(item)).toList();
          } else if (data is Map && data['data'] is List) {
            _warehouses = (data['data'] as List)
                .map((item) => Warehouse.fromJson(item))
                .toList();
          }
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint("Error fetching warehouses: $e");
    }
  }

  Future<void> storeRequisition(Map<String, dynamic> data) async {
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
      final response = await Connect().postResponse(
          Constant.INTERNAL_REQUISITIONS_STORE_URL, headers, jsonEncode(data));

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        await fetchMyRequisitions();
      } else {
        throw responseData['message'] ?? 'Failed to submit requisition';
      }
    } catch (e) {
      debugPrint("Error storing requisition: $e");
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
      // Use the standard URL for detail if possible, or fallback to the approval detail URL
      final response = await Connect().getResponse(
          "${Constant.INTERNAL_REQUISITIONS_URL}/$id", headers);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData['data'] == null) {
          throw 'Requisition detail not found';
        }
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
          "${Constant.INTERNAL_REQUISITIONS_URL}/$id/approve", headers, jsonEncode({}));

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
          "${Constant.INTERNAL_REQUISITIONS_URL}/$id/reject", headers, jsonEncode(body));

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
