import '../../../../core/error/result.dart';
import '../entities/journal_entry.dart';

abstract class JournalRepository {
  /// Entries sorted newest-first.
  Future<Result<List<JournalEntry>>> loadEntries();

  /// Inserts or updates an entry, returning the persisted value.
  Future<Result<JournalEntry>> upsertEntry(JournalEntry entry);

  Future<Result<void>> deleteEntry(String id);
}
