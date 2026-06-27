import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../widgets/home_widgets.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/components/app_scrollbar.dart';

class HomeScreenBody extends ConsumerStatefulWidget {
  const HomeScreenBody({super.key});

  @override
  ConsumerState<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends ConsumerState<HomeScreenBody> {
  final ScrollController _scrollController = ScrollController();
  double _greetingOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final newOpacity = (1.0 - (offset / 120)).clamp(0.0, 1.0);
    if ((newOpacity - _greetingOpacity).abs() > 0.01) {
      setState(() => _greetingOpacity = newOpacity);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const HomeAppBar(),
            Expanded(
              child: AppScrollbar(
                controller: _scrollController,
                interactive: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Greeting — fades on scroll
                      Opacity(
                        opacity: _greetingOpacity,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                          child: GreetingSection(),
                        ),
                      ).animate().fadeIn(duration: 500.ms),

                      const SizedBox(height: AppSpacing.xl),

                      // 2. Hero streak — the emotional anchor
                      const StreakDisplaySection()
                          .animate().fadeIn(duration: 600.ms, delay: 100.ms),

                      const SizedBox(height: AppSpacing.xxl),

                      // 3. Section: YOUR PROGRESS
                      _sectionLabel('YOUR PROGRESS'),
                      const SizedBox(height: AppSpacing.lg),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                        child: StreakIntelligenceCard(),
                      ).animate().fadeIn(duration: 500.ms, delay: 150.ms)
                          .slideY(begin: 0.04, end: 0, duration: 500.ms, delay: 150.ms, curve: Curves.easeOut),

                      const SizedBox(height: AppSpacing.lg),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                        child: Last30DaysCard(),
                      ).animate().fadeIn(duration: 500.ms, delay: 200.ms)
                          .slideY(begin: 0.04, end: 0, duration: 500.ms, delay: 200.ms, curve: Curves.easeOut),

                      const SizedBox(height: AppSpacing.lg),

                      // 4. Recovery level — gradient card
                      const RecoveryLevelCard()
                          .animate().fadeIn(duration: 500.ms, delay: 250.ms)
                          .slideY(begin: 0.04, end: 0, duration: 500.ms, delay: 250.ms, curve: Curves.easeOut),

                      const SizedBox(height: AppSpacing.xxl),

                      // 5. Section: DAILY PRACTICE
                      _sectionLabel('DAILY PRACTICE'),
                      const SizedBox(height: AppSpacing.lg),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                        child: TodaysFocusCard(),
                      ).animate().fadeIn(duration: 500.ms, delay: 300.ms)
                          .slideY(begin: 0.04, end: 0, duration: 500.ms, delay: 300.ms, curve: Curves.easeOut),

                      const SizedBox(height: AppSpacing.xxl),

                      // 6. Daily reflection quote
                      const EditorialQuoteSection()
                          .animate().fadeIn(duration: 500.ms, delay: 350.ms)
                          .slideY(begin: 0.04, end: 0, duration: 500.ms, delay: 350.ms, curve: Curves.easeOut),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Text(
        text,
        style: AppTypography.label.copyWith(
          color: AppColors.textSubtle,
          letterSpacing: 1.5,
          fontSize: 10,
        ),
      ),
    );
  }
}
