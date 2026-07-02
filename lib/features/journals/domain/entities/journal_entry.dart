import 'dart:math' as math;

/// Five-point mood scale tuned for recovery journaling.
/// Presentation colors/labels live in `presentation/styles/journal_styles.dart`.
enum JournalMood { struggling, low, steady, calm, bright }

class JournalEntry {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String body;
  final JournalMood? mood;
  final List<String> tags;

  /// The writing prompt this entry started from, if any.
  final String? prompt;

  const JournalEntry({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.body,
    this.mood,
    this.tags = const [],
    this.prompt,
  });

  int get wordCount {
    final trimmed = body.trim();
    if (trimmed.isEmpty) return 0;
    return trimmed.split(RegExp(r'\s+')).length;
  }

  int get readingMinutes => math.max(1, (wordCount / 180).round());

  bool get isEmpty => body.trim().isEmpty;

  JournalEntry copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? body,
    JournalMood? mood,
    List<String>? tags,
    String? prompt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      body: body ?? this.body,
      mood: mood ?? this.mood,
      tags: tags ?? this.tags,
      prompt: prompt ?? this.prompt,
    );
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      body: json['body'] as String? ?? '',
      mood: json['mood'] == null
          ? null
          : JournalMood.values.asNameMap()[json['mood'] as String],
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? const [],
      prompt: json['prompt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'body': body,
      'mood': mood?.name,
      'tags': tags,
      'prompt': prompt,
    };
  }
}
