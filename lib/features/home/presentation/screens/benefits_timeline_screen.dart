import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

/// Recovery benefit milestone: at [days], user gets [title] and [description].
class RecoveryBenefit {
  const RecoveryBenefit({
    required this.days,
    required this.timeLabel,
    required this.title,
    required this.description,
    this.icon = Icons.celebration_rounded,
  });

  final int days;
  final String timeLabel;
  final String title;
  final String description;
  final IconData icon;
}

const List<RecoveryBenefit> _kBenefits = [
 RecoveryBenefit(
    days: 0,
    timeLabel: 'Day 0',
    title: 'You started',
    description: 'The moment you chose recovery. Every benefit from here builds on this.',
    icon: Icons.flag_rounded,
  ),
  RecoveryBenefit(
    days: 1,
    timeLabel: '24 hours',
    title: 'First day clear',
    description: 'Your body begins to clear the substance. Hydration and rest help.',
    icon: Icons.wb_sunny_rounded,
  ),
  RecoveryBenefit(
    days: 3,
    timeLabel: '72 hours',
    title: 'Detox in motion',
    description: 'Acute withdrawal often peaks and starts to ease. Sleep may still be rough.',
    icon: Icons.health_and_safety_rounded,
  ),
  RecoveryBenefit(
    days: 7,
    timeLabel: '1 week',
    title: 'Sleep & mood shift',
    description: 'Many notice better sleep and more stable mood. Cravings can still spike.',
    icon: Icons.nightlight_round,
  ),
  RecoveryBenefit(
    days: 14,
    timeLabel: '2 weeks',
    title: 'Energy & focus',
    description: 'Mental clarity and energy often improve. Routine starts to feel possible.',
    icon: Icons.psychology_rounded,
  ),
  RecoveryBenefit(
    days: 30,
    timeLabel: '1 month',
    title: 'Stronger foundation',
    description: 'Physical and mental gains become clearer. New habits take root.',
    icon: Icons.eco_rounded,
  ),
  RecoveryBenefit(
    days: 90,
    timeLabel: '90 days',
    title: 'Brain rewiring',
    description: 'Neural pathways shift. Cravings reduce; sober identity feels more natural.',
    icon: Icons.psychology_alt_rounded,
  ),
  RecoveryBenefit(
    days: 180,
    timeLabel: '6 months',
    title: 'New identity',
    description: 'You’re not “quitting”—you’re someone who lives without it.',
    icon: Icons.person_rounded,
  ),
  RecoveryBenefit(
    days: 365,
    timeLabel: '1 year',
    title: 'Major milestone',
    description: 'A full year of choices. Celebrate and keep building.',
    icon: Icons.celebration_rounded,
  ),
  RecoveryBenefit(
    days: 730,
    timeLabel: '2 years',
    title: 'Deep stability',
    description: 'Recovery is part of who you are. Keep your practices and community.',
    icon: Icons.anchor_rounded,
  ),
];

// Theme (Using centralized kColor constants)
const _kAchieved = kColorSuccess;
const _kUpcomingMuted = kColorTextMutedAlt;
const _kLineColor = kColorDivider;
const _kLineColorDark = Color(0xFF334155);

/// Approximate heights for scroll-based parallax (History of Everything).
const _kIntroHeight = 72.0;
const _kNodeHeight = 148.0;

/// HoE-style parallax: scale 0.82 when far, 1.0 at center (like asset.scale 0.2–1.0).
double _parallaxScale(double distance, double viewportHeight) {
  const double falloff = 320.0;
  final t = (1.0 - (distance / falloff).clamp(0.0, 1.0));
  return (0.82 + 0.18 * t).clamp(0.82, 1.0);
}

/// HoE-style opacity: fade when far from center.
double _parallaxOpacity(double distance, double viewportHeight) {
  const double falloff = 340.0;
  final t = (1.0 - (distance / falloff).clamp(0.0, 1.0));
  return (0.68 + 0.32 * t).clamp(0.68, 1.0);
}

/// Full-screen timeline — same effect as History of Everything (2Dimensions):
/// pinch zoom, scroll-linked scale/opacity, left time ticks, central spine.
class BenefitsTimelineScreen extends StatefulWidget {
  const BenefitsTimelineScreen({
    super.key,
    required this.currentDays,
  });

  final int currentDays;

  @override
  State<BenefitsTimelineScreen> createState() => _BenefitsTimelineScreenState();
}

class _BenefitsTimelineScreenState extends State<BenefitsTimelineScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() => _scrollOffset = _scrollController.offset);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF0F172A) : kColorBgLight;
    final viewportHeight = MediaQuery.sizeOf(context).height -
        (MediaQuery.paddingOf(context).top + kToolbarHeight) -
        MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        backgroundColor: surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Benefits of recovery',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Central spine (HoE: single line through time, fixed in viewport)
          Positioned(
            left: _kPagePadding + _kGutterWidth + _kSpineNodeSize / 2 -
                _kSpineStrokeWidth / 2,
            top: 0,
            bottom: 0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomPaint(
                  size: Size(_kSpineStrokeWidth, constraints.maxHeight),
                  painter: _SpinePainter(
                    color: isDark ? _kLineColorDark : _kLineColor,
                    strokeWidth: _kSpineStrokeWidth,
                  ),
                );
              },
            ),
          ),
          InteractiveViewer(
            minScale: 0.75,
            maxScale: 1.6,
            clipBehavior: Clip.none,
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                left: _kPagePadding,
                right: _kPagePadding,
                top: 8,
                bottom: MediaQuery.paddingOf(context).bottom + 24,
              ),
              itemCount: _kBenefits.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: Text(
                      'What happens next — a timeline of recovery.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isDark ? Colors.white54 : _kUpcomingMuted,
                        height: 1.4,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(
                        begin: 0.02,
                        end: 0,
                        duration: 400.ms,
                        curve: Curves.easeOut,
                      );
                }
                final nodeIndex = index - 1;
                final benefit = _kBenefits[nodeIndex];
                final achieved = widget.currentDays >= benefit.days;
                final layoutOffset =
                    _kIntroHeight + nodeIndex * _kNodeHeight + _kNodeHeight / 2;
                final viewportCenter = _scrollOffset + viewportHeight / 2;
                final distance = (layoutOffset - viewportCenter).abs();
                final scale = _parallaxScale(distance, viewportHeight);
                final opacity = _parallaxOpacity(distance, viewportHeight);

                return _TimelineNode(
                  benefit: benefit,
                  achieved: achieved,
                  isDark: isDark,
                  isLast: nodeIndex == _kBenefits.length - 1,
                  index: nodeIndex,
                  scale: scale,
                  opacity: opacity,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

const _kSpineStrokeWidth = 3.0;
const _kSpineNodeSize = 28.0;
/// Left gutter for time ticks (HoE: GutterLeft = 45)
const _kGutterWidth = 52.0;

/// Paints a vertical line (timeline spine) for the full height.
class _SpinePainter extends CustomPainter {
  _SpinePainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

const _kPagePadding = 20.0;

class _TimelineNode extends StatelessWidget {
  const _TimelineNode({
    required this.benefit,
    required this.achieved,
    required this.isDark,
    required this.isLast,
    required this.index,
    this.scale = 1.0,
    this.opacity = 1.0,
  });

  final RecoveryBenefit benefit;
  final bool achieved;
  final bool isDark;
  final bool isLast;
  final int index;
  final double scale;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final nodeColor = achieved
        ? _kAchieved
        : (isDark ? _kUpcomingMuted : _kLineColorDark);
    final titleColor = isDark ? Colors.white : Colors.black87;
    final descColor = isDark ? Colors.white60 : _kUpcomingMuted;

    // Bubble on the spine (History of Everything: node with icon on the line)
    final bubbleIconColor = achieved ? Colors.white : (isDark ? Colors.white38 : _kUpcomingMuted);
    final bubble = Container(
      width: _kSpineNodeSize,
      height: _kSpineNodeSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: nodeColor,
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          width: 3,
        ),
        boxShadow: [
          if (achieved)
            BoxShadow(
              color: _kAchieved.withValues(alpha: 0.45),
              blurRadius: 10,
              spreadRadius: 0,
            ),
        ],
      ),
      child: Icon(
        benefit.icon,
        size: 16,
        color: bubbleIconColor,
      ),
    );

    // Time tick in left gutter (HoE: ticks on the left)
    final timeTick = Text(
      benefit.timeLabel.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
        color: achieved ? _kAchieved : _kUpcomingMuted,
      ),
    );

    final content = Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(
                  benefit.title,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                    height: 1.2,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  benefit.description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: descColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // Row: [left gutter: time tick] [spine: bubble] [content] (HoE layout)
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: _kGutterWidth,
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: timeTick,
          ),
        ),
        SizedBox(
          width: _kSpineNodeSize,
          child: Center(child: bubble),
        ),
        const SizedBox(width: 18),
        Expanded(child: content),
      ],
    );

    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Transform.scale(
        alignment: Alignment.centerLeft,
        scale: scale,
        child: row
          .animate()
          .fadeIn(
            duration: 400.ms,
            delay: (80 * index).ms,
            curve: Curves.easeOut,
          )
          .slideX(
            begin: 0.06,
            end: 0,
            duration: 400.ms,
            delay: (80 * index).ms,
            curve: Curves.easeOutCubic,
          ),
      ),
    );
  }
}
