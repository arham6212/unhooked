import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum MeditationCategory {
  all('All', LucideIcons.layoutGrid),
  urgeSurfing('Urge Surfing', LucideIcons.waves),
  breathing('Breathing', LucideIcons.wind),
  bodyScan('Body Scan', LucideIcons.scan),
  sleep('Sleep', LucideIcons.moon),
  morning('Morning', LucideIcons.sunrise),
  focus('Focus', LucideIcons.target),
  gratitude('Gratitude', LucideIcons.heart);

  final String label;
  final IconData icon;
  const MeditationCategory(this.label, this.icon);
}

class BreathingPattern {
  final String name;
  final double inhaleSeconds;
  final double holdSeconds;
  final double exhaleSeconds;
  final double holdAfterExhaleSeconds;

  const BreathingPattern({
    required this.name,
    required this.inhaleSeconds,
    required this.holdSeconds,
    required this.exhaleSeconds,
    this.holdAfterExhaleSeconds = 0,
  });

  double get cycleDuration =>
      inhaleSeconds + holdSeconds + exhaleSeconds + holdAfterExhaleSeconds;
}

class MeditationStep {
  final String instruction;
  final int durationSeconds;

  const MeditationStep({
    required this.instruction,
    required this.durationSeconds,
  });
}

class Meditation {
  final String id;
  final String title;
  final String subtitle;
  final MeditationCategory category;
  final int durationMinutes;
  final String description;
  final List<MeditationStep> steps;
  final BreathingPattern? breathingPattern;
  final bool isQuickStart;
  final Color accentColor;

  const Meditation({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.durationMinutes,
    required this.description,
    required this.steps,
    this.breathingPattern,
    this.isQuickStart = false,
    this.accentColor = const Color(0xFF2563FF),
  });
}
