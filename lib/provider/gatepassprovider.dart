import 'dart:convert';
import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:intl/intl.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:cnattendance/model/gatepass.dart';

class GatePassProvider with ChangeNotifier {
  final List<GatePass> _gatePasses = [];
  bool _isLoading = false;
  GatePass? _selectedGatePass;
  String? _gatePassDetailsResponse;

  List<GatePass> get gatePasses => _gatePasses;
  bool get isLoading => _isLoading;
  GatePass? get selectedGatePass => _selectedGatePass;
  String? get gatePassDetailsResponse => _gatePassDetailsResponse;

  Future<void> fetchGatePasses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final uri = Uri.parse(Constant.GATE_PASSES_URL);
      final token = await Preferences().getToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      };

      final response = await Connect().getResponse(uri.toString(), headers);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> gatePassData = responseData['data']['gate_passes'];
        _gatePasses.clear();
        _gatePasses.addAll(gatePassData.map((data) => GatePass.fromJson(data)).toList());
      }
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchGatePassDetails(int id) async {
    _isLoading = true;
    _selectedGatePass = null;
    _gatePassDetailsResponse = null;
    notifyListeners();

    try {
      final uri = Uri.parse('${Constant.GATE_PASSES_URL}/$id');
      final token = await Preferences().getToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      };

      final response = await Connect().getResponse(uri.toString(), headers);
      _gatePassDetailsResponse = response.body;
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _selectedGatePass = GatePass.fromJson(responseData['data']);
      }
    } catch (e) {
      _gatePassDetailsResponse = e.toString();
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addGatePass(String reason, String time) async {
    try {
      final uri = Uri.parse(Constant.GATE_PASSES_URL);
      final token = await Preferences().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    final body = {
      'purpose': reason,
      'time_out_date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'time_out_time': time,
    };
    final response = await Connect().postResponse(uri.toString(), headers, json.encode(body));
      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchGatePasses();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
