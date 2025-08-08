import 'package:dartz/dartz.dart';
import 'package:ecom/core/error/exceptions.dart';
import 'package:ecom/core/error/failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
// import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      await localDataSource.cacheToken(user.token);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signUp(String name, String email, String password) async {
    try {
      final user = await remoteDataSource.signUp(name, email, password);
      await localDataSource.cacheToken(user.token);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
Future<Either<Failure, void>> logout() async {
  try {
    await localDataSource.clearToken();
    return const Right(null);
  } catch (e) {
    return Left(ServerFailure("Logout failed: $e"));
  }
}

}
