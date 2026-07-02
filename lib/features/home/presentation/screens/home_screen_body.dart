import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../widgets/home_widgets.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_colors.dart';

class HomeScreenBody extends ConsumerStatefulWidget {
  const HomeScreenBody({super.key});

  @override
  ConsumerState<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends ConsumerState<HomeScreenBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bgController;
  late final Animation<double> _bgOpacity;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _bgOpacity = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _bgController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
    _bgController.forward();
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgOpacity,
              builder: (context, child) {
                return Opacity(
                  opacity: _bgOpacity.value,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/images/asian_landscape_bg.jpeg',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.backgroundLight.withValues(alpha: 0.0),
                    AppColors.backgroundLight.withValues(alpha: 0.0),
                    AppColors.backgroundLight.withValues(alpha: 0.1),
                    AppColors.backgroundLight.withValues(alpha: 0.3),
                  ],
                  stops: const [0.0, 0.4, 0.7, 0.95],
                ),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const HomeAppBar()
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 800.ms),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppSpacing.lg),

                          const GreetingSection()
                              .animate()
                              .fadeIn(duration: 600.ms, delay: 1000.ms)
                              .slideY(begin: 0.1, end: 0, duration: 600.ms, delay: 1000.ms, curve: Curves.easeOut),

                          const SizedBox(height: AppSpacing.xxl),

                          const MainDashboardCard()
                              .animate()
                              .fadeIn(duration: 700.ms, delay: 1300.ms)
                              .slideY(begin: 0.08, end: 0, duration: 700.ms, delay: 1300.ms, curve: Curves.easeOut),

                          const SizedBox(height: AppSpacing.xl),

                          const QuickActionsRow()
                              .animate()
                              .fadeIn(duration: 600.ms, delay: 1700.ms)
                              .slideY(begin: 0.08, end: 0, duration: 600.ms, delay: 1700.ms, curve: Curves.easeOut),

                          const SizedBox(height: AppSpacing.xl),

                          const BenefitsUnlockedCard()
                              .animate()
                              .fadeIn(duration: 600.ms, delay: 2000.ms)
                              .slideY(begin: 0.08, end: 0, duration: 600.ms, delay: 2000.ms, curve: Curves.easeOut),

                          const SizedBox(height: AppSpacing.xl),

                          const DailyInsightCard()
                              .animate()
                              .fadeIn(duration: 600.ms, delay: 2300.ms)
                              .slideY(begin: 0.08, end: 0, duration: 600.ms, delay: 2300.ms, curve: Curves.easeOut),

                          const SizedBox(height: AppSpacing.xxxl),
                        ],
                      ),
                    ),
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
