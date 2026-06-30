import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../widgets/home_widgets.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_colors.dart';

class HomeScreenBody extends ConsumerWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 350,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.white.withValues(alpha: 0.8),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                  stops: const [0.5, 0.8, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                'assets/images/asian_landscape_bg.jpeg',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const HomeAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppSpacing.sm),

                          const GreetingSection()
                              .animate().fadeIn(duration: 500.ms),

                          const SizedBox(height: AppSpacing.md),

                          const MainDashboardCard()
                              .animate().fadeIn(duration: 600.ms, delay: 100.ms)
                              .slideY(begin: 0.05, end: 0, curve: Curves.easeOut),

                          const SizedBox(height: AppSpacing.md),

                          const QuickActionsRow()
                              .animate().fadeIn(duration: 500.ms, delay: 150.ms)
                              .slideY(begin: 0.05, end: 0, curve: Curves.easeOut),

                          const SizedBox(height: AppSpacing.md),

                          const BenefitsUnlockedCard()
                              .animate().fadeIn(duration: 500.ms, delay: 200.ms)
                              .slideY(begin: 0.05, end: 0, curve: Curves.easeOut),

                          const SizedBox(height: AppSpacing.md),

                          const DailyInsightCard()
                              .animate().fadeIn(duration: 500.ms, delay: 250.ms)
                              .slideY(begin: 0.05, end: 0, curve: Curves.easeOut),

                          const SizedBox(height: AppSpacing.md),
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
