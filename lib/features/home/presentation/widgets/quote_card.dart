import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/widgets/widget_value_loader.dart';
import '../../domain/entities/quote.dart';
import '../providers/quote_provider.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';

class QuoteCard extends ConsumerStatefulWidget {
  const QuoteCard({super.key});

  @override
  ConsumerState<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends ConsumerState<QuoteCard>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      value: 1.0,
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _nextQuote() async {
    await _ctrl.reverse();
    setState(() => _index++);
    await _ctrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final quotesAsync = ref.watch(quotesProvider);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5FF),
        borderRadius: AppRadius.extraLarge,
        border: Border.all(color: AppColors.primaryXLight, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Decorative open-quote mark
            const Text(
              '"',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 56,
                height: 0.85,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Quote text — fades between quotes
            FadeTransition(
              opacity: _fade,
              child: WidgetValueLoader<List<Quote>>(
                value: quotesAsync,
                dataBuilder: (list) {
                  final quote = list.isEmpty
                      ? null
                      : list[_index % list.length];
                  return Text(
                    quote?.content ?? 'Keep going — every day counts.',
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      height: 1.65,
                      letterSpacing: -0.1,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Bottom row: subtle divider line + next button
            Row(
              children: [
                Container(
                  height: 2,
                  width: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: AppRadius.circular,
                  ),
                ),
                const Spacer(),
                // Next quote pill button
                GestureDetector(
                  onTap: _nextQuote,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs + 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadius.circular,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.refreshCw,
                          size: 12,
                          color: AppColors.onPrimary,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Next quote',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
