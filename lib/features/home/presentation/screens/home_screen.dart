import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'benefits_timeline_screen.dart';

import '../widgets/home_widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Timer _timer;
  late DateTime _startDate;
  late Duration _elapsed;
  int _selectedNavIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : kSurfaceLight,
      body: SafeArea(
        child: Column(
          children: [
            PremiumAppBar(
              onMenu: () {},
              onSos: () {},
              onLogout: () =>
                  ref.read(authProvider.notifier).logout(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: kPagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    const GreetingSection(),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 16),
                    const QuoteCard(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            BottomNavBar(
              selectedIndex: _selectedNavIndex,
              onTap: (i) => setState(() => _selectedNavIndex = i),
            ),
          ],
        ),
      ),
    );
  }
}
