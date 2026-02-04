import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';
import 'auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState(
      hasCompletedOnboarding: false,
      isLoggedIn: false,
    );
  }

  void completeOnboarding() {
    state = state.copyWith(hasCompletedOnboarding: true);
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref.read(loginUseCaseProvider).execute(email, password);
    
    result.fold(
      (user) => state = state.copyWith(isLoggedIn: true, isLoading: false),
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
    );
  }

  Future<void> signUp(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref.read(signUpUseCaseProvider).execute(email, password);
    
    result.fold(
      (user) => state = state.copyWith(isLoggedIn: true, isLoading: false),
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
    );
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref.read(signInWithGoogleUseCaseProvider).execute();

    result.fold(
      (user) => state = state.copyWith(isLoggedIn: true, isLoading: false),
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
    );
  }

  Future<void> logout() async {
    final result = await ref.read(logoutUseCaseProvider).execute();
    result.fold(
      (_) => state = state.copyWith(isLoggedIn: false),
      (failure) => state = state.copyWith(error: failure.message),
    );
  }

  Future<void> checkAuthStatus() async {
    final result = await ref.read(checkAuthStatusUseCaseProvider).execute();
    result.fold(
      (isLoggedIn) => state = state.copyWith(isLoggedIn: isLoggedIn),
      (failure) => state = state.copyWith(error: failure.message),
    );
  }
}
