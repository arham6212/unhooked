import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_state.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../auth/presentation/screens/onboarding_screen.dart';

import '../../../community/presentation/screens/community_screen.dart';
import '../../../community/presentation/screens/post_details_page.dart';
import '../../../community/domain/entities/post.dart';
import '../../../journals/presentation/screens/journals_screen.dart';
import '../../../relapse_history/presentation/screens/relapse_history_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';

import '../../../home/presentation/screens/home_screen_body.dart';
import '../../../splash/screens/splash_screen.dart';
import '../screens/home_screen.dart';


final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ValueNotifier<int>(0);

  // 🔄 Refresh router when auth changes
  ref.listen<AuthState>(authProvider, (_, __) {
    authNotifier.value++;
  });

  return GoRouter(
    navigatorKey: _rootNavigatorKey,

    // ✅ START WITH SPLASH
    initialLocation: '/splash',

    refreshListenable: authNotifier,

    // ✅ REDIRECT LOGIC
    redirect: (context, state) {
      final authState = ref.read(authProvider);

      final isLoggedIn = authState.isLoggedIn;
      final isOnboardingDone = authState.hasCompletedOnboarding;

      final location = state.uri.path;

      final isSplash = location == '/splash';
      final isGoingToLogin = location == '/login';
      final isGoingToOnboarding = location == '/onboarding';

      // 🟢 Allow splash always
      if (isSplash) return null;

      // 🔹 1. If not onboarded → force onboarding
      if (!isOnboardingDone) {
        if (!isGoingToOnboarding) return '/onboarding';
        return null;
      }

      // 🔹 2. Prevent going back to onboarding
      if (isOnboardingDone && isGoingToOnboarding) {
        return isLoggedIn ? '/home' : '/login';
      }

      // 🔹 3. If not logged in → force login
      if (!isLoggedIn) {
        if (!isGoingToLogin) return '/login';
        return null;
      }

      // 🔹 4. Prevent going back to login
      if (isLoggedIn && isGoingToLogin) {
        return '/home';
      }

      return null;
    },

    routes: [
      // 🔥 SPLASH
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

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
          return NavigationShell(shell: navigationShell);
        },
        branches: [
          // 🏠 HOME
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreenBody(),
              ),
            ],
          ),

          // 📓 JOURNAL
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/journal',
                builder: (context, state) => const JournalScreen(),
              ),
            ],
          ),

          // 👥 COMMUNITY
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/community',
                builder: (context, state) => const CommunityScreen(),
                routes: [
                  GoRoute(
                    path: 'post/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      final post = state.extra as Post?;
                      return PostDetailsPage(postId: id, post: post);
                    },
                  ),
                ],
              ),
            ],
          ),

          // 🕘 HISTORY
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),

          // ⚙️ SETTINGS
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