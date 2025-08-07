import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecom/features/auth/facade/auth_facade.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthFacade authFacade;

  AuthBloc({required this.authFacade}) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignInRequested>(_onSignIn);
    on<SignUpRequested>(_onSignUp);
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authFacade.checkAuthStatus();

    result.fold(
      (failure) => emit(AuthLoggedOut()),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onSignIn(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authFacade.login(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) {
        final message = failure.message.isNotEmpty
            ? failure.message
            : "No error message!";
        debugPrint("🟥 Login failed: $message");
        emit(AuthError(message));
      },
      (user) {
        debugPrint("✅ Login success: ${user.email}");
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onSignUp(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authFacade.signUp(
      name: event.name,
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authFacade.logout();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthLoggedOut()),
    );
  }
}
