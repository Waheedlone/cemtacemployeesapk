import 'dart:convert';
import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:cnattendance/model/substitution.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';

class SubstitutionProvider with ChangeNotifier {
  List<Substitution> _substitutions = [];
  List<Substitution> _forApprovalSubstitutions = [];
  List<SubstitutionEmployee> _employees = [];
  bool _isLoading = false;
  Substitution? _selectedSubstitution;

  List<Substitution> get substitutions => _substitutions;
  List<Substitution> get forApprovalSubstitutions => _forApprovalSubstitutions;
  List<SubstitutionEmployee> get employees => _employees;
  bool get isLoading => _isLoading;
  Substitution? get selectedSubstitution => _selectedSubstitution;

  Future<void> fetchEmployees() async {
    try {
      final url = Constant.SUBSTITUTION_EMPLOYEES_URL;
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
          _employees = data.map((item) => SubstitutionEmployee.fromJson(item)).toList();
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching substitution employees: $e");
    }
  }

  Future<void> fetchSubstitutions({String? status, String? dateFrom, String? dateTo}) async {
    _isLoading = true;
    notifyListeners();

    try {
      String url = Constant.SUBSTITUTION_URL;
      List<String> params = [];
      if (status != null) params.add("status=$status");
      if (dateFrom != null) params.add("date_from=$dateFrom");
      if (dateTo != null) params.add("date_to=$dateTo");
      
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
        if (data is Map && data['data'] is List) {
          final List<dynamic> list = data['data'];
          _substitutions = list.map((item) => Substitution.fromJson(item)).toList();
        } else if (data is List) {
          _substitutions = data.map((item) => Substitution.fromJson(item)).toList();
        }
      }
    } catch (e) {
      debugPrint("Error fetching substitutions: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSubstitutionDetail(int id) async {
    _isLoading = true;
    _selectedSubstitution = null;
    notifyListeners();

    try {
      final url = "${Constant.SUBSTITUTION_URL}/$id";
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
          _selectedSubstitution = Substitution.fromJson(responseData['data']);
        }
      }
    } catch (e) {
      debugPrint("Error fetching substitution detail: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSubstitutionsForApproval() async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Constant.SUBSTITUTION_FOR_APPROVAL_URL;
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
        if (data is Map && data['data'] is List) {
          final List<dynamic> list = data['data'];
          _forApprovalSubstitutions = list.map((item) => Substitution.fromJson(item)).toList();
        } else if (data is List) {
          _forApprovalSubstitutions = data.map((item) => Substitution.fromJson(item)).toList();
        }
      }
    } catch (e) {
      debugPrint("Error fetching for-approval substitutions: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> createSubstitution(Map<String, dynamic> body) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Constant.SUBSTITUTION_URL;
      final token = await Preferences().getToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await Connect().postResponse(url, headers, json.encode(body));
      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchSubstitutions();
        return null; // Success
      } else {
        return responseData['message'] ?? "Failed to create substitution request";
      }
    } catch (e) {
      debugPrint("Error creating substitution: $e");
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> approveSubstitution(int id, {String? remarks}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = "${Constant.SUBSTITUTION_URL}/$id/approve";
      final token = await Preferences().getToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = remarks != null ? json.encode({"remarks": remarks}) : "{}";

      final response = await Connect().postResponse(url, headers, body);
      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        await fetchSubstitutionsForApproval();
        return null; // Success
      } else {
        return responseData['message'] ?? "Failed to approve substitution";
      }
    } catch (e) {
      debugPrint("Error approving substitution: $e");
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> rejectSubstitution(int id, String remarks) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = "${Constant.SUBSTITUTION_URL}/$id/reject";
      final token = await Preferences().getToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await Connect().postResponse(url, headers, json.encode({"remarks": remarks}));
      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        await fetchSubstitutionsForApproval();
        return null; // Success
      } else {
        return responseData['message'] ?? "Failed to reject substitution";
      }
    } catch (e) {
      debugPrint("Error rejecting substitution: $e");
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
