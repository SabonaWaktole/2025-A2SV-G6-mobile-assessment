import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:ecom/features/auth/domain/usecases/login.dart';
import 'package:ecom/features/auth/domain/entities/user.dart';
// import 'package:ecom/features/auth/domain/repositories/user_repository.dart';
import 'package:ecom/core/error/failure.dart';

import '../../../../mocks/mocks.mocks.dart';

void main() {
  late Login usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = Login(mockUserRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tUser = User(
    id: '1',
    name: 'Test User',
    email: tEmail,
    token: 'fake_token',
  );

  final tParams = LoginParams(email: tEmail, password: tPassword);

  test('should return User when login is successful', () async {
    // Arrange
    when(mockUserRepository.login(tEmail, tPassword))
        .thenAnswer((_) async => Right(tUser));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Right(tUser));
    verify(mockUserRepository.login(tEmail, tPassword));
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return Failure when login fails', () async {
    // Arrange
    when(mockUserRepository.login(tEmail, tPassword))
        .thenAnswer((_) async => Left(ServerFailure("failed to login")));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Left(ServerFailure("failed to login")));
    verify(mockUserRepository.login(tEmail, tPassword));
    verifyNoMoreInteractions(mockUserRepository);
  });
}
