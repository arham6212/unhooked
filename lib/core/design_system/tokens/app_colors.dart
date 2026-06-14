import 'package:flutter/material.dart';

class AppColors {
  // ── Brand / Primary ───────────────────────────────────────────
  // Elegant electric blue — confident, calm, trustworthy.
  // Not saturated enough to feel "tech bro", not muted enough to feel flat.
  static const Color primary      = Color(0xFF2563FF); // vivid blue
  static const Color primaryDark  = Color(0xFF1A4FD8); // deep anchor (gradient start)
  static const Color primaryLight = Color(0xFF5B9BFF); // sky (gradient end / accents)
  static const Color primaryXLight= Color(0xFFD6E4FF); // faint tint for backgrounds
  static const Color onPrimary    = Color(0xFFFFFFFF);

  // ── Surface hierarchy ──────────────────────────────────────────
  // Three levels of surface: sunken (inset) → raised (card) → overlay (modal)
  static const Color surfaceSunken  = Color(0xFFEEF3FF); // recessed / tinted bg
  static const Color surfaceOverlay = Color(0xFFFAFBFF); // very subtle blue wash

  // ── Gradient stops (MainCard, Splash, Profile) ───────────────
  // Three-stop: deep → vivid → sky  — 135°
  // Use primaryDark → primary → primaryLight for all major gradients.

  // ── Teal accent ───────────────────────────────────────────────
  // Used for: success states, "current benefits", milestone dots.
  // Cool, healing, modern — as seen in Headspace & Calm.
  static const Color teal     = Color(0xFF00C2A8);
  static const Color tealDark = Color(0xFF00A896);

  // ── SOS (soft coral) ─────────────────────────────────────────
  // Warm coral instead of aggressive red — signals urgency without panic.
  static const Color sosStart = Color(0xFFFF6B6B); // warm coral
  static const Color sosEnd   = Color(0xFFEF4444); // slightly deeper

  // ── Backgrounds ───────────────────────────────────────────────
  // #F7F8FC — barely-there cool white. Not warm beige, not clinical white.
  // Exactly the background tone used by Notion, Linear, and Apple Health.
  static const Color background      = Color(0xFFF7F8FC);
  static const Color backgroundLight = Color(0xFFF0F4FF); // faint blue wash
  static const Color backgroundDark  = Color(0xFF0D1117); // near-black

  // ── Surfaces ──────────────────────────────────────────────────
  static const Color surface     = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF161B27); // dark card
  static const Color divider     = Color(0xFFEEF0F6); // very subtle
  static const Color dividerDark = Color(0xFF2A3143); // dark divider
  static const Color border      = Color(0xFFE5E9F4); // card borders
  static const Color borderDark  = Color(0xFF2D3748); // dark card borders

  // ── Text hierarchy (semantic scale) ───────────────────────────
  // Use these instead of the individual text* constants for new widgets.
  static const Color textEmphasis = Color(0xFF060D1F); // near-black, max contrast
  static const Color textStrong   = Color(0xFF1B2559); // headings, important labels
  static const Color textBody2    = Color(0xFF4A5578); // body copy
  static const Color textSubtle   = Color(0xFF8895B3); // captions, placeholders

  // ── Text ──────────────────────────────────────────────────────
  // Slightly cooler than pure black — feels premium, not harsh.
  static const Color textPrimary  = Color(0xFF111827); // near-black
  static const Color textBody     = Color(0xFF374151); // warm dark grey
  static const Color textMuted    = Color(0xFF6B7280); // secondary label
  static const Color textMutedAlt = Color(0xFF9CA3AF); // placeholder / hint

  // ── Semantic ──────────────────────────────────────────────────
  static const Color error   = Color(0xFFEF4444); // red — danger/relapse
  static const Color success = Color(0xFF22C55E); // green — clean days
  static const Color warning = Color(0xFFFFC107); // amber — mild alert
  static const Color info    = Color(0xFF3B82F6); // blue — informational

  // ── Calendar / streak grid ────────────────────────────────────
  static const Color cleanDay    = Color(0xFFFFFFFF);
  static const Color relapsedDay = Color(0xFFFCA5A5); // soft red, not harsh

  // ── Avatar palette ────────────────────────────────────────────
  // Desaturated, harmonious — works on white cards without clashing.
  static const List<Color> avatarPalette = [
    Color(0xFF3B82F6), // blue
    Color(0xFF8B5CF6), // violet
    Color(0xFF10B981), // emerald
    Color(0xFFFFC107), // amber
    Color(0xFFEC4899), // pink
    Color(0xFF06B6D4), // cyan
  ];
}
