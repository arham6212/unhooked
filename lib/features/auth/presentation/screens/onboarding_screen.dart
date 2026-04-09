import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/components/app_button.dart';
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: AppRadius.large,
                ),
                child: const Icon(
                  Icons.shield_moon_outlined,
                  color: AppColors.onPrimary,
                  size: 28,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text(
                'Welcome back to calm recovery',
                style: AppTypography.heading1,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'A gentle, private space to track progress, build routines, and keep your momentum.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textMutedAlt),
              ),
              const SizedBox(height: AppSpacing.xl),
              _FeatureTile(
                icon: Icons.auto_graph_outlined,
                title: 'Track your streaks',
                subtitle: 'See momentum build day by day.',
              ),
              const SizedBox(height: AppSpacing.lg),
              const _FeatureTile(
                icon: Icons.notifications_none_outlined,
                title: 'Smart reminders',
                subtitle: 'Support without pressure.',
              ),
              const SizedBox(height: AppSpacing.lg),
              const _FeatureTile(
                icon: Icons.lock_outline,
                title: 'Private by design',
                subtitle: 'Your data stays yours.',
              ),
              const Spacer(),
              AppButton(
                text: 'Get Started',
                fullWidth: true,
                onPressed: () {
                  ref.read(authProvider.notifier).completeOnboarding();
                },
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: AppButton(
                  text: 'Already have an account? Sign in',
                  variant: AppButtonVariant.text,
                  onPressed: () {
                    ref.read(authProvider.notifier).completeOnboarding();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: AppRadius.medium,
          ),
          child: Icon(icon, color: AppColors.primaryDark),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.heading3),
              const SizedBox(height: AppSpacing.xs),
              Text(subtitle, style: AppTypography.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
