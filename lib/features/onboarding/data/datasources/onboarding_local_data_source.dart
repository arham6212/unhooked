import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences-backed store for onboarding state.
/// Migrates to Hive when the offline layer lands.
class OnboardingLocalDataSource {
  static const _kCompleted = 'onboarding_completed';
  static const _kGoal = 'onboarding_goal';
  static const _kHardestTime = 'onboarding_hardest_time';
  static const _kAttempts = 'onboarding_attempts';
  static const _kVowText = 'onboarding_vow_text';
  static const _kVowDate = 'onboarding_vow_date';

  final SharedPreferences _prefs;

  const OnboardingLocalDataSource(this._prefs);

  bool isCompleted() => _prefs.getBool(_kCompleted) ?? false;

  Future<void> markCompleted() => _prefs.setBool(_kCompleted, true);

  String? get goal => _prefs.getString(_kGoal);
  String? get hardestTime => _prefs.getString(_kHardestTime);
  String? get attempts => _prefs.getString(_kAttempts);
  String? get vowText => _prefs.getString(_kVowText);
  String? get vowDate => _prefs.getString(_kVowDate);

  Future<void> saveAnswers({
    String? goal,
    String? hardestTime,
    String? attempts,
    required String vowText,
    String? vowDate,
  }) async {
    if (goal != null) await _prefs.setString(_kGoal, goal);
    if (hardestTime != null) await _prefs.setString(_kHardestTime, hardestTime);
    if (attempts != null) await _prefs.setString(_kAttempts, attempts);
    await _prefs.setString(_kVowText, vowText);
    if (vowDate != null) await _prefs.setString(_kVowDate, vowDate);
  }
}
