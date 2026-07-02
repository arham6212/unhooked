import '../../../../core/error/result.dart';
import '../entities/onboarding_answers.dart';

abstract class IOnboardingRepository {
  /// Synchronous read — prefs are loaded before runApp.
  bool isCompleted();

  OnboardingAnswers loadAnswers();

  Future<Result<void>> saveAnswers(OnboardingAnswers answers);

  Future<Result<void>> markCompleted();
}
