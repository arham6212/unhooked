const _weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

/// The intro's opening line — aware of the moment the user arrived.
/// Most downloads in this category happen late at night; naming the
/// moment is the first signal that the app is present and personal.
String timeContextLine(DateTime now) {
  final day = _weekdays[now.weekday - 1];
  final hour12 = now.hour % 12 == 0 ? 12 : now.hour % 12;
  final minute = now.minute.toString().padLeft(2, '0');
  final clock = '$hour12:$minute';

  if (now.hour >= 21) return "It's $clock on a $day night";
  if (now.hour <= 4) return "It's $clock. You're not the only one awake";
  if (now.hour <= 8) return "It's early on a $day. A good time to start";
  if (now.hour <= 16) return "It's the middle of a $day";
  return "It's $day evening";
}

const _months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// "Thursday, July 2, 2026" — the vow's date stamp.
String vowDateLine(DateTime date) {
  final day = _weekdays[date.weekday - 1];
  final month = _months[date.month - 1];
  return '$day, $month ${date.day}, ${date.year}';
}
