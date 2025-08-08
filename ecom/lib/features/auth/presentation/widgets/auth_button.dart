import 'package:flutter/material.dart';
import 'package:ecom/core/constants/app_colors.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AuthButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: AppColors.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // 👈 Rounded corners
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Color.fromARGB(255, 214, 215, 219),
        ),
      ),
    );
  }
}
