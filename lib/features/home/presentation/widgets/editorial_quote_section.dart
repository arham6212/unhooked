import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';

class _Quote {
  final String text;
  final String author;
  const _Quote(this.text, this.author);
}

const _quotes = [
  _Quote('The man who moves a mountain begins by carrying away small stones.', 'Confucius'),
  _Quote('The strongest man is the one who masters himself.', 'Seneca'),
  _Quote('What lies behind us and what lies before us are tiny matters compared to what lies within us.', 'Ralph Waldo Emerson'),
  _Quote('Fall seven times, stand up eight.', 'Japanese Proverb'),
  _Quote('It is not the mountain we conquer, but ourselves.', 'Edmund Hillary'),
  _Quote('The only way out is through.', 'Robert Frost'),
  _Quote('He who conquers himself is the mightiest warrior.', 'Confucius'),
  _Quote('You are braver than you believe, stronger than you seem, and smarter than you think.', 'A.A. Milne'),
  _Quote('Discipline is choosing between what you want now and what you want most.', 'Abraham Lincoln'),
  _Quote('The secret of change is to focus all your energy not on fighting the old, but on building the new.', 'Socrates'),
];

class EditorialQuoteSection extends StatelessWidget {
  const EditorialQuoteSection({super.key});

  _Quote get _todaysQuote {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    return _quotes[dayOfYear % _quotes.length];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final quote = _todaysQuote;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Reflection',
                style: AppTypography.heading3.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Clipboard.setData(ClipboardData(text: '"${quote.text}" — ${quote.author}'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Quote copied'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                child: Icon(
                  LucideIcons.copy,
                  size: 18,
                  color: isDark ? Colors.white54 : AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '"${quote.text}"',
            style: TextStyle(
              fontFamily: AppTypography.heading2.fontFamily,
              fontSize: 22,
              height: 1.4,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white.withValues(alpha: 0.9) : AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '— ${quote.author}',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? Colors.white54 : AppColors.textMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
