import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/greeting_section.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../widgets/main_card.dart';
import '../widgets/premium_app_bar.dart';
import '../widgets/quote_card.dart';
import 'benefits_timeline_screen.dart';

class HomeScreenBody extends ConsumerStatefulWidget {
  const HomeScreenBody({super.key});

  @override
  ConsumerState<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends ConsumerState<HomeScreenBody> {
  late Timer _timer;
  late DateTime _startDate;
  late Duration _elapsed;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now().subtract(
      const Duration(days: 12, hours: 6, minutes: 32, seconds: 12),
    );
    _elapsed = DateTime.now().difference(_startDate);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _elapsed = DateTime.now().difference(_startDate));
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // ── Reset with confirmation ──────────────────────────────────
  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.extraLarge),
        title: const Text('Reset timer?'),
        content: const Text(
          'This will restart your recovery clock to right now. Your history will still be saved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: AppTypography.button.copyWith(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Reset',
              style: AppTypography.button.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() {
        _startDate = DateTime.now();
        _elapsed = Duration.zero;
      });
    }
  }

  // ── SOS bottom sheet ─────────────────────────────────────────
  void _showSosSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _SosSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          PremiumAppBar(
            onMenu: () {},
            onSos: _showSosSheet,
            onLogout: () => ref.read(authProvider.notifier).logout(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  const GreetingSection(),
                  const SizedBox(height: AppSpacing.xl),
                  MainCard(
                    elapsed: _elapsed,
                    currentStreak: _elapsed.inDays,
                    bestStreak: 141,
                    averageStreak: 141,
                    onResetTimer: _confirmReset,
                    onCounterTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => BenefitsTimelineScreen(
                            currentDays: _elapsed.inDays,
                          ),
                        ),
                      );
                    },
                    onJournalTap: () => context.go('/journal'),
                    onCommunityTap: () => context.go('/community'),
                    onCoursesTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Courses coming soon!'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const QuoteCard(),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── SOS Sheet ─────────────────────────────────────────────────
class _SosSheet extends StatelessWidget {
  const _SosSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.extraLarge,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24, 20, 24, 24 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: AppRadius.circular,
                ),
              ),
            ),

            // Header
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.heartPulse, color: AppColors.error, size: 22),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You\'ve got this',
                        style: AppTypography.heading3.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'A craving is temporary. You are stronger.',
                        style: AppTypography.caption.copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            _SosTile(
              icon: LucideIcons.wind,
              color: AppColors.info,
              title: 'Box Breathing',
              subtitle: 'Inhale 4s · Hold 4s · Exhale 4s · Hold 4s. Repeat 4×.',
            ),
            const SizedBox(height: AppSpacing.sm),
            _SosTile(
              icon: LucideIcons.eye,
              color: AppColors.success,
              title: '5-4-3-2-1 Grounding',
              subtitle: 'Name 5 things you see, 4 you hear, 3 you can touch, 2 you smell, 1 you taste.',
            ),
            const SizedBox(height: AppSpacing.sm),
            _SosTile(
              icon: LucideIcons.users,
              color: AppColors.primary,
              title: 'Reach out',
              subtitle: 'Call a sponsor, friend, or family member right now. You don\'t have to do this alone.',
            ),
            const SizedBox(height: AppSpacing.sm),
            _SosTile(
              icon: LucideIcons.phone,
              color: AppColors.warning,
              title: 'Crisis Helpline',
              subtitle: 'SAMHSA National Helpline: 1-800-662-4357 (free, 24/7, confidential)',
            ),

            const SizedBox(height: AppSpacing.xl),

            // Close button
            SizedBox(
              width: double.infinity,
              child: Material(
                color: AppColors.primary,
                borderRadius: AppRadius.circular,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: AppRadius.circular,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Center(
                      child: Text(
                        'I\'m okay, close',
                        style: TextStyle(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SosTile extends StatelessWidget {
  const _SosTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: AppRadius.large,
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: AppRadius.small,
            ),
            child: Icon(icon, size: 17, color: color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
