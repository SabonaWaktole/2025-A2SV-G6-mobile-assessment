import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:ecom/core/error/failure.dart';
import 'package:ecom/features/auth/domain/entities/user.dart';
import 'package:ecom/features/auth/domain/repositories/user_repository.dart';

import 'user_repository_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
  });

  const email = 'tola@example.com';
  const password = 'securePassword';
  const name = 'Sabona';
  const sampleToken = 'sampleToken';
  final user = User(id: '1', name: name, email: email, token: sampleToken);
  const failure = ServerFailure('Error occurred');

  group('login', () {
    test('should return User on success', () async {
      when(mockUserRepository.login(email, password))
          .thenAnswer((_) async => Right(user));

      final result = await mockUserRepository.login(email, password);

      expect(result, Right(user));
      verify(mockUserRepository.login(email, password)).called(1);
    });

    test('should return Failure on error', () async {
      when(mockUserRepository.login(email, password))
          .thenAnswer((_) async => const Left(failure));

      final result = await mockUserRepository.login(email, password);

      expect(result, const Left(failure));
      verify(mockUserRepository.login(email, password)).called(1);
    });
  });

  group('signUp', () {
    test('should return User on success', () async {
      when(mockUserRepository.signUp(name, email, password))
          .thenAnswer((_) async => Right(user));

      final result = await mockUserRepository.signUp(name, email, password);

      expect(result, Right(user));
      verify(mockUserRepository.signUp(name, email, password)).called(1);
    });

    test('should return Failure on error', () async {
      when(mockUserRepository.signUp(name, email, password))
          .thenAnswer((_) async => const Left(failure));

      final result = await mockUserRepository.signUp(name, email, password);

      expect(result, const Left(failure));
      verify(mockUserRepository.signUp(name, email, password)).called(1);
    });
  });

  group('logout', () {
    test('should return void on success', () async {
      when(mockUserRepository.logout())
          .thenAnswer((_) async => const Right(null));

      final result = await mockUserRepository.logout();

      expect(result, const Right(null));
      verify(mockUserRepository.logout()).called(1);
    });

    test('should return Failure on error', () async {
      when(mockUserRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      final result = await mockUserRepository.logout();

      expect(result, const Left(failure));
      verify(mockUserRepository.logout()).called(1);
    });
  });
}
