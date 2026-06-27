import 'package:flutter/material.dart';
import '../domain/entities/meditation.dart';

const _boxBreathing = BreathingPattern(
  name: 'Box Breathing',
  inhaleSeconds: 4,
  holdSeconds: 4,
  exhaleSeconds: 4,
  holdAfterExhaleSeconds: 4,
);

const _breathing478 = BreathingPattern(
  name: '4-7-8 Breathing',
  inhaleSeconds: 4,
  holdSeconds: 7,
  exhaleSeconds: 8,
);

const _calmBreathing = BreathingPattern(
  name: 'Deep Calm',
  inhaleSeconds: 5,
  holdSeconds: 2,
  exhaleSeconds: 5,
);

const _energizingBreathing = BreathingPattern(
  name: 'Energizing Breath',
  inhaleSeconds: 3,
  holdSeconds: 1,
  exhaleSeconds: 3,
);

final allMeditations = <Meditation>[
  // ── Quick Start ──────────────────────────────────────────
  Meditation(
    id: 'emergency_calm',
    title: 'Emergency Calm',
    subtitle: 'Instant relief when urges hit',
    category: MeditationCategory.urgeSurfing,
    durationMinutes: 3,
    description: 'A rapid grounding exercise for moments when cravings feel overwhelming. Uses box breathing and sensory anchoring to break the urge cycle.',
    isQuickStart: true,
    accentColor: const Color(0xFFEF4444),
    steps: const [
      MeditationStep(instruction: 'Close your eyes. You are safe right now.', durationSeconds: 8),
      MeditationStep(instruction: 'Notice the urge without judging it. It\'s just a wave — it will pass.', durationSeconds: 12),
      MeditationStep(instruction: 'Follow the breathing circle. Inhale deeply through your nose.', durationSeconds: 50),
      MeditationStep(instruction: 'Name 5 things you can see around you, even with eyes closed — picture them.', durationSeconds: 20),
      MeditationStep(instruction: 'Name 4 things you can physically feel right now.', durationSeconds: 16),
      MeditationStep(instruction: 'Name 3 sounds you can hear.', durationSeconds: 12),
      MeditationStep(instruction: 'The wave is passing. You are stronger than the urge.', durationSeconds: 15),
      MeditationStep(instruction: 'Take one final deep breath. You made it through.', durationSeconds: 10),
    ],
  ),

  Meditation(
    id: 'box_breathing',
    title: 'Box Breathing',
    subtitle: '4-4-4-4 pattern for instant calm',
    category: MeditationCategory.breathing,
    durationMinutes: 5,
    description: 'Used by Navy SEALs to stay calm under pressure. The equal rhythm calms your nervous system within minutes.',
    isQuickStart: true,
    accentColor: const Color(0xFF3B82F6),
    breathingPattern: _boxBreathing,
    steps: const [
      MeditationStep(instruction: 'Sit comfortably. Straighten your back gently.', durationSeconds: 10),
      MeditationStep(instruction: 'Let your shoulders drop. Release the tension in your jaw.', durationSeconds: 10),
      MeditationStep(instruction: 'Follow the breathing circle. Match your breath to the rhythm.', durationSeconds: 120),
      MeditationStep(instruction: 'Continue breathing. Let each cycle take you deeper into calm.', durationSeconds: 120),
      MeditationStep(instruction: 'Gently return to natural breathing. Notice how you feel.', durationSeconds: 15),
    ],
  ),

  // ── Urge Surfing ─────────────────────────────────────────
  Meditation(
    id: 'urge_surfing',
    title: 'Urge Surfing',
    subtitle: 'Ride the wave without giving in',
    category: MeditationCategory.urgeSurfing,
    durationMinutes: 10,
    description: 'The RAIN technique — Recognize, Allow, Investigate, Non-identification. Learn to observe cravings as temporary events that pass on their own.',
    accentColor: const Color(0xFF8B5CF6),
    steps: const [
      MeditationStep(instruction: 'Find a comfortable position. Close your eyes when ready.', durationSeconds: 12),
      MeditationStep(instruction: 'Take three deep breaths to center yourself.', durationSeconds: 18),
      MeditationStep(instruction: 'RECOGNIZE: Notice the urge. Where do you feel it in your body?', durationSeconds: 30),
      MeditationStep(instruction: 'Don\'t fight it. Simply name it: "There is a craving. I notice it."', durationSeconds: 25),
      MeditationStep(instruction: 'ALLOW: Give the urge permission to be there. It can\'t hurt you.', durationSeconds: 30),
      MeditationStep(instruction: 'Imagine the urge as an ocean wave. It rises, peaks, and falls.', durationSeconds: 30),
      MeditationStep(instruction: 'INVESTIGATE: Get curious. Is the urge getting stronger or weaker?', durationSeconds: 30),
      MeditationStep(instruction: 'What does it feel like? Tightness? Heat? Restlessness? Just observe.', durationSeconds: 30),
      MeditationStep(instruction: 'NON-IDENTIFICATION: You are not the urge. You are the one watching it.', durationSeconds: 30),
      MeditationStep(instruction: 'Continue following the breathing circle. The wave is fading.', durationSeconds: 120),
      MeditationStep(instruction: 'You stayed present. You chose awareness over impulse. That is strength.', durationSeconds: 20),
      MeditationStep(instruction: 'Slowly open your eyes. Carry this awareness with you.', durationSeconds: 15),
    ],
  ),

  // ── Breathing ────────────────────────────────────────────
  Meditation(
    id: 'breathing_478',
    title: '4-7-8 Sleep Breathing',
    subtitle: 'Fall asleep in minutes',
    category: MeditationCategory.breathing,
    durationMinutes: 8,
    description: 'Dr. Andrew Weil\'s 4-7-8 technique naturally sedates the nervous system. Perfect for insomnia during early recovery.',
    accentColor: const Color(0xFF6366F1),
    breathingPattern: _breathing478,
    steps: const [
      MeditationStep(instruction: 'Lie down or sit comfortably. Rest your tongue behind your upper teeth.', durationSeconds: 12),
      MeditationStep(instruction: 'Exhale completely through your mouth with a whoosh sound.', durationSeconds: 10),
      MeditationStep(instruction: 'Follow the breathing circle. Inhale for 4, hold for 7, exhale for 8.', durationSeconds: 200),
      MeditationStep(instruction: 'Let the rhythm carry you. Each cycle deepens your relaxation.', durationSeconds: 200),
      MeditationStep(instruction: 'Your body is heavy and warm. Let sleep come naturally.', durationSeconds: 20),
    ],
  ),

  Meditation(
    id: 'stress_release',
    title: 'Stress Release',
    subtitle: 'Quick tension dissolve',
    category: MeditationCategory.breathing,
    durationMinutes: 6,
    description: 'A rapid progressive relaxation paired with deep breathing. Releases physical tension that often triggers urges.',
    accentColor: const Color(0xFF10B981),
    steps: const [
      MeditationStep(instruction: 'Take a moment to check in. Where are you holding tension?', durationSeconds: 12),
      MeditationStep(instruction: 'Squeeze your fists tight for 5 seconds… and release.', durationSeconds: 12),
      MeditationStep(instruction: 'Tighten your shoulders up to your ears… hold… and drop them.', durationSeconds: 12),
      MeditationStep(instruction: 'Clench your jaw… hold… and let it go.', durationSeconds: 12),
      MeditationStep(instruction: 'Now follow the breathing circle. Let the calm spread through your body.', durationSeconds: 120),
      MeditationStep(instruction: 'With each exhale, imagine tension leaving as dark smoke.', durationSeconds: 60),
      MeditationStep(instruction: 'With each inhale, imagine warm golden light filling you.', durationSeconds: 60),
      MeditationStep(instruction: 'You are relaxed, present, and in control.', durationSeconds: 15),
    ],
  ),

  // ── Body Scan ────────────────────────────────────────────
  Meditation(
    id: 'body_scan',
    title: 'Mindful Body Scan',
    subtitle: 'Reconnect with your body',
    category: MeditationCategory.bodyScan,
    durationMinutes: 12,
    description: 'A slow, intentional scan from head to toe. Rebuilds a healthy, mindful relationship with your physical self during recovery.',
    accentColor: const Color(0xFF14B8A6),
    steps: const [
      MeditationStep(instruction: 'Lie down comfortably. Close your eyes. Take three deep breaths.', durationSeconds: 20),
      MeditationStep(instruction: 'Bring your attention to the top of your head. Notice any sensations.', durationSeconds: 30),
      MeditationStep(instruction: 'Move your awareness to your forehead, your eyes, your cheeks. Simply notice.', durationSeconds: 35),
      MeditationStep(instruction: 'Scan down to your jaw, your neck. Release any tightness you find.', durationSeconds: 35),
      MeditationStep(instruction: 'Feel your shoulders, your arms, down to your fingertips.', durationSeconds: 40),
      MeditationStep(instruction: 'Bring awareness to your chest. Notice your heartbeat. You are alive.', durationSeconds: 40),
      MeditationStep(instruction: 'Feel your stomach rise and fall with each breath.', durationSeconds: 35),
      MeditationStep(instruction: 'Scan through your hips, your thighs, your knees.', durationSeconds: 35),
      MeditationStep(instruction: 'Move down to your calves, your ankles, the soles of your feet.', durationSeconds: 35),
      MeditationStep(instruction: 'Now feel your entire body as one connected whole. You are present.', durationSeconds: 40),
      MeditationStep(instruction: 'Your body is your ally in recovery. Thank it for carrying you.', durationSeconds: 25),
      MeditationStep(instruction: 'Gently wiggle your fingers and toes. Open your eyes when ready.', durationSeconds: 15),
    ],
  ),

  // ── Sleep ────────────────────────────────────────────────
  Meditation(
    id: 'sleep_meditation',
    title: 'Restful Sleep',
    subtitle: 'Drift off peacefully',
    category: MeditationCategory.sleep,
    durationMinutes: 15,
    description: 'A gentle guided relaxation designed for bedtime. Helps with the insomnia and restlessness common in early recovery.',
    accentColor: const Color(0xFF6366F1),
    steps: const [
      MeditationStep(instruction: 'You\'re done for today. Everything can wait until tomorrow.', durationSeconds: 15),
      MeditationStep(instruction: 'Let your body sink into the bed. Feel the weight of your limbs.', durationSeconds: 20),
      MeditationStep(instruction: 'Follow the slow breathing rhythm. Each exhale makes you heavier.', durationSeconds: 120),
      MeditationStep(instruction: 'Imagine you\'re lying in a boat on a still lake under the stars.', durationSeconds: 30),
      MeditationStep(instruction: 'The gentle rocking of the water soothes you. You are safe.', durationSeconds: 30),
      MeditationStep(instruction: 'With each breath, the sky grows darker, more peaceful.', durationSeconds: 120),
      MeditationStep(instruction: 'Let go of today. Let go of tomorrow. There is only this stillness.', durationSeconds: 120),
      MeditationStep(instruction: 'You are drifting now. Let sleep carry you gently away.', durationSeconds: 30),
    ],
  ),

  // ── Morning ──────────────────────────────────────────────
  Meditation(
    id: 'morning_intention',
    title: 'Morning Intention',
    subtitle: 'Start your day with purpose',
    category: MeditationCategory.morning,
    durationMinutes: 7,
    description: 'Set a clear intention for the day ahead. Build momentum with mindful energy instead of reaching for your phone.',
    accentColor: const Color(0xFFF59E0B),
    steps: const [
      MeditationStep(instruction: 'Good morning. Before anything else, this moment is yours.', durationSeconds: 10),
      MeditationStep(instruction: 'Sit up. Feel your feet on the ground. You\'re here, you\'re present.', durationSeconds: 15),
      MeditationStep(instruction: 'Take three energizing breaths. Fill your lungs completely.', durationSeconds: 18),
      MeditationStep(instruction: 'Follow the breathing circle. Wake up your body with oxygen.', durationSeconds: 90),
      MeditationStep(instruction: 'Ask yourself: What is my ONE intention for today?', durationSeconds: 30),
      MeditationStep(instruction: 'Picture yourself at the end of today, having honored that intention.', durationSeconds: 30),
      MeditationStep(instruction: 'How does it feel? Hold that feeling. It\'s your compass today.', durationSeconds: 25),
      MeditationStep(instruction: 'Remind yourself: I choose growth over comfort today.', durationSeconds: 20),
      MeditationStep(instruction: 'Continue the breathing rhythm. Charge up for the day ahead.', durationSeconds: 120),
      MeditationStep(instruction: 'You are ready. Go make today count.', durationSeconds: 10),
    ],
  ),

  // ── Focus ────────────────────────────────────────────────
  Meditation(
    id: 'focus_clarity',
    title: 'Focus & Clarity',
    subtitle: 'Sharpen your mind',
    category: MeditationCategory.focus,
    durationMinutes: 10,
    description: 'A concentration meditation to combat the brain fog and scattered attention common during recovery. Rebuilds mental discipline.',
    accentColor: const Color(0xFF0EA5E9),
    steps: const [
      MeditationStep(instruction: 'Sit tall. Hands on your knees. Eyes gently closed.', durationSeconds: 12),
      MeditationStep(instruction: 'Follow the breathing circle to settle your mind.', durationSeconds: 60),
      MeditationStep(instruction: 'Now pick a single point of focus — your breath at the tip of your nose.', durationSeconds: 15),
      MeditationStep(instruction: 'Feel the cool air enter. Feel the warm air leave. Nothing else matters.', durationSeconds: 60),
      MeditationStep(instruction: 'When your mind wanders — and it will — gently bring it back. No judgment.', durationSeconds: 60),
      MeditationStep(instruction: 'Each time you return your attention, your focus muscle gets stronger.', durationSeconds: 60),
      MeditationStep(instruction: 'Keep following the breath. You are training your mind like a muscle.', durationSeconds: 120),
      MeditationStep(instruction: 'Notice how much sharper you feel. This clarity is always available to you.', durationSeconds: 20),
      MeditationStep(instruction: 'Carry this focused attention into whatever you do next.', durationSeconds: 12),
    ],
  ),

  // ── Gratitude ────────────────────────────────────────────
  Meditation(
    id: 'gratitude',
    title: 'Gratitude Practice',
    subtitle: 'Shift your perspective',
    category: MeditationCategory.gratitude,
    durationMinutes: 8,
    description: 'Gratitude rewires the brain\'s reward system — the same system that addiction hijacks. This practice builds a natural source of dopamine.',
    accentColor: const Color(0xFFEC4899),
    steps: const [
      MeditationStep(instruction: 'Close your eyes. Take a few calming breaths.', durationSeconds: 15),
      MeditationStep(instruction: 'Follow the breathing circle as you settle in.', durationSeconds: 60),
      MeditationStep(instruction: 'Think of one person who has supported you. Picture their face.', durationSeconds: 30),
      MeditationStep(instruction: 'Silently say: "Thank you for being in my life."', durationSeconds: 20),
      MeditationStep(instruction: 'Think of one thing your body did for you today — even just waking up.', durationSeconds: 25),
      MeditationStep(instruction: 'Silently say: "Thank you, body, for carrying me."', durationSeconds: 20),
      MeditationStep(instruction: 'Think of one small pleasure — sunlight, a meal, clean water, music.', durationSeconds: 25),
      MeditationStep(instruction: 'Let the warmth of gratitude fill your chest.', durationSeconds: 30),
      MeditationStep(instruction: 'Now think of your recovery journey. Every day clean is a victory.', durationSeconds: 25),
      MeditationStep(instruction: 'Silently say: "I am grateful for my strength to keep going."', durationSeconds: 25),
      MeditationStep(instruction: 'Continue breathing. Let this gratitude be your natural high.', durationSeconds: 120),
      MeditationStep(instruction: 'Open your eyes. Carry this warmth with you today.', durationSeconds: 12),
    ],
  ),
  // ── Music ────────────────────────────────────────────
  Meditation(
    id: 'ambient_rain',
    title: 'Ambient Rain',
    subtitle: 'Nature sounds for focus or sleep',
    category: MeditationCategory.music,
    durationMinutes: 60,
    description: 'A continuous hour of gentle rain falling on leaves, designed to wash away distractions and create a peaceful acoustic environment.',
    accentColor: const Color(0xFF64748B),
    steps: const [
      MeditationStep(instruction: 'Relax and listen.', durationSeconds: 3600),
    ],
  ),
];
