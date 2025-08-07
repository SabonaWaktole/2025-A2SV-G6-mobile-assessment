import 'package:dartz/dartz.dart';
import 'package:ecom/core/error/failure.dart';
import 'package:ecom/core/usecases/usecase.dart';
// import where you defined the failures

import '../domain/entities/user.dart';
import '../domain/usecases/login.dart';
import '../domain/usecases/logout.dart';
import '../domain/usecases/sign_up.dart';

class AuthFacade {
  final Login loginUseCase;
  final SignUp signUpUseCase;
  final Logout logoutUseCase;

  AuthFacade({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.logoutUseCase,
  });

  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await loginUseCase(
        LoginParams(email: email, password: password),
      );
      return result;
    } catch (e) {
      return Left(
        ServerFailure('Unexpected error during login: ${e.toString()}'),
      );
    }
  }

  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final result = await signUpUseCase(
        SignUpParams(name: name, email: email, password: password),
      );
      return result;
    } catch (e) {
      return Left(
        ServerFailure('Unexpected error during sign up: ${e.toString()}'),
      );
    }
  }

  Future<Either<Failure, void>> logout() async {
    try {
      final result = await logoutUseCase(NoParams());
      return result;
    } catch (e) {
      return Left(
        ServerFailure('Unexpected error during logout: ${e.toString()}'),
      );
    }
  }

  Future<Either<Failure, User>> checkAuthStatus() async {
  try {
    final cachedUser = await _getCachedUser();

    if (cachedUser != null) {
      return Right(cachedUser);
    } else {
      return Left(ServerFailure('No user logged in'));
    }
  } catch (e) {
    return Left(ServerFailure('Failed to check auth status: ${e.toString()}'));
  }
}

// Dummy placeholder method: replace with actual cache retrieval logic
Future<User?> _getCachedUser() async {
  // For now return null (no user logged in)
  return null;
}

}
