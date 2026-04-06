import 'dart:convert';
import 'dart:io';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:cnattendance/data/source/network/model/leaveissue/IssueLeaveResponse.dart';
import 'package:cnattendance/data/source/network/model/tadadetail/tadadetailresponse.dart';
import 'package:cnattendance/data/source/network/model/tadalist/tadalistresponse.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TadaRepository {
  Future<TadaListResponse> getTadaList() async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response =
          await Connect().getResponse(Constant.TADA_LIST_URL, headers);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final tadaResponse = TadaListResponse.fromJson(responseData);

        return tadaResponse;
      } else {
        var errorMessage = responseData['message'];
        print(errorMessage);
        throw errorMessage;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<TadaDetailResponse> getTadaDetail(String tadaId) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect()
          .getResponse(Constant.TADA_DETAIL_URL + "/${tadaId}", headers);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final tadaResponse = TadaDetailResponse.fromJson(responseData);

        return tadaResponse;
      } else {
        var errorMessage = responseData['message'];
        print(errorMessage);
        throw errorMessage;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<IssueLeaveResponse> createTada(String title, String description,
      String expenses, List<PlatformFile> fileList) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    Map<String, String> fields = {
      "title": title,
      "description": description,
      "total_expense": expenses,
    };

    List<http.MultipartFile> files = [];
    for (var filed in fileList) {
      final file = File(filed.path!);
      final multipartFile = await http.MultipartFile.fromPath('attachments[]', file.path, filename: filed.name);
      files.add(multipartFile);
    }

    try {
      final response = await Connect().postMultipartResponse(Constant.TADA_STORE_URL, headers, fields, files);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return IssueLeaveResponse.fromJson(responseData);
      } else {
        throw responseData['message'] ?? "Failed to create TADA";
      }
    } catch (e) {
      rethrow;
    }
  }
}
