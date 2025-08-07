import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart'; // Make sure you import this

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _onLoginPressed() {
    debugPrint('🟦 SignIn button pressed');
    context.read<AuthBloc>().add(
      SignInRequested(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          debugPrint('🟧 AuthState changed: $state');
          if (state is AuthLoading) {
            debugPrint('⏳ Logging in...');
          } else if (state is AuthAuthenticated) {
            debugPrint('✅ Logged in! Navigating to /home with ${state.user.email}');
            Navigator.pushReplacementNamed(
              context,
              '/home',
              arguments: state.user.email,
            );
          } else if (state is AuthError) {
            debugPrint('❌ Error during login: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
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
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
