import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use localhost for desktop/web or 10.0.2.2 for Android emulator
  static String baseUrl = 'http://localhost:5000/api';
  static String? authToken;

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      };

  static Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      print('[ApiService GET Error] $endpoint: $e');
      return null;
    }
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      print('[ApiService POST Error] $endpoint: $e');
      return null;
    }
  }

  static Future<dynamic> patch(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      print('[ApiService PATCH Error] $endpoint: $e');
      return null;
    }
  }

  static Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl$endpoint'), headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      print('[ApiService DELETE Error] $endpoint: $e');
      return null;
    }
  }

  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      print('[ApiService API Error] ${response.statusCode}: ${response.body}');
      try {
        return jsonDecode(response.body);
      } catch (_) {
        return null;
      }
    }
  }
}
