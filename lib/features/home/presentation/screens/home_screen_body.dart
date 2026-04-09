
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/greeting_section.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
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
  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now().subtract(
      const Duration(days: 12, hours: 6, minutes: 32, seconds: 12),
    );
    _elapsed = DateTime.now().difference(_startDate);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _elapsed = DateTime.now().difference(_startDate));
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  late Timer _timer;
  late DateTime _startDate;
  late Duration _elapsed;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          PremiumAppBar(
            onMenu: () {},
            onSos: () {},
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
                    onResetTimer: () {
                      setState(() {
                        _startDate = DateTime.now();
                        _elapsed = Duration.zero;
                      });
                    },
                    onCounterTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => BenefitsTimelineScreen(
                            currentDays: _elapsed.inDays,
                          ),
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