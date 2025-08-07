import 'dart:convert';

import 'package:ecom/core/error/exceptions.dart';
import 'package:ecom/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ecom/features/auth/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'auth_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  const baseUrl = AuthRemoteDataSourceImpl.baseUrl;

  const tName = 'Sabona';
  const tEmail = 'sabona@example.com';
  const tPassword = 'password123';
  const tToken = 'abc123';

  const tUserModel = UserModel(
    id: '1',
    name: tName,
    email: tEmail,
    token: tToken,
  );

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = AuthRemoteDataSourceImpl(mockHttpClient);
  });

  group('login', () {
    final responseJson = jsonEncode({
      'id': '1',
      'name': tName,
      'email': tEmail,
      'token': tToken,
    });

    test('should return UserModel when login is successful (200)', () async {
      // arrange
      when(mockHttpClient.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(responseJson, 200));

      // act
      final result = await dataSource.login(tEmail, tPassword);

      // assert
      expect(result, equals(tUserModel));
    });

    test('should throw ServerException when login fails', () async {
      when(mockHttpClient.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode({'message': 'Invalid credentials'}), 401));

      expect(
        () => dataSource.login(tEmail, tPassword),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('signUp', () {
    final responseJson = jsonEncode({
      'id': '1',
      'name': tName,
      'email': tEmail,
      'token': tToken,
    });

    test('should return UserModel when signUp is successful (201)', () async {
      when(mockHttpClient.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(responseJson, 201));

      final result = await dataSource.signUp(tName, tEmail, tPassword);

      expect(result, equals(tUserModel));
    });

    test('should throw ServerException when signUp fails', () async {
      when(mockHttpClient.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode({'message': 'Email already exists'}), 400));

      expect(
        () => dataSource.signUp(tName, tEmail, tPassword),
        throwsA(isA<ServerException>()),
      );
    });
  });

group('logout', () {
  test('should complete successfully when logout succeeds (200)', () async {
    // Arrange
    when(mockHttpClient.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('', 200));

    // Act & Assert
    expect(() => dataSource.logout(tToken), returnsNormally);

    // Optionally verify call
    verify(mockHttpClient.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tToken',
      },
    )).called(1);
  });

  test('should throw ServerException when logout fails', () async {
    // Arrange
    when(mockHttpClient.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('{"message":"Logout failed"}', 400));

    // Act & Assert
    expect(() => dataSource.logout(tToken), throwsA(isA<ServerException>()));
  });
});

}
