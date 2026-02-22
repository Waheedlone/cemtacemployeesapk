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
      Log.d("Connect", "GET Response Body: ${response.body}");
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
      Log.d("Connect", "POST Response Body: ${response.body}");
      return response;
    } catch (e) {
      Log.e("Connect", "POST Error: $e");
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
      Log.d("Connect", "DELETE Response Body: ${response.body}");
      return response;
    } catch (e) {
      Log.e("Connect", "DELETE Error: $e");
      rethrow;
    }
  }
}
