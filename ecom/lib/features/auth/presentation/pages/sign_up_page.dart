import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool agree = false;

  void _onSignUpPressed() {
    if (!agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please accept the terms & policy")),
      );
      return;
    }

    context.read<AuthBloc>().add(
      SignUpRequested(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoading) {
                // Show loading if needed
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is AuthAuthenticated) {
                Navigator.pushReplacementNamed(
                  context,
                  '/home',
                  arguments: emailController.text.trim(),
                );
              }
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.arrow_back_ios_new, size: 20),
                      Image.asset('assets/images/ecom_logo.png', height: 32), // Replace with your ECOM logo
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Title
                  const Text(
                    "Create your account",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // Fields
                  const Text("Name"),
                  const SizedBox(height: 6),
                  AuthTextField(controller: nameController, hintText: 'ex: jon smith'),

                  const SizedBox(height: 12),
                  const Text("Email"),
                  const SizedBox(height: 6),
                  AuthTextField(controller: emailController, hintText: 'ex: jon.smith@email.com'),

                  const SizedBox(height: 12),
                  const Text("Password"),
                  const SizedBox(height: 6),
                  AuthTextField(
                    controller: passwordController,
                    hintText: '*********',
                    obscureText: true,
                  ),

                  const SizedBox(height: 12),
                  const Text("Confirm password"),
                  const SizedBox(height: 6),
                  AuthTextField(
                    controller: confirmPasswordController,
                    hintText: '*********',
                    obscureText: true,
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: agree,
                        onChanged: (value) {
                          setState(() {
                            agree = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black),
                            children: [
                              const TextSpan(text: "I understood the "),
                              TextSpan(
                                text: "terms",
                                style: const TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  // Open terms
                                },
                              ),
                              const TextSpan(text: " & "),
                              TextSpan(
                                text: "policy",
                                style: const TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  // Open policy
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  AuthButton(
                    onPressed: _onSignUpPressed,
                    text: 'SIGN UP',
                  ),

                  const SizedBox(height: 24),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          const TextSpan(text: "Have an account? "),
                          TextSpan(
                            text: "SIGN IN",
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, '/signin');
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
