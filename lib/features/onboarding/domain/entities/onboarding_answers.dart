enum OnboardingGoal {
  control('Control'),
  focus('Focus'),
  connection('Connection'),
  selfRespect('Self-respect');

  final String label;
  const OnboardingGoal(this.label);
}

enum HardestTime {
  lateNight('Late at night'),
  alone('When I\'m alone'),
  stress('Under stress'),
  varies('It varies');

  final String label;
  const HardestTime(this.label);
}

enum PastAttempts {
  many('Many times'),
  few('Once or twice'),
  first('This is my first real attempt');

  final String label;
  const PastAttempts(this.label);
}

class OnboardingAnswers {
  final OnboardingGoal? goal;
  final HardestTime? hardestTime;
  final PastAttempts? attempts;
  final String vowText;
  final DateTime? vowDate;

  const OnboardingAnswers({
    this.goal,
    this.hardestTime,
    this.attempts,
    this.vowText = '',
    this.vowDate,
  });

  OnboardingAnswers copyWith({
    OnboardingGoal? goal,
    HardestTime? hardestTime,
    PastAttempts? attempts,
    String? vowText,
    DateTime? vowDate,
  }) {
    return OnboardingAnswers(
      goal: goal ?? this.goal,
      hardestTime: hardestTime ?? this.hardestTime,
      attempts: attempts ?? this.attempts,
      vowText: vowText ?? this.vowText,
      vowDate: vowDate ?? this.vowDate,
    );
  }
}
