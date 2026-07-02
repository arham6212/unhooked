import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/in_memory_journal_repository.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/repositories/journal_repository.dart';
import '../../domain/services/journal_reflection_service.dart';

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return InMemoryJournalRepository();
});

/// Swap for a Claude-backed implementation in `core/ai/` when wired up.
final journalReflectionServiceProvider = Provider<JournalReflectionService>((ref) {
  return const LocalJournalReflectionService();
});

final journalEntriesProvider =
    AsyncNotifierProvider<JournalEntriesNotifier, List<JournalEntry>>(
  JournalEntriesNotifier.new,
);

class JournalEntriesNotifier extends AsyncNotifier<List<JournalEntry>> {
  @override
  Future<List<JournalEntry>> build() async {
    final result = await ref.watch(journalRepositoryProvider).loadEntries();
    List<JournalEntry> entries = const [];
    result.fold(
      (data) => entries = data,
      (failure) => throw Exception(failure.message),
    );
    return entries;
  }

  JournalEntry? entryById(String id) {
    final entries = state.value;
    if (entries == null) return null;
    for (final entry in entries) {
      if (entry.id == id) return entry;
    }
    return null;
  }

  /// Latest entry written today, if any — powers the "Today" page card.
  JournalEntry? get todayEntry {
    final entries = state.value;
    if (entries == null || entries.isEmpty) return null;
    final now = DateTime.now();
    for (final entry in entries) {
      final d = entry.createdAt;
      if (d.year == now.year && d.month == now.month && d.day == now.day) {
        return entry;
      }
    }
    return null;
  }

  Future<void> upsert(JournalEntry entry) async {
    final result = await ref.read(journalRepositoryProvider).upsertEntry(entry);
    result.fold(
      (saved) {
        final current = [...(state.value ?? const <JournalEntry>[])];
        final index = current.indexWhere((e) => e.id == saved.id);
        if (index >= 0) {
          current[index] = saved;
        } else {
          current.insert(0, saved);
        }
        current.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        state = AsyncData(current);
      },
      (_) {
        // In-memory writes don't fail; a real backend surfaces this via UI state.
      },
    );
  }

  Future<void> remove(String id) async {
    final result = await ref.read(journalRepositoryProvider).deleteEntry(id);
    result.fold(
      (_) {
        final current = [...(state.value ?? const <JournalEntry>[])]
          ..removeWhere((e) => e.id == id);
        state = AsyncData(current);
      },
      (_) {},
    );
  }
}
