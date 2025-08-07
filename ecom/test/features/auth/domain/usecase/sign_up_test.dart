import 'package:dartz/dartz.dart';
import 'package:ecom/features/auth/domain/repositories/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecom/core/error/failure.dart';
import 'package:ecom/features/auth/domain/entities/user.dart';
import 'package:ecom/features/auth/domain/usecases/sign_up.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'sign_up_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late SignUp usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = SignUp(mockUserRepository);
  });

  const tName = 'Sabona';
  const tEmail = 'sabona@example.com';
  const tPassword = 'securePassword';
  final tUser = User(id: '1', name: tName, email: tEmail, token: tPassword);
  final tParams = SignUpParams(name: tName, email: tEmail, password: tPassword);

  test('should sign up and return User from repository', () async {
    // Arrange
    when(
      mockUserRepository.signUp(tName, tEmail, tPassword),
    ).thenAnswer((_) async => Right(tUser));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Right(tUser));
    verify(mockUserRepository.signUp(tName, tEmail, tPassword));
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return Failure when sign up fails', () async {
    // Arrange
    const failure = ServerFailure('Sign up failed');
    when(
      mockUserRepository.signUp(tName, tEmail, tPassword),
    ).thenAnswer((_) async => const Left(failure));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, const Left(failure));
    verify(mockUserRepository.signUp(tName, tEmail, tPassword));
    verifyNoMoreInteractions(mockUserRepository);
  });
}
