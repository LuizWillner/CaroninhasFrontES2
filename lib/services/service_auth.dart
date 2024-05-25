import 'package:app_uff_caronas/config.dart';
import 'package:app_uff_caronas/services/api_services.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final ApiService apiService;

  AuthService({required this.apiService});

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await apiService
        .postUrlencoded('token', {'username': username, 'password': password});
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
      String phone,
      String password) async {
    final response = await apiService.postApi('users/create', {
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "cpf": cpf,
      "birthdate": "2000-05-20T04:48:56.242Z",
      "phone": phone,
      "iduff": iduff,
      "password": password
    });
    return response;
  }

  Future<Map<String, dynamic>> getUser() async {
    final response = await apiService.getApi("users/me");
    return response;
  }
}
