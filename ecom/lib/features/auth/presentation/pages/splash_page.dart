import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/constants/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      // ignore: use_build_context_synchronously
      context.read<AuthBloc>().add(AppStarted());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(
            context,
            '/home',
            arguments: state.user.email,
          );
        } else {
          Navigator.pushReplacementNamed(context, '/signin');
        }
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/image.png', fit: BoxFit.cover),
            // Color overlay with opacity
            Container(
              // ignore: deprecated_member_use
              color: AppColors.button.withOpacity(0.8), // Adjust color & opacity here
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      30,
                    ), // You can adjust the radius
                    child: Image.asset(
                      'assets/images/ecom_logo.png',
                      width: 150,
                      height: 80,

                      fit: BoxFit.contain,

                    ),
                  ),
                  const Text(
                    'Ecommerce App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
