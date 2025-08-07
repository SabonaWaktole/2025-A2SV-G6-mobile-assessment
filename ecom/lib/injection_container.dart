import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:ecom/features/auth/data/repositories/user_repository_impl.dart';
import 'package:ecom/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ecom/features/auth/domain/repositories/user_repository.dart';
import 'package:ecom/features/auth/domain/usecases/login.dart';
import 'package:ecom/features/auth/domain/usecases/logout.dart';
import 'package:ecom/features/auth/domain/usecases/sign_up.dart';
import 'package:ecom/features/auth/facade/auth_facade.dart';
import 'package:ecom/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => AuthBloc(authFacade: sl()));

  sl.registerLazySingleton(
    () => AuthFacade(
      loginUseCase: sl(),
      signUpUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => Logout(sl()));

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton(() => http.Client());
}
