import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'relapse_heatmap.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';


class ImmersiveStreakLayer extends StatelessWidget {
  const ImmersiveStreakLayer({
    super.key,
    required this.elapsed,
    required this.onSettingsTap,
  });

  final Duration elapsed;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    final days = elapsed.inDays;
    final hours = elapsed.inHours.remainder(24).toString().padLeft(2, '0');
    final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    


    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Ambient landscape colors
    final topColor = isDark ? const Color(0xFF030303) : AppColors.background;
    final bottomColor = isDark ? const Color(0xFF16161A) : const Color(0xFFF0F2F5);
    final highlightColor = AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [topColor, bottomColor],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Subtle animated background aura
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: highlightColor,
                      blurRadius: 100,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scaleXY(begin: 0.9, end: 1.1, duration: 6.seconds, curve: Curves.easeInOutSine),
            ),
          ),



          // The Core Visualization (Timer + Heatmap vertically stacked)
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1), // Spacing from top
                
                // Elegant minimal timer with Odometer Effect per block
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _TimeBlock(value: days.toString(), suffix: 'd ', isDark: isDark),
                    _TimeBlock(value: hours, suffix: 'h ', isDark: isDark),
                    _TimeBlock(value: minutes, suffix: 'm ', isDark: isDark),
                    _TimeBlock(value: seconds, suffix: 's', isDark: isDark),
                  ],
                )
                .animate()
                .fadeIn(duration: 1000.ms, curve: Curves.easeOut)
                .slideY(begin: 0.05, end: 0, duration: 1000.ms, curve: Curves.easeOut),
                
                const SizedBox(height: 16),
                
                // Minimal tracking text
                Text(
                  'CURRENT STREAK',
                  style: AppTypography.caption.copyWith(
                    color: isDark ? Colors.white38 : AppColors.textMuted.withValues(alpha: 0.5),
                    letterSpacing: 4,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                )
                .animate()
                .fadeIn(delay: 300.ms, duration: 800.ms)
                .slideY(begin: 0.1, end: 0, delay: 300.ms, duration: 800.ms, curve: Curves.easeOut),
                
                const SizedBox(height: 48), // Spacing between timer and heatmap
                
                // The Prominent Streak Map
                const RelapseHeatmap(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  final String value;
  final String suffix;
  final bool isDark;

  const _TimeBlock({
    required this.value,
    required this.suffix,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontFamily: AppTypography.heading1.fontFamily,
      fontSize: 40,
      height: 1.0,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.0,
      color: isDark ? Colors.white : AppColors.textPrimary,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: child,
              ),
            );
          },
          child: Text(
            value,
            key: ValueKey<String>(value),
            style: textStyle,
          ),
        ),
        Text(suffix, style: textStyle),
      ],
    );
  }
}
