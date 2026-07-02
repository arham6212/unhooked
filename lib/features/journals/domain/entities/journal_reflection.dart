/// A gentle, AI-generated (or heuristic) reading of a journal entry.
class JournalReflection {
  /// One or two sentences mirroring back what the entry holds.
  final String summary;

  /// Short theme labels noticed in the writing (max ~3).
  final List<String> themes;

  /// A single open question inviting the writer deeper.
  final String question;

  /// A quiet line of encouragement.
  final String affirmation;

  const JournalReflection({
    required this.summary,
    required this.themes,
    required this.question,
    required this.affirmation,
  });
}
