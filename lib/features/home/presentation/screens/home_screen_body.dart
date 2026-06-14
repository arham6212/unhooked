import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/home_widgets.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/components/app_scrollbar.dart';

class HomeScreenBody extends ConsumerStatefulWidget {
  const HomeScreenBody({super.key});

  @override
  ConsumerState<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends ConsumerState<HomeScreenBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
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
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Expanded(child: StreakIntelligenceCard()),
                              const SizedBox(width: AppSpacing.md),
                              const Expanded(child: Last30DaysCard()),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      const StreakDisplaySection(),
                      const SizedBox(height: AppSpacing.xl),
                      const RecoveryLevelCard(),
                      const SizedBox(height: AppSpacing.xl),
                      const QuoteSection(),
                      const SizedBox(height: 120), // Bottom padding for nav bar
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
}
