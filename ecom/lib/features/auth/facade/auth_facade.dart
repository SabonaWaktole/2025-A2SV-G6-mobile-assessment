import 'package:dartz/dartz.dart';
import 'package:ecom/core/error/failure.dart';
import 'package:ecom/core/usecases/usecase.dart';
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
  }) {
    return loginUseCase(LoginParams(email: email, password: password));
  }

  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return signUpUseCase(SignUpParams(
      name: name,
      email: email,
      password: password,
    ));
  }

  Future<Either<Failure, void>> logout() {
    return logoutUseCase(NoParams());
  }
}
