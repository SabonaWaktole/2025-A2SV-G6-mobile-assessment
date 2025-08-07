import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _onLoginPressed() {
    context.read<AuthBloc>().add(
      SignInRequested(
        email: emailController.text,
        password: passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome Back!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            AuthTextField(controller: emailController, hintText: 'Email'),
            const SizedBox(height: 20),
            AuthTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 40),
            AuthButton(text: 'Sign In', onPressed: _onLoginPressed),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signup');
              },
              child: const Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
