import 'package:dartz/dartz.dart';
import 'package:ecom/core/error/failure.dart';
import 'package:ecom/core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class SignUp implements UseCase<User, SignUpParams> {
  final UserRepository repository;

  SignUp(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await repository.signUp(params.name, params.email, params.password);
  }
}

class SignUpParams {
  final String name;
  final String email;
  final String password;

  SignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
