import 'package:app_uff_caronas/config.dart';
import 'package:app_uff_caronas/services/api_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final ApiService apiService;

  AuthService({required this.apiService});

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await apiService.postUrlencoded('token', {
      'username': username,
      'password': password
    });
    return response;
  }
//TODO data
  Future<Map<String, dynamic>> createUser(
      String email,
      String firstName,
      String lastName,
      String cpf,
      String birthdate,
      String iduff,
      String password) async {
    final response = await apiService.postApi('users/create',{
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "cpf": cpf,
      "birthdate": "2000-05-20T04:48:56.242Z",
      "iduff": iduff,
      "password": password
    });
    return response;
  }


void createUserTest() async {
  final url = Uri.parse('http://104.41.155.191:8000/users/create');

  final Map<String, dynamic> userData = {
    "email": "ro@ro.com",
    "first_name": "John",
    "last_name": "Doe",
    "cpf": "12345678900",
    "birthdate": "2000-05-20T06:07:40.734Z",
    "iduff": "ABCD1234",
    "password": "123456"
  };

  final headers = {'Content-Type': 'application/json'};

  final response = await http.post(
    url,
    headers: headers,
    body: json.encode(userData),
  );

  if (response.statusCode == 201) {
    print('User created successfully');
  } else {
    print('Failed to create user. Status code: ${response.statusCode}');
    print('Response Body: ${response.body}');
  }
}
}
