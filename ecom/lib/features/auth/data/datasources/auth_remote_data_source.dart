import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecom/core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signUp(String name, String email, String password);
  Future<void> logout(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl(this.client);

  static const baseUrl =
      'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3';

      

@override
Future<UserModel> login(String email, String password) async {
  final response = await client.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  debugPrint("📥 Server response (${response.statusCode}): ${response.body}");

  if (response.statusCode == 200 || response.statusCode == 201) {
    final decoded = jsonDecode(response.body);

    final accessToken = decoded['data']?['access_token'];
    if (accessToken == null || accessToken.isEmpty) {
      throw ServerException(message: '❌ Access token missing in response!');
    }

    // You can extend this model to include more user fields later
    return UserModel(
      email: email,
      token: accessToken, 
      id: '', 
      name: '',
    );
  } else {
    String errorMessage = '❌ Unknown error occurred!';
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic> && decoded['message'] is String) {
        errorMessage = decoded['message'];
      }
    } catch (_) {}

    throw ServerException(message: errorMessage);
  }
}



  @override
  Future<UserModel> signUp(String name, String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    print('📥 SignUp response status: ${response.statusCode}');
    print('📄 SignUp response body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      if (data == null) {
        throw ServerException(message: 'Invalid response data');
      }

      print(
        '🛠️ Data passed to UserModel.fromJson: $data',
      ); 
      return UserModel.fromJson(data);
    } else {
      throw ServerException(message: jsonDecode(response.body)['message']);
    }
  }

  @override
  Future<void> logout(String token) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Logout failed');
    }
  }
}
