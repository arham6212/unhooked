import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (!authState.hasCompletedOnboarding) {
      return const OnboardingScreen();
    }

    if (!authState.isLoggedIn) {
      return const LoginScreen();
    }

    return const HomeScreen();
  }
}
