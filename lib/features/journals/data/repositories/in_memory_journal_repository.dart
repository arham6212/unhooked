import '../../../../core/error/result.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/repositories/journal_repository.dart';

/// MVP stand-in for a Supabase/Hive-backed repository.
/// Holds entries in memory for the app session, seeded with sample pages.
class InMemoryJournalRepository implements JournalRepository {
  InMemoryJournalRepository() : _entries = _seed();

  final List<JournalEntry> _entries;

  static List<JournalEntry> _seed() {
    final now = DateTime.now();
    DateTime daysAgo(int days, int hour, int minute) {
      final d = now.subtract(Duration(days: days));
      return DateTime(d.year, d.month, d.day, hour, minute);
    }

    return [
      JournalEntry(
        id: 'seed-1',
        createdAt: daysAgo(1, 21, 40),
        updatedAt: daysAgo(1, 21, 52),
        body:
            'Called mom after dinner instead of scrolling. We talked for almost an hour about nothing in particular and it was exactly what I needed. I keep forgetting how much lighter I feel after a real conversation. Grateful for the small stuff tonight — the walk home, the quiet kitchen, tea that was still warm when I sat down.',
        mood: JournalMood.calm,
        tags: const ['Gratitude', 'Family'],
      ),
      JournalEntry(
        id: 'seed-2',
        createdAt: daysAgo(2, 23, 15),
        updatedAt: daysAgo(2, 23, 31),
        body:
            'The urge hit hard around midnight. Couldn\'t sleep, kept reaching for my phone out of habit. Instead I got up, splashed water on my face and did the breathing exercise from the app. It passed after maybe twenty minutes. Writing this down because I want to remember: it always passes.',
        mood: JournalMood.struggling,
        tags: const ['Cravings', 'Sleep'],
      ),
      JournalEntry(
        id: 'seed-3',
        createdAt: daysAgo(4, 8, 5),
        updatedAt: daysAgo(4, 8, 12),
        body:
            'Nothing dramatic today, and honestly that\'s the win. Work was work. Made lunch instead of ordering. The routine is starting to carry me instead of the other way around.',
        mood: JournalMood.steady,
        tags: const ['Work'],
      ),
      JournalEntry(
        id: 'seed-4',
        createdAt: daysAgo(6, 19, 30),
        updatedAt: daysAgo(6, 19, 47),
        body:
            'One full week. Went for a run to mark it — first time in months my head felt completely clear the whole way. I know a week is small in the grand scheme, but standing in the shower afterwards I felt genuinely proud. Want to hold onto this feeling for the harder days.',
        mood: JournalMood.bright,
        tags: const ['Wins', 'Health'],
      ),
    ];
  }

  @override
  Future<Result<List<JournalEntry>>> loadEntries() async {
    // Mimic IO latency so loading states stay honest.
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final sorted = [..._entries]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Result.success(sorted);
  }

  @override
  Future<Result<JournalEntry>> upsertEntry(JournalEntry entry) async {
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index >= 0) {
      _entries[index] = entry;
    } else {
      _entries.add(entry);
    }
    return Result.success(entry);
  }

  @override
  Future<Result<void>> deleteEntry(String id) async {
    _entries.removeWhere((e) => e.id == id);
    return const Result.success(null);
  }
}
