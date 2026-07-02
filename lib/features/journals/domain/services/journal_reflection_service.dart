import '../../../../core/error/result.dart';
import '../entities/journal_entry.dart';
import '../entities/journal_reflection.dart';

/// Produces a [JournalReflection] for an entry.
///
/// The production implementation should live in `core/ai/` and call the
/// Claude API; [LocalJournalReflectionService] is a heuristic stand-in with
/// the same contract so it can be swapped behind the provider.
abstract class JournalReflectionService {
  Future<Result<JournalReflection>> reflect(JournalEntry entry);
}

class _Theme {
  final String label;
  final RegExp pattern;
  final String question;
  const _Theme(this.label, this.pattern, this.question);
}

final _themes = [
  _Theme(
    'Navigating urges',
    RegExp(r'\b(urge|craving|crave|tempt|relapse|trigger)', caseSensitive: false),
    'What helped you create space between the urge and your response?',
  ),
  _Theme(
    'Connection',
    RegExp(r'\b(friend|call|called|talk|family|mom|dad|brother|sister|partner|wife|husband)',
        caseSensitive: false),
    'Who could you reach out to again this week?',
  ),
  _Theme(
    'Gratitude',
    RegExp(r'\b(grateful|thankful|appreciate|blessing)', caseSensitive: false),
    'What small, ordinary thing would you miss if it were gone?',
  ),
  _Theme(
    'Movement',
    RegExp(r'\b(run|ran|walk|gym|exercise|workout|stretch)', caseSensitive: false),
    'How did your body feel afterwards — and is that worth remembering?',
  ),
  _Theme(
    'Rest & energy',
    RegExp(r'\b(sleep|slept|tired|rest|exhaust|drained)', caseSensitive: false),
    'What is one thing you could set down to protect your rest tonight?',
  ),
  _Theme(
    'Progress',
    RegExp(r'\b(proud|progress|milestone|streak|win|better)', caseSensitive: false),
    'What does this progress say about who you are becoming?',
  ),
  _Theme(
    'Naming stress',
    RegExp(r'\b(anxious|anxiety|stress|worry|worried|overwhelm|restless)', caseSensitive: false),
    'If the worry could speak in one sentence, what would it say?',
  ),
  _Theme(
    'Finding calm',
    RegExp(r'\b(calm|peace|quiet|breath|breathe|meditat|still)', caseSensitive: false),
    'Where in your day could you leave room for more of this?',
  ),
];

class LocalJournalReflectionService implements JournalReflectionService {
  const LocalJournalReflectionService();

  @override
  Future<Result<JournalReflection>> reflect(JournalEntry entry) async {
    // Small pause so the reveal feels considered, not instant.
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final matched = _themes.where((t) => t.pattern.hasMatch(entry.body)).take(3).toList();

    final summary = switch (matched.length) {
      0 =>
        'You gave today ${entry.wordCount} words of honest attention. Writing it down is already a way of taking care of yourself.',
      1 =>
        'A lot of today seems to circle around ${matched.first.label.toLowerCase()}. You wrote about it with real honesty.',
      _ =>
        'Today held a few threads — ${matched.map((t) => t.label.toLowerCase()).join(', ')}. Noticing them side by side is where insight starts.',
    };

    final question = matched.isEmpty
        ? 'If tomorrow-you reads this page, what would you want them to notice?'
        : matched.first.question;

    final affirmation = switch (entry.mood) {
      JournalMood.struggling =>
        'Hard days written down lose a little of their weight. You showed up anyway.',
      JournalMood.low => 'Low tide is still the same ocean. Be patient with yourself.',
      JournalMood.steady => 'Steady is quietly powerful. Keep stacking days like this.',
      JournalMood.calm => 'This calm is something you built. It didn\'t happen by accident.',
      JournalMood.bright => 'Let yourself fully have this good day — you earned it.',
      null => 'Every page you write is proof you\'re paying attention to your life.',
    };

    return Result.success(
      JournalReflection(
        summary: summary,
        themes: matched.map((t) => t.label).toList(),
        question: question,
        affirmation: affirmation,
      ),
    );
  }
}
