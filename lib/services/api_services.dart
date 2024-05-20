import 'dart:math';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_uff_caronas/config.dart';

class ApiService {
  ApiService();

  Future<Map<String, dynamic>> postUrlencoded(
      String endpoint, Map<String, dynamic> bodyJson) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    print(url);
    print(bodyJson);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: bodyJson,
    );

    print(json.decode(response.body));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> postApi(
      String endpoint, Map<String, dynamic> bodyJson) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    print(url);
    print(bodyJson);
    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(bodyJson),
    );

    print(json.decode(response.body));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  
}
