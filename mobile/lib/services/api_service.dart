import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://leaklens-api-a7pi.onrender.com';

  static String? token;
  static String? currentEmail;

  static Future<Map<String, dynamic>> signup(
    String email,
    String password,
  ) async {
    return _authenticate('/api/auth/signup', email, password);
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    return _authenticate('/api/auth/login', email, password);
  }

  static Future<Map<String, dynamic>> _authenticate(
    String path,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.trim(),
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(data['detail'] ?? 'Authentication failed.');
    }

    token = data['token']?.toString();
    currentEmail = email.trim();

    return Map<String, dynamic>.from(data);
  }

  static Future<Map<String, dynamic>> diagnostic(
    Map<String, dynamic> payload,
  ) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (token != null && token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/diagnostic'),
      headers: headers,
      body: jsonEncode(payload),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['detail'] ?? 'Diagnostic request failed.');
    }

    return Map<String, dynamic>.from(data);
  }

  static void clearSession() {
    token = null;
    currentEmail = null;
  }
}
