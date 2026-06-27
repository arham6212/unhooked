import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/meditation_data.dart';
import '../../domain/entities/meditation.dart';

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, MeditationCategory>(
  SelectedCategoryNotifier.new,
);

class SelectedCategoryNotifier extends Notifier<MeditationCategory> {
  @override
  MeditationCategory build() => MeditationCategory.all;

  void select(MeditationCategory category) => state = category;
}

final meditationsProvider = Provider<List<Meditation>>((_) => allMeditations);

final filteredMeditationsProvider = Provider<List<Meditation>>((ref) {
  final category = ref.watch(selectedCategoryProvider);
  final meditations = ref.watch(meditationsProvider)
      .where((m) => m.type == MeditationType.guided);

  if (category == MeditationCategory.all) {
    return meditations.toList();
  }
  return meditations.where((m) => m.category == category).toList();
});

final quickStartMeditationsProvider = Provider<List<Meditation>>((ref) {
  return ref.watch(meditationsProvider).where((m) => m.isQuickStart).toList();
});

final meditationStatsProvider =
    NotifierProvider<MeditationStatsNotifier, MeditationStats>(
  MeditationStatsNotifier.new,
);

class MeditationStatsNotifier extends Notifier<MeditationStats> {
  @override
  MeditationStats build() => const MeditationStats();

  void addSession(int durationMinutes) {
    state = MeditationStats(
      totalSessions: state.totalSessions + 1,
      totalMinutes: state.totalMinutes + durationMinutes,
      currentStreak: state.currentStreak,
    );
  }
}

class MeditationStats {
  final int totalSessions;
  final int totalMinutes;
  final int currentStreak;

  const MeditationStats({
    this.totalSessions = 0,
    this.totalMinutes = 0,
    this.currentStreak = 0,
  });
}
