import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../providers/auth_provider.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/components/app_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': LucideIcons.moon,
      'title': 'Welcome back to\ncalm recovery',
      'subtitle': 'A gentle, private space to track progress, build routines, and keep your momentum.',
    },
    {
      'icon': LucideIcons.trendingUp,
      'title': 'Track your streaks',
      'subtitle': 'See momentum build day by day with visual progress tracking.',
    },
    {
      'icon': LucideIcons.bell,
      'title': 'Smart reminders',
      'subtitle': 'Support without pressure. Receive gentle nudges when you need them most.',
    },
    {
      'icon': LucideIcons.lock,
      'title': 'Private by design',
      'subtitle': 'Your data stays yours. Fully encrypted and secure.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primaryDark, AppColors.primaryLight],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: AppRadius.extraLarge,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.25),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              )
                            ],
                          ),
                          child: Icon(
                            page['icon'] as IconData,
                            color: AppColors.onPrimary,
                            size: 36,
                          ),
                        ).animate(key: ValueKey('icon-$index')).scale(duration: 500.ms, curve: Curves.easeOutBack).fadeIn(),
                        const SizedBox(height: AppSpacing.xxl),
                        Text(
                          page['title'] as String,
                          style: AppTypography.display.copyWith(fontSize: 40, height: 1.1),
                        ).animate(key: ValueKey('title-$index')).slideY(begin: 0.2, end: 0, duration: 500.ms, curve: Curves.easeOutCubic).fadeIn(delay: 100.ms),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          page['subtitle'] as String,
                          style: AppTypography.bodyLarge.copyWith(color: AppColors.textMuted),
                        ).animate(key: ValueKey('sub-$index')).slideY(begin: 0.2, end: 0, duration: 500.ms, curve: Curves.easeOutCubic).fadeIn(delay: 200.ms),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? AppColors.primary : AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  AppButton(
                    text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Continue',
                    fullWidth: true,
                    variant: AppButtonVariant.gradient,
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                      } else {
                        ref.read(authProvider.notifier).completeOnboarding();
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    text: 'Skip',
                    variant: AppButtonVariant.text,
                    fullWidth: true,
                    onPressed: () {
                      ref.read(authProvider.notifier).completeOnboarding();
                    },
                  ),
                ],
              ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
            ),
          ],
        ),
      ),
    );
  }
}
