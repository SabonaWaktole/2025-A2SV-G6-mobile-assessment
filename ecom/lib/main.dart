import 'package:ecom/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:ecom/features/chat/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecom/injection_container.dart' as di;

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/sign_in_page.dart';
import 'features/auth/presentation/pages/sign_up_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/auth/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>(),
        ),
        BlocProvider<ChatBloc>(
          create: (_) => di.sl<ChatBloc>(),  // Inject ChatBloc
        ),
        BlocProvider<UserBloc>(
          create: (_) => di.sl<UserBloc>(),  // Inject UserBloc
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ecommerce App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/splash', 
        routes: {
          '/': (context) => const SignInPage(),
          '/signin': (context) => const SignInPage(),
          '/signup': (context) => const SignUpPage(),
          '/splash': (context) => const SplashPage(),
          '/home': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            if (args is String) {
              return HomePage(userEmail: args);
            } else {
              debugPrint("⚠️ No email provided. Redirecting to SignInPage.");
              return const SignInPage();
            }
          },
        },
      ),
    );
  }
}
