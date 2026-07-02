/// Hand-rolled date formatting (no intl dependency), journal voice.
class JournalDates {
  static const List<String> _weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];
  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  static String _shortWeekday(DateTime d) => _weekdays[d.weekday - 1].substring(0, 3);
  static String _shortMonth(DateTime d) => _months[d.month - 1].substring(0, 3);

  /// "TUESDAY, JULY 1" — editor top bar.
  static String smallCaps(DateTime d) =>
      '${_weekdays[d.weekday - 1]}, ${_months[d.month - 1]} ${d.day}'.toUpperCase();

  /// "Tue, Jul 1" — compact card date.
  static String compact(DateTime d) => '${_shortWeekday(d)}, ${_shortMonth(d)} ${d.day}';

  /// "Today" / "Yesterday" / "Tue, Jun 24" / adds year when older.
  static String relative(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(d.year, d.month, d.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (d.year == now.year) return compact(d);
    return '${compact(d)}, ${d.year}';
  }

  /// "July 2026" — screen sub-label.
  static String monthYear(DateTime d) => '${_months[d.month - 1]} ${d.year}';
}
