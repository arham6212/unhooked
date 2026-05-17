import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/greeting_section.dart';
import '../widgets/main_card.dart';
import '../widgets/mini_stat_card.dart';
import '../widgets/recovery_timer_card.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/todays_focus_card.dart';
import '../widgets/current_benefits_row.dart';
import '../widgets/premium_app_bar.dart';
import '../widgets/quote_card.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
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
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsed = DateTime.now().difference(_startDate));
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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
            child: Text('Cancel',
                style: AppTypography.button.copyWith(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Reset',
                style: AppTypography.button.copyWith(color: AppColors.error)),
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

  void _showSosSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _SosSheet(),
    );
  }

  void _openBenefitsTimeline() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BenefitsTimelineScreen(currentDays: _elapsed.inDays),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final streak = _elapsed.inDays;

    return Container(
      color: AppColors.background,
      child: SafeArea(
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
                  const SizedBox(height: AppSpacing.sm),

                  // Greeting — full width
                  const GreetingSection()
                      .animate()
                      .fadeIn(duration: 350.ms)
                      .slideY(begin: 0.04, end: 0, duration: 350.ms, curve: Curves.easeOutCubic),

                  const SizedBox(height: AppSpacing.xl),

                  // Bento: big streak card + 2 stat cards stacked on the right
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 6,
                          child: MainCard(
                            currentStreak: streak,
                            bestStreak: 141,
                            averageStreak: 47,
                            onViewProgress: _openBenefitsTimeline,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              Expanded(
                                child: MiniStatCard(
                                  icon: LucideIcons.trophy,
                                  label: 'BEST',
                                  value: '141',
                                  unit: 'days',
                                  color: const Color(0xFFB45309),
                                  bgColor: const Color(0xFFFFF3D6),
                                ).animate(delay: 60.ms).fadeIn(duration: 350.ms).slideX(
                                      begin: 0.06, end: 0,
                                      duration: 350.ms,
                                      curve: Curves.easeOutCubic,
                                    ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Expanded(
                                child: MiniStatCard(
                                  icon: LucideIcons.trendingUp,
                                  label: 'AVERAGE',
                                  value: '47',
                                  unit: 'days',
                                  color: const Color(0xFF059669),
                                  bgColor: const Color(0xFFD7F8EB),
                                ).animate(delay: 120.ms).fadeIn(duration: 350.ms).slideX(
                                      begin: 0.06, end: 0,
                                      duration: 350.ms,
                                      curve: Curves.easeOutCubic,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  RecoveryTimerCard(
                    elapsed: _elapsed,
                    onReset: _confirmReset,
                    onTap: _openBenefitsTimeline,
                  ).animate(delay: 80.ms).fadeIn(duration: 350.ms).slideY(
                        begin: 0.04, end: 0, duration: 350.ms, curve: Curves.easeOutCubic,
                      ),

                  const SizedBox(height: AppSpacing.xl),

                  _SectionLabel(label: 'TODAY\'S FOCUS'),
                  const SizedBox(height: AppSpacing.md),

                  TodaysFocusCard(
                    onAction: () => context.go('/journal'),
                  ).animate(delay: 140.ms).fadeIn(duration: 350.ms).slideY(
                        begin: 0.04, end: 0, duration: 350.ms, curve: Curves.easeOutCubic,
                      ),

                  const SizedBox(height: AppSpacing.xl),

                  _SectionLabel(label: 'QUICK ACTIONS'),
                  const SizedBox(height: AppSpacing.md),

                  QuickActionGrid(
                    onJournal: () => context.go('/journal'),
                    onCommunity: () => context.go('/community'),
                    onCourses: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Courses coming soon!'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
                      ),
                    ),
                    onTools: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Tools coming soon!'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
                      ),
                    ),
                  ).animate(delay: 160.ms).fadeIn(duration: 350.ms).slideY(
                        begin: 0.04, end: 0, duration: 350.ms, curve: Curves.easeOutCubic,
                      ),

                  const SizedBox(height: AppSpacing.xl),

                  _SectionLabel(label: 'CURRENT BENEFITS'),
                  const SizedBox(height: AppSpacing.md),

                  CurrentBenefitsSection(currentDays: streak)
                      .animate(delay: 240.ms)
                      .fadeIn(duration: 350.ms)
                      .slideY(begin: 0.04, end: 0, duration: 350.ms, curve: Curves.easeOutCubic),

                  const SizedBox(height: AppSpacing.xl),

                  _SectionLabel(label: 'DAILY INSPIRATION'),
                  const SizedBox(height: AppSpacing.md),

                  const QuoteCard()
                      .animate(delay: 320.ms)
                      .fadeIn(duration: 350.ms)
                      .slideY(begin: 0.04, end: 0, duration: 350.ms, curve: Curves.easeOutCubic),

                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: AppRadius.circular,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: AppTypography.label),
      ],
    );
  }
}

// ── SOS Sheet ──────────────────────────────────────────────────
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
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.heartPulse,
                      color: AppColors.error, size: 22),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('You\'ve got this',
                          style: AppTypography.heading3
                              .copyWith(fontWeight: FontWeight.w700)),
                      Text('A craving is temporary. You are stronger.',
                          style: AppTypography.caption
                              .copyWith(color: AppColors.textMuted)),
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
              subtitle:
                  'Name 5 things you see, 4 you hear, 3 you can touch, 2 you smell, 1 you taste.',
            ),
            const SizedBox(height: AppSpacing.sm),
            _SosTile(
              icon: LucideIcons.users,
              color: AppColors.primary,
              title: 'Reach out',
              subtitle:
                  'Call a sponsor, friend, or family member right now. You don\'t have to do this alone.',
            ),
            const SizedBox(height: AppSpacing.sm),
            _SosTile(
              icon: LucideIcons.phone,
              color: AppColors.warning,
              title: 'Crisis Helpline',
              subtitle: 'SAMHSA National Helpline: 1-800-662-4357 (free, 24/7, confidential)',
            ),
            const SizedBox(height: AppSpacing.xl),
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
                Text(title,
                    style: AppTypography.bodyMedium
                        .copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textMuted, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
