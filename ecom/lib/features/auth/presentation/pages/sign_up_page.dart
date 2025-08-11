import 'package:ecom/core/constants/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';

// Importing GetIt service locator and Chat-related classes
import 'package:get_it/get_it.dart';
import '../../../chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import '../../../chat/presentation/bloc/chat_bloc/chat_event.dart';
import '../../../chat/presentation/pages/chat_list_page.dart';

final sl = GetIt.instance;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool agree = false;

  void _onSignUpPressed() {
    if (!agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please accept the terms & policy")),
      );
      return;
    }

    // Dispatch the sign-up event to AuthBloc
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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoading) {
                debugPrint('⏳ Signing up...');
              } else if (state is AuthError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is AuthAuthenticated) {
                // ✅ After successful sign-up, route exactly like sign-in
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider<ChatBloc>(
                      create: (_) => sl<ChatBloc>()..add(LoadChats()),
                      child: ChatListPage(currentUserId: state.user.id),
                    ),
                  ),
                );
              }
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row with back arrow and logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.arrow_back_ios_new, size: 20),
                        Image.asset('assets/images/ecom_logo.png', height: 32),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Title
                    Text(
                      "Create your account",
                      style: GoogleFonts.robotoSlab(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Name field
                    Text(
                      "Name",
                      style: GoogleFonts.ptSans(fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(height: 6),
                    AuthTextField(
                      controller: nameController,
                      hintText: 'ex: jon smith',
                    ),

                    const SizedBox(height: 12),
                    // Email field
                    Text(
                      "Email",
                      style: GoogleFonts.ptSans(fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(height: 6),
                    AuthTextField(
                      controller: emailController,
                      hintText: 'ex: jon.smith@email.com',
                    ),

                    const SizedBox(height: 12),
                    // Password field
                    Text(
                      "Password",
                      style: GoogleFonts.ptSans(fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(height: 6),
                    AuthTextField(
                      controller: passwordController,
                      hintText: '*********',
                      obscureText: true,
                    ),

                    const SizedBox(height: 12),
                    // Confirm password field
                    Text(
                      "Confirm password",
                      style: GoogleFonts.ptSans(fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(height: 6),
                    AuthTextField(
                      controller: confirmPasswordController,
                      hintText: '*********',
                      obscureText: true,
                    ),

                    const SizedBox(height: 16),
                    // Terms & policy checkbox
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
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                              ),
                              children: [
                                const TextSpan(text: "I understood the "),
                                TextSpan(
                                  text: "terms",
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // TODO: Implement terms page navigation
                                    },
                                ),
                                const TextSpan(text: " & "),
                                TextSpan(
                                  text: "policy",
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // TODO: Implement policy page navigation
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    // Sign up button
                    AuthButton(
                      onPressed: _onSignUpPressed,
                      text: 'SIGN UP',
                    ),

                    const SizedBox(height: 150),
                    // Link to sign in page
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: AppColors.textPrimary),
                          children: [
                            TextSpan(
                              text: "Have an account? ",
                              style: GoogleFonts.ptSans(
                                fontWeight: FontWeight.w100,
                                fontSize: 20,
                              ),
                            ),
                            TextSpan(
                              text: "SIGN IN",
                              style: GoogleFonts.ptSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.primary,
                              ),
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
