import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:test4/features/home/presentation/screens/home_screen.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_state.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../auth/presentation/screens/onboarding_screen.dart';
import '../../../community/presentation/screens/community_screen.dart';
import '../../../journals/presentation/screens/journals_screen.dart';
import '../../../relapse_history/presentation/screens/relapse_history_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../screens/home_screen_body.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ValueNotifier<int>(0);
  
  ref.listen<AuthState>(authProvider, (_, __) {
    authNotifier.value++;
  });

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',

    refreshListenable: authNotifier,

    // ✅ AUTH REDIRECT
    redirect: (context, state) {
      final authState = ref.read(authProvider);

      final isLoggedIn = authState.isLoggedIn;
      final isOnboardingDone = authState.hasCompletedOnboarding;

      final location = state.uri.path;

      final isGoingToLogin = location == '/login';
      final isGoingToOnboarding = location == '/onboarding';

      // 🔹 1. If not onboarded, MUST go to onboarding
      if (!isOnboardingDone) {
        if (!isGoingToOnboarding) return '/onboarding';
        return null; // stay on onboarding
      }

      // 🔹 2. Onboarding is done, prevent returning to onboarding
      if (isOnboardingDone && isGoingToOnboarding) {
        return isLoggedIn ? '/home' : '/login';
      }

      // 🔹 3. If not logged in, MUST go to login
      if (!isLoggedIn) {
        if (!isGoingToLogin) return '/login';
        return null; // stay on login
      }

      // 🔹 4. If logged in, prevent returning to login
      if (isLoggedIn && isGoingToLogin) {
        return '/home';
      }

      return null;
    },

  routes: [
    // 🔹 Onboarding
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // 🔹 Login
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // 🔥 MAIN SHELL (Tabs)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return NavigationShell(shell: navigationShell); // ✅ updated name
      },
      branches: [
        // 🏠 HOME TAB
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreenBody(),
            ),
          ],
        ),

        // 📓 JOURNAL TAB
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/journal',
              builder: (context, state) => const JournalScreen(),
            ),
          ],
        ),

        // 👥 COMMUNITY TAB
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/community',
              builder: (context, state) => const CommunityScreen(),
              routes: [
                // GoRoute(
                //   path: 'post/:id',
                //   builder: (context, state) {
                //     final id = state.pathParameters['id']!;
                //     return PostDetailsPage(id: id); // ✅ FIXED
                //   },
                // ),
              ],
            ),
          ],
        ),

        // 🕘 HISTORY TAB
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => const HistoryScreen(),
            ),
          ],
        ),

        // ⚙️ SETTINGS TAB
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
});