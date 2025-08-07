// import 'package:ecom/features/auth/presentation/pages/sign_up_page.dart';
import 'package:ecom/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
// import 'features/auth/presentation/pages/splash_page.dart';
import 'features/auth/presentation/pages/sign_in_page.dart';
import 'features/auth/presentation/pages/home_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init(); // Initialize dependencies
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => di.sl<AuthBloc>(),
      child: MaterialApp(
        title: 'Ecommerce App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => const SignInPage(),
          '/signin': (context) => const SignInPage(),
          '/home': (context) {
            final userEmail =
                ModalRoute.of(context)!.settings.arguments as String;
            return HomePage(userEmail: userEmail);
          },
        },
      ),
    );
  }
}
