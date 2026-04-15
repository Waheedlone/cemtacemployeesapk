import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cnattendance/utils/log.dart';

class Connect {
  Future<http.Response> getResponse(String url, Map<String, String> headers) async {
    Log.d("Connect", "GET Request: $url");
    Log.d("Connect", "Headers: $headers");
    var uri = Uri.parse(url);
    try {
      final response = await http.get(uri, headers: headers);
      Log.d("Connect", "GET Response Code: ${response.statusCode}");
      _validateResponse(response);
      return response;
    } catch (e) {
      Log.e("Connect", "GET Error: $e");
      rethrow;
    }
  }

  Future<http.Response> postResponse(
      String url, Map<String, String> headers, Object? body) async {
    Log.d("Connect", "POST Request: $url");
    Log.d("Connect", "Headers: $headers");
    Log.d("Connect", "Body: $body");
    var uri = Uri.parse(url);
    try {
      final response = await http.post(uri, headers: headers, body: body);
      Log.d("Connect", "POST Response Code: ${response.statusCode}");
      _validateResponse(response);
      return response;
    } catch (e) {
      Log.e("Connect", "POST Error: $e");
      rethrow;
    }
  }

  void _validateResponse(http.Response response) {
    final contentType = response.headers['content-type'] ?? '';
    final body = response.body.trim();

    if (response.statusCode == 403) {
      throw "This action is unauthorized (403). Please contact your administrator.";
    }

    if (response.statusCode == 404) {
      if (body.startsWith('<!DOCTYPE') || body.startsWith('<html')) {
        throw "Resource not found (404). The server returned an error page.";
      }
    }

    if (body.startsWith('<!DOCTYPE') || body.startsWith('<html')) {
      Log.e("Connect", "Unexpected HTML response received for JSON request");
      throw "Server Error: Received HTML instead of JSON. Please try again later.";
    }

    // Attempt a dry-run decode if we're expecting JSON
    if (contentType.contains('application/json')) {
      try {
        json.decode(body);
      } catch (e) {
        Log.e("Connect", "Failed to decode JSON: $e");
        throw "Server Error: Invalid data format received.";
      }
    }
  }

  Future<http.Response> postMultipartResponse(
      String url, Map<String, String> headers, Map<String, String> fields, List<http.MultipartFile> files) async {
    Log.d("Connect", "Multipart POST Request: $url");
    Log.d("Connect", "Headers: $headers");
    Log.d("Connect", "Fields: $fields");
    Log.d("Connect", "Files: ${files.map((f) => f.field).toList()}");
    var uri = Uri.parse(url);
    try {
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(headers);
      request.fields.addAll(fields);
      request.files.addAll(files);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      Log.d("Connect", "Multipart POST Response Code: ${response.statusCode}");
      _validateResponse(response);
      return response;
    } catch (e) {
      Log.e("Connect", "Multipart POST Error: $e");
      rethrow;
    }
  }

  Future<http.Response> deleteResponse(String url, Map<String, String> headers) async {
    Log.d("Connect", "DELETE Request: $url");
    Log.d("Connect", "Headers: $headers");
    var uri = Uri.parse(url);
    try {
      final response = await http.delete(uri, headers: headers);
      Log.d("Connect", "DELETE Response Code: ${response.statusCode}");
      _validateResponse(response);
      return response;
    } catch (e) {
      Log.e("Connect", "DELETE Error: $e");
      rethrow;
    }
  }
}

