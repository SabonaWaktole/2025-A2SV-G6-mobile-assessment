import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/repositories/user_repository_impl.dart';
import 'features/auth/domain/repositories/user_repository.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/domain/usecases/sign_up.dart';
import 'features/auth/facade/auth_facade.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // 🔹 Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // 🔹 HTTP Client
  sl.registerLazySingleton(() => http.Client());

  // 🔹 Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()), // http.Client
  );

  sl.registerLazySingleton(() => const FlutterSecureStorage()); 

sl.registerLazySingleton<AuthLocalDataSource>(
  () => AuthLocalDataSourceImpl(sl()), 
);


  // 🔹 Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // 🔹 Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => Logout(sl()));

  // 🔹 Facade
  sl.registerLazySingleton(
    () => AuthFacade(
      loginUseCase: sl(),
      signUpUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  // 🔹 Bloc
  sl.registerFactory(() => AuthBloc(authFacade: sl()));
}
