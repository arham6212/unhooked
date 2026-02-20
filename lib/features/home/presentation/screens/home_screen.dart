import 'dart:async';
import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// --- Premium layout
const _kPagePadding = 20.0;
const _kCardRadius = 24.0;
const _kCardRadiusSmall = 16.0;

// Premium palette (refined, not flat)
const _kPrimaryStart = Color(0xFF2563EB);
const _kPrimaryEnd = Color(0xFF1D4ED8);
const _kSurfaceLight = Color(0xFFF8FAFC);
const _kOnPrimary = Color(0xFFFFFFFF);
const _kOnPrimaryMuted = Color(0xFFE0E7FF);
const _kSosRed = Color(0xFFDC2626);
const _kCleanDay = Color(0xFFFFFFFF);
const _kRelapsedDay = Color(0xFFF87171);
const _kBenefitsGreen = Color(0xFF059669);
const _kQuoteMuted = Color(0xFF64748B);

// Timer / flip
const _kDaysAreaWidth = 56.0;
const _kDaysAreaHeight = 44.0;
const _kClockPairWidth = 36.0;
const _kClockDigitWidth = 18.0;
const _kClockDigitHeight = 32.0;

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
      backgroundColor: isDark ? const Color(0xFF0F172A) : _kSurfaceLight,
      body: SafeArea(
        child: Column(
          children: [
            _PremiumAppBar(
              onMenu: () {},
              onSos: () {},
              onLogout: () =>
                  ref.read(authProvider.notifier).logout(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: _kPagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    _GreetingSection(),
                    const SizedBox(height: 20),
                    _MainCard(
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
                    ),
                    const SizedBox(height: 16),
                    _QuoteCard(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _BottomNavBar(
              selectedIndex: _selectedNavIndex,
              onTap: (i) => setState(() => _selectedNavIndex = i),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumAppBar extends StatelessWidget {
  const _PremiumAppBar({
    required this.onMenu,
    required this.onSos,
    required this.onLogout,
  });

  final VoidCallback onMenu;
  final VoidCallback onSos;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: onMenu,
            icon: Icon(
              Icons.menu_rounded,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Recover Me',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: _kPrimaryStart,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: _kSosRed,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: onSos,
              borderRadius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded, color: _kOnPrimary, size: 18),
                    SizedBox(width: 4),
                    Text(
                      'SOS',
                      style: TextStyle(
                        color: _kOnPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            onSelected: (value) {
              if (value == 'logout') onLogout();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, size: 20),
                    SizedBox(width: 12),
                    Text('Log out'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting.',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Your recovery journey continues',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? Colors.white60 : _kQuoteMuted,
          ),
        ),
      ],
    );
  }
}

class _MainCard extends StatelessWidget {
  const _MainCard({
    required this.elapsed,
    required this.currentStreak,
    required this.bestStreak,
    required this.averageStreak,
    required this.onResetTimer,
  });

  final Duration elapsed;
  final int currentStreak;
  final int bestStreak;
  final int averageStreak;
  final VoidCallback onResetTimer;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_kCardRadius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_kPrimaryStart, _kPrimaryEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: _kPrimaryStart.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$currentStreak',
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          color: _kOnPrimary,
                          height: 1.0,
                          letterSpacing: -1,
                        ),
                      ),
                      const Text(
                        'days',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _kOnPrimaryMuted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Current Streak',
                        style: TextStyle(
                          fontSize: 12,
                          color: _kOnPrimaryMuted,
                        ),
                      ),
                      Text(
                        'Best: $bestStreak days',
                        style: const TextStyle(
                          fontSize: 12,
                          color: _kOnPrimaryMuted,
                        ),
                      ),
                      Text(
                        'Average: $averageStreak days',
                        style: const TextStyle(
                          fontSize: 12,
                          color: _kOnPrimaryMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                _DailyGrid(),
              ],
            ),
          ),
          _RecoveryTimerSection(
            elapsed: elapsed,
            onReset: onResetTimer,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                _NavButton(icon: Icons.menu_book_rounded, label: 'Journal'),
                SizedBox(width: 12),
                _NavButton(
                  icon: Icons.people_rounded,
                  label: 'Community',
                ),
                SizedBox(width: 12),
                _NavButton(
                  icon: Icons.school_rounded,
                  label: 'Courses',
                ),
              ],
            ),
          ),
          _CurrentBenefitsRow(),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(
          begin: 0.03,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

class _DailyGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const int rows = 4;
    const int cols = 5;
    const int total = 20;
    const int relapsedCount = 2;
    final cleanCount = total - relapsedCount;
    final relapsedIndices = {total - 3, total - 1};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          '$total Days',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _kOnPrimaryMuted,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1,
            ),
            itemCount: total,
            itemBuilder: (context, index) {
              final isRelapsed = relapsedIndices.contains(index);
              return Container(
                decoration: BoxDecoration(
                  color: isRelapsed ? _kRelapsedDay : _kCleanDay,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    if (!isRelapsed)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 2,
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LegendDot(color: _kCleanDay, label: 'Clean'),
            const SizedBox(width: 8),
            _LegendDot(color: _kRelapsedDay, label: 'Relapsed'),
          ],
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: _kOnPrimaryMuted,
          ),
        ),
      ],
    );
  }
}

class _RecoveryTimerSection extends StatelessWidget {
  const _RecoveryTimerSection({
    required this.elapsed,
    required this.onReset,
  });

  final Duration elapsed;
  final VoidCallback onReset;

  static const _tabularFigures = [FontFeature.tabularFigures()];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(_kCardRadiusSmall),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.schedule_rounded,
            color: _kOnPrimaryMuted,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recovery Timer',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _kOnPrimaryMuted,
                  ),
                ),
                const SizedBox(height: 4),
                _RecoveryTimerDisplay(elapsed: elapsed),
              ],
            ),
          ),
          Material(
            color: Colors.white.withValues(alpha: 0.2),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onReset,
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.refresh_rounded,
                  color: _kOnPrimary,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecoveryTimerDisplay extends StatelessWidget {
  const _RecoveryTimerDisplay({required this.elapsed});

  final Duration elapsed;

  static const _tabularFigures = [FontFeature.tabularFigures()];

  @override
  Widget build(BuildContext context) {
    final d = elapsed.inDays;
    final h = elapsed.inHours % 24;
    final m = elapsed.inMinutes % 60;
    final s = elapsed.inSeconds % 60;
    final style = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: _kOnPrimary,
      height: 1.0,
      fontFeatures: _tabularFigures,
    );
    final labelStyle = const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: _kOnPrimaryMuted,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        SizedBox(
          width: _kDaysAreaWidth,
          height: _kDaysAreaHeight,
          child: Align(
            alignment: Alignment.centerLeft,
            child: _FlipOnlyOnChange(
              value: d,
              textStyle: style,
              duration: const Duration(milliseconds: 320),
            ),
          ),
        ),
        Text('d', style: labelStyle),
        Text(':', style: labelStyle),
        _FlipDigitPair(keyPrefix: 'th', value: h, textStyle: style),
        Text('h', style: labelStyle),
        Text(':', style: labelStyle),
        _FlipDigitPair(keyPrefix: 'tm', value: m, textStyle: style),
        Text('m', style: labelStyle),
        Text(':', style: labelStyle),
        _FlipDigitPair(keyPrefix: 'ts', value: s, textStyle: style),
        Text('s', style: labelStyle),
      ],
    );
  }
}

class _FlipOnlyOnChange extends StatelessWidget {
  const _FlipOnlyOnChange({
    required this.value,
    required this.textStyle,
    this.duration = const Duration(milliseconds: 280),
  });

  final int value;
  final TextStyle? textStyle;
  final Duration duration;

  static const double _pi2 = 1.5707963267948966;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? _) {
            final angle = (1.0 - animation.value) * _pi2;
            return Transform(
              alignment: Alignment.bottomCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(angle),
              child: child,
            );
          },
          child: child,
        );
      },
      child: Text(
        '$value',
        key: ValueKey<int>(value),
        style: textStyle,
      ),
    );
  }
}

class _FlipDigitPair extends StatelessWidget {
  const _FlipDigitPair({
    required this.keyPrefix,
    required this.value,
    required this.textStyle,
  });

  final String keyPrefix;
  final int value;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final tens = value ~/ 10;
    final ones = value % 10;
    return SizedBox(
      width: _kClockPairWidth,
      height: _kClockDigitHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: _kClockDigitWidth,
            height: _kClockDigitHeight,
            child: Center(
              child: KeyedSubtree(
                key: ValueKey('${keyPrefix}_tens'),
                child: _FlipOnlyOnChange(
                  value: tens,
                  textStyle: textStyle,
                  duration: const Duration(milliseconds: 220),
                ),
              ),
            ),
          ),
          SizedBox(
            width: _kClockDigitWidth,
            height: _kClockDigitHeight,
            child: Center(
              child: KeyedSubtree(
                key: ValueKey('${keyPrefix}_ones'),
                child: _FlipOnlyOnChange(
                  value: ones,
                  textStyle: textStyle,
                  duration: const Duration(milliseconds: 220),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              children: [
                Icon(icon, color: _kOnPrimary, size: 24),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _kOnPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CurrentBenefitsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Row(
            children: [
              Icon(
                Icons.self_improvement_rounded,
                color: _kOnPrimaryMuted,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Current Benefits',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _kOnPrimary,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _kBenefitsGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '21',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: _kOnPrimaryMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(_kCardRadiusSmall),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: isDark ? Colors.white38 : _kQuoteMuted,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'The best time to start was yesterday. '
              'The next best time is now.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : _kQuoteMuted,
                height: 1.4,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.share_rounded,
              size: 20,
              color: isDark ? Colors.white54 : _kQuoteMuted,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(
          begin: 0.02,
          end: 0,
          duration: 400.ms,
          delay: 100.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final items = [
      (Icons.home_rounded, 'Home'),
      (Icons.menu_book_rounded, 'Journal'),
      (Icons.people_rounded, 'Community'),
      (Icons.history_rounded, 'History'),
      (Icons.settings_rounded, 'Settings'),
    ];

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.paddingOf(context).bottom + 8,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          items.length,
          (i) {
            final (icon, label) = items[i];
            final selected = i == selectedIndex;
            return InkWell(
              onTap: () => onTap(i),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 24,
                      color: selected
                          ? _kPrimaryStart
                          : (isDark ? Colors.white54 : _kQuoteMuted),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w500,
                        color: selected
                            ? _kPrimaryStart
                            : (isDark ? Colors.white54 : _kQuoteMuted),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
