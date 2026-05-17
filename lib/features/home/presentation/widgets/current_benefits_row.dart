import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';

class _Benefit {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  const _Benefit(this.icon, this.label, this.color, this.bgColor);
}

const _kBenefits = [
  _Benefit(LucideIcons.target, 'Better Focus', Color(0xFF2563FF),
      Color(0xFFE0E8FF)),
  _Benefit(LucideIcons.shieldCheck, 'Self Control', Color(0xFF059669),
      Color(0xFFD7F8EB)),
  _Benefit(LucideIcons.moon, 'Better Sleep', Color(0xFF7C3AED),
      Color(0xFFEBE4FF)),
  _Benefit(LucideIcons.zap, 'More Energy', Color(0xFFB45309),
      Color(0xFFFFF3D6)),
  _Benefit(LucideIcons.star, 'Confidence', Color(0xFF2563FF),
      Color(0xFFE0E8FF)),
  _Benefit(LucideIcons.heart, 'Calm Mind', Color(0xFFBE185D),
      Color(0xFFFFE3EF)),
  _Benefit(LucideIcons.brain, 'Mental Clarity', Color(0xFF0891B2),
      Color(0xFFD7F8FA)),
];

const _kItemsPerPage = 3;
// chip width (100) + separator (12) = 112
const _kChipWidth = 112.0;

class CurrentBenefitsSection extends StatefulWidget {
  const CurrentBenefitsSection({super.key, this.currentDays = 12});
  final int currentDays;

  @override
  State<CurrentBenefitsSection> createState() => _CurrentBenefitsSectionState();
}

class _CurrentBenefitsSectionState extends State<CurrentBenefitsSection> {
  late final ScrollController _scrollCtrl;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController()
      ..addListener(() {
        final page = (_scrollCtrl.offset / (_kChipWidth * _kItemsPerPage))
            .floor()
            .clamp(0, 2);
        if (page != _page) setState(() => _page = page);
      });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 114,
          child: ListView.separated(
            controller: _scrollCtrl,
            scrollDirection: Axis.horizontal,
            itemCount: _kBenefits.length,
            separatorBuilder: (context, i) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, i) => _BenefitChip(benefit: _kBenefits[i]),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Live scroll indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final active = i == _page;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 22 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active ? AppColors.primary : AppColors.border,
                borderRadius: AppRadius.circular,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _BenefitChip extends StatelessWidget {
  const _BenefitChip({required this.benefit});
  final _Benefit benefit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: benefit.bgColor,
        borderRadius: AppRadius.extraLarge,
        boxShadow: [
          BoxShadow(
            color: benefit.color.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: benefit.color.withValues(alpha: 0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(benefit.icon, size: 20, color: benefit.color),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              benefit.label,
              style: AppTypography.caption.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.2,
                letterSpacing: -0.1,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
