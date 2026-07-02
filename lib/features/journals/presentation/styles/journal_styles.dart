import 'package:flutter/material.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../domain/entities/journal_entry.dart';

/// Serif type scale for the journal — the "ink on paper" voice.
/// Georgia ships on iOS; Android falls through to Noto Serif via 'serif'.
class JournalType {
  static const String _serif = 'Georgia';
  static const List<String> _fallback = ['Times New Roman', 'serif'];

  /// The editor body — the hero of the whole feature.
  static const TextStyle editorBody = TextStyle(
    fontFamily: _serif,
    fontFamilyFallback: _fallback,
    fontSize: 19,
    fontWeight: FontWeight.w400,
    height: 1.7,
    letterSpacing: 0.1,
    color: AppColors.textPrimary,
  );

  /// Entry previews on cards.
  static const TextStyle preview = TextStyle(
    fontFamily: _serif,
    fontFamilyFallback: _fallback,
    fontSize: 15.5,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.1,
    color: AppColors.textBody,
  );

  /// Prompts and quotes — italic, quiet.
  static const TextStyle prompt = TextStyle(
    fontFamily: _serif,
    fontFamilyFallback: _fallback,
    fontSize: 15,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w400,
    height: 1.55,
    letterSpacing: 0.1,
    color: AppColors.textBody,
  );

  /// Ghost line inside the Today card / empty editor.
  static const TextStyle ghost = TextStyle(
    fontFamily: _serif,
    fontFamilyFallback: _fallback,
    fontSize: 17,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.1,
    color: AppColors.textSubtle,
  );

  /// Serif display for the empty state / reflective moments.
  static const TextStyle display = TextStyle(
    fontFamily: _serif,
    fontFamilyFallback: _fallback,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );
}

/// Presentation attributes for each mood — kept out of the domain layer.
extension JournalMoodX on JournalMood {
  String get label => switch (this) {
        JournalMood.struggling => 'Heavy',
        JournalMood.low => 'Low',
        JournalMood.steady => 'Steady',
        JournalMood.calm => 'Calm',
        JournalMood.bright => 'Bright',
      };

  Color get color => switch (this) {
        JournalMood.struggling => const Color(0xFFF87171), // soft coral
        JournalMood.low => const Color(0xFF8B5CF6), // muted violet
        JournalMood.steady => AppColors.primaryLight, // sky blue
        JournalMood.calm => AppColors.teal,
        JournalMood.bright => const Color(0xFFF59E0B), // warm amber
      };

  List<Color> get gradient => switch (this) {
        JournalMood.struggling => const [Color(0xFFFCA5A5), Color(0xFFF87171)],
        JournalMood.low => const [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
        JournalMood.steady => const [Color(0xFF93B4FF), Color(0xFF5B9BFF)],
        JournalMood.calm => const [Color(0xFF34D6BC), Color(0xFF00C2A8)],
        JournalMood.bright => const [Color(0xFFFCD34D), Color(0xFFF59E0B)],
      };
}

/// One dark/light lookup per build keeps widgets free of isDark branching.
class JournalPalette {
  final Color background;
  final Color surface;
  final Color border;
  final Color divider;
  final Color textPrimary;
  final Color textBody;
  final Color textMuted;
  final Color textSubtle;

  const JournalPalette._({
    required this.background,
    required this.surface,
    required this.border,
    required this.divider,
    required this.textPrimary,
    required this.textBody,
    required this.textMuted,
    required this.textSubtle,
  });

  static const _light = JournalPalette._(
    background: AppColors.background,
    surface: AppColors.surface,
    border: AppColors.border,
    divider: AppColors.divider,
    textPrimary: AppColors.textPrimary,
    textBody: AppColors.textBody,
    textMuted: AppColors.textMuted,
    textSubtle: AppColors.textSubtle,
  );

  static const _dark = JournalPalette._(
    background: AppColors.backgroundDark,
    surface: AppColors.surfaceDark,
    border: AppColors.borderDark,
    divider: AppColors.dividerDark,
    textPrimary: Color(0xFFF3F4F6),
    textBody: Color(0xFFC7CDDB),
    textMuted: Color(0xFF8B94A9),
    textSubtle: Color(0xFF6B7488),
  );

  static JournalPalette of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? _dark : _light;
  }
}
