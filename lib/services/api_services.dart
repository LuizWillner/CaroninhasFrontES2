
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_uff_caronas/config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  ApiService();

  final _storage = FlutterSecureStorage();


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
    final token = await _storage.read(key: "token_bearer") ?? '';
    print(url);
    print(bodyJson);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(bodyJson),
    );

    print(json.decode(response.body));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getApi(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final token = await _storage.read(key: "token_bearer") ?? '';

    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': token
    });
    final decodedResponse = json.decode(response.body);

    print(decodedResponse);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decodedResponse is Map<String, dynamic>) {
      return decodedResponse;
    } else if (decodedResponse is List<dynamic>) {
      return {'data': decodedResponse};
    }
    }
    throw Exception('Failed to load data');
  }

  Future<Map<String, dynamic>> patchApi(
      String endpoint, Map<String, dynamic> bodyJson) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final token = await _storage.read(key: "token_bearer") ?? '';
    print(url);
    print(bodyJson);
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(bodyJson),
    );

    print(json.decode(response.body));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to patch data');
    }
  }

  Future<void> deleteApi(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final token = await _storage.read(key: "token_bearer") ?? '';
    print(url);
    final response = await http.delete(url, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': token
    });

    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('Delete successful');
    } else {
      throw Exception('Failed to delete data');
    }
  }
}
