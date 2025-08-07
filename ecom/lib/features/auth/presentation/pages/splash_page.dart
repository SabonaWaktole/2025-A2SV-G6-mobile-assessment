import 'package:ecom/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../../../../core/constants/app_colors.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      // ignore: use_build_context_synchronously
      context.read<AuthBloc>().add(AppStarted());
    });

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: const Center(
        child: Text(
          'Ecommerce App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
