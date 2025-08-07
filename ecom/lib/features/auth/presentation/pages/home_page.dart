import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class HomePage extends StatelessWidget {
  final String userEmail;
  const HomePage({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          )
        ],
      ),
      body: Center(
        child: Text('Welcome, $userEmail', style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
