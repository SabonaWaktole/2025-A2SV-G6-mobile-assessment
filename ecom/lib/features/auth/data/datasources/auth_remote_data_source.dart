import 'dart:convert';
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

  static const baseUrl = 'https://g5-flutter-learning-path-be.onrender.com/api/v2';

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(message: jsonDecode(response.body)['message']);
    }
  }

  @override
  Future<UserModel> signUp(String name, String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
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
