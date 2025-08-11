import 'dart:async';
import 'package:ecom/features/chat/domain/usecases/get_messages.dart';
import 'package:ecom/features/chat/domain/usecases/get_users.dart';
import 'package:ecom/features/chat/domain/usecases/initiate_chat.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Auth imports
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/repositories/user_repository_impl.dart';
import 'features/auth/domain/repositories/user_repository.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/domain/usecases/sign_up.dart';
import 'features/auth/facade/auth_facade.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Chat imports
import 'features/chat/data/datasources/chat_remote_data_source.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/get_chats.dart';
import 'features/chat/domain/usecases/send_message.dart';
import 'features/chat/domain/usecases/receive_message.dart';
import 'features/chat/facade/chat_facade.dart';
import 'features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'features/chat/presentation/bloc/user_bloc/user_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ===== AUTH FEATURE =====

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() => http.Client());

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()), // http.Client
  );

  sl.registerLazySingleton(() => const FlutterSecureStorage());

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => Logout(sl()));

  sl.registerLazySingleton(
    () => AuthFacade(
      loginUseCase: sl(),
      signUpUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  sl.registerFactory(() => AuthBloc(authFacade: sl()));

// ===== CHAT FEATURE =====

// Data sources
sl.registerLazySingleton<ChatRemoteDataSource>(
  () => ChatRemoteDataSourceImpl(
    authLocalDataSource: sl(),
    baseUrl: 'https://g5-flutter-learning-path-be-tvum.onrender.com',
  ),
);

// If you have a ChatLocalDataSource implementation, register here, else omit
// sl.registerLazySingleton<ChatLocalDataSource>(() => ChatLocalDataSourceImpl());

// Repository — Note: only remoteDataSource param as per your constructor
sl.registerLazySingleton<ChatRepository>(
  () => ChatRepositoryImpl(
    remoteDataSource: sl(),
  ),
);

// Use cases
sl.registerLazySingleton(() => GetChats(sl()));
sl.registerLazySingleton(() => SendMessage(sl()));
sl.registerLazySingleton(() => ReceiveMessage(sl()));
sl.registerLazySingleton(() => GetUsers(sl()));
sl.registerLazySingleton(() => InitiateChat(sl()));
sl.registerLazySingleton(() => GetMessages(sl()));

// Facade
sl.registerLazySingleton(() => ChatFacade(
      getChats: sl(),
      sendMessage: sl(),
      receiveMessage: sl(),
      getUsers: sl(),
      initiateChat: sl(),
      getMessages: sl(),
    ));

// Bloc
sl.registerFactory(() => ChatBloc(
      getChats: sl(),
      sendMessage: sl(),
      receiveMessage: sl(), 
      initiateChat: sl(),
      getMessages: sl(),
      
    ));
sl.registerCachedFactory(() => UserBloc(
  getUsers: sl(),
  ));
}
