import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_state.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../onboarding/presentation/providers/onboarding_controller.dart';
import '../../../onboarding/presentation/screens/onboarding_flow_screen.dart';

import '../../../community/presentation/screens/community_screen.dart';
import '../../../community/presentation/screens/post_details_page.dart';
import '../../../community/presentation/screens/create_post_screen.dart';
import '../../../community/domain/entities/post.dart';
import '../../../journals/presentation/screens/journal_editor_screen.dart';
import '../../../journals/presentation/screens/journals_screen.dart';
import '../../../meditation/presentation/screens/meditation_screen.dart';
import '../../../meditation/presentation/screens/meditation_session_screen.dart';
import '../../../meditation/presentation/screens/session_complete_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';

import '../../../home/presentation/screens/home_screen_body.dart';
import '../../../splash/screens/splash_screen.dart';
import '../screens/home_screen.dart';


final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ValueNotifier<int>(0);

  // 🔄 Refresh router when auth changes
  ref.listen<AuthState>(authProvider, (_, state) {
    authNotifier.value++;
  });

  // 🔄 Refresh router when onboarding completes
  ref.listen<OnboardingState>(onboardingProvider, (prev, next) {
    if (prev?.completed != next.completed) authNotifier.value++;
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
      final isOnboardingDone = ref.read(onboardingProvider).completed;

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
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 500),
          child: const OnboardingFlowScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
              child: child,
            );
          },
        ),
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
                routes: [
                  GoRoute(
                    path: 'write',
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) {
                      final args = state.extra as JournalEditorArgs?;
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        fullscreenDialog: true,
                        transitionDuration: const Duration(milliseconds: 380),
                        reverseTransitionDuration:
                            const Duration(milliseconds: 300),
                        child: JournalEditorScreen(args: args),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          final curved = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                            reverseCurve: Curves.easeInCubic,
                          );
                          return FadeTransition(
                            opacity: curved,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.04),
                                end: Offset.zero,
                              ).animate(curved),
                              child: child,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // 🧘 MEDITATE
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/meditate',
                builder: (context, state) => const MeditationScreen(),
                routes: [
                  GoRoute(
                    path: 'session/:id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return MeditationSessionScreen(meditationId: id);
                    },
                  ),
                  GoRoute(
                    path: 'complete',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>;
                      return SessionCompleteScreen(
                        title: extra['title'] as String,
                        durationSeconds: extra['duration'] as int,
                        color: extra['color'] as Color,
                      );
                    },
                  ),
                ],
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
                    path: 'create',
                    builder: (context, state) => const CreatePostScreen(),
                  ),
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

          // 👤 PROFILE
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