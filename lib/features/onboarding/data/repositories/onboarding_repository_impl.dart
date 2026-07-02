import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/onboarding_answers.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_data_source.dart';

class OnboardingRepositoryImpl implements IOnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  const OnboardingRepositoryImpl({required this.localDataSource});

  @override
  bool isCompleted() => localDataSource.isCompleted();

  @override
  OnboardingAnswers loadAnswers() {
    return OnboardingAnswers(
      goal: _enumByName(OnboardingGoal.values, localDataSource.goal),
      hardestTime: _enumByName(HardestTime.values, localDataSource.hardestTime),
      attempts: _enumByName(PastAttempts.values, localDataSource.attempts),
      vowText: localDataSource.vowText ?? '',
      vowDate: DateTime.tryParse(localDataSource.vowDate ?? ''),
    );
  }

  @override
  Future<Result<void>> saveAnswers(OnboardingAnswers answers) async {
    try {
      await localDataSource.saveAnswers(
        goal: answers.goal?.name,
        hardestTime: answers.hardestTime?.name,
        attempts: answers.attempts?.name,
        vowText: answers.vowText,
        vowDate: answers.vowDate?.toIso8601String(),
      );
      return const Result.success(null);
    } catch (_) {
      return const Result.failure(CacheFailure());
    }
  }

  @override
  Future<Result<void>> markCompleted() async {
    try {
      await localDataSource.markCompleted();
      return const Result.success(null);
    } catch (_) {
      return const Result.failure(CacheFailure());
    }
  }

  T? _enumByName<T extends Enum>(List<T> values, String? name) {
    if (name == null) return null;
    for (final v in values) {
      if (v.name == name) return v;
    }
    return null;
  }
}
