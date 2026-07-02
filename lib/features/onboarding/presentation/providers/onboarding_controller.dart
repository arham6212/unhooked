import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/shared_preferences_provider.dart';
import '../../data/datasources/onboarding_local_data_source.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/entities/onboarding_answers.dart';
import '../../domain/repositories/onboarding_repository.dart';

enum OnboardingScene { arrival, recognition, reframe, calibration, vow, firstLight }

class OnboardingState {
  final OnboardingScene scene;
  final OnboardingAnswers answers;
  final int vowVariant;
  final bool completed;

  const OnboardingState({
    this.scene = OnboardingScene.arrival,
    this.answers = const OnboardingAnswers(),
    this.vowVariant = 0,
    this.completed = false,
  });

  OnboardingState copyWith({
    OnboardingScene? scene,
    OnboardingAnswers? answers,
    int? vowVariant,
    bool? completed,
  }) {
    return OnboardingState(
      scene: scene ?? this.scene,
      answers: answers ?? this.answers,
      vowVariant: vowVariant ?? this.vowVariant,
      completed: completed ?? this.completed,
    );
  }

  List<String> get vowVariants {
    final goalLine = switch (answers.goal) {
      OnboardingGoal.control => "I'm taking back control.",
      OnboardingGoal.focus => "I'm taking back my focus.",
      OnboardingGoal.connection => "I'm choosing real connection.",
      OnboardingGoal.selfRespect => "I'm earning back my self-respect.",
      null => "I'm taking my mind back.",
    };
    return [goalLine, "I'm taking my mind back.", 'Today, it turns.'];
  }

  String get vowText => vowVariants[vowVariant % vowVariants.length];
}

class OnboardingController extends Notifier<OnboardingState> {
  IOnboardingRepository get _repository => ref.read(onboardingRepositoryProvider);

  @override
  OnboardingState build() {
    return OnboardingState(completed: _repository.isCompleted());
  }

  void next() {
    final index = state.scene.index;
    if (index >= OnboardingScene.values.length - 1) return;
    state = state.copyWith(scene: OnboardingScene.values[index + 1]);
  }

  void skipToCalibration() {
    state = state.copyWith(scene: OnboardingScene.calibration);
  }

  void selectGoal(OnboardingGoal goal) {
    state = state.copyWith(answers: state.answers.copyWith(goal: goal));
  }

  void selectHardestTime(HardestTime time) {
    state = state.copyWith(answers: state.answers.copyWith(hardestTime: time));
  }

  void selectAttempts(PastAttempts attempts) {
    state = state.copyWith(answers: state.answers.copyWith(attempts: attempts));
  }

  void cycleVow() {
    state = state.copyWith(vowVariant: state.vowVariant + 1);
  }

  void commitVow() {
    state = state.copyWith(
      answers: state.answers.copyWith(
        vowText: state.vowText,
        vowDate: DateTime.now(),
      ),
    );
  }

  /// Persists everything and unlocks the router. A prefs failure must
  /// never trap the user in onboarding, so completion proceeds regardless.
  Future<void> finish() async {
    await _repository.saveAnswers(state.answers);
    await _repository.markCompleted();
    state = state.copyWith(completed: true);
  }
}

final onboardingRepositoryProvider = Provider<IOnboardingRepository>((ref) {
  return OnboardingRepositoryImpl(
    localDataSource: OnboardingLocalDataSource(ref.watch(sharedPreferencesProvider)),
  );
});

final onboardingProvider = NotifierProvider<OnboardingController, OnboardingState>(
  OnboardingController.new,
);
