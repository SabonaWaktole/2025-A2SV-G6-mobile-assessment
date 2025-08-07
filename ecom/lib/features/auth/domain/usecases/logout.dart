import 'package:dartz/dartz.dart';
import 'package:ecom/core/error/failure.dart';
import 'package:ecom/core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class Logout implements UseCase<void, NoParams> {
  final UserRepository repository;

  Logout(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}
