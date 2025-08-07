import 'package:dartz/dartz.dart';
import 'package:ecom/core/error/failure.dart';
import 'package:ecom/core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class Login implements UseCase<User, LoginParams> {
  final UserRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
