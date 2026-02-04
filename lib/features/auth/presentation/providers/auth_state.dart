class AuthState {
  final bool hasCompletedOnboarding;
  final bool isLoggedIn;
  final bool isLoading;
  final String? error;

  const AuthState({
    required this.hasCompletedOnboarding,
    required this.isLoggedIn,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? hasCompletedOnboarding,
    bool? isLoggedIn,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
