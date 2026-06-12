/// Helpers for rendering dates in Arabic. Handles the different shapes the
/// backend returns: ISO ("2026-05-06" / "2026-06-16T00:00:00") and
/// US ("6/14/2026 1:01:51 AM").
class DateFormatHelper {
  DateFormatHelper._();

  static const _months = [
    'يناير',
    'فبراير',
    'مارس',
    'ابريل',
    'مايو',
    'يونيو',
    'يوليو',
    'اغسطس',
    'سبتمبر',
    'اكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  // DateTime.weekday: Monday = 1 .. Sunday = 7
  static const _weekdays = [
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  /// Tries multiple formats. Returns null for empty/default values.
  static DateTime? parse(String? value) {
    if (value == null) return null;
    final v = value.trim();
    if (v.isEmpty) return null;

    // ISO first.
    final iso = DateTime.tryParse(v);
    if (iso != null && iso.year > 1) return iso;

    // US: M/d/yyyy [h:mm:ss AM/PM]
    final parts = v.split(RegExp(r'\s+'));
    final datePart = parts.first.split('/');
    if (datePart.length == 3) {
      final month = int.tryParse(datePart[0]);
      final day = int.tryParse(datePart[1]);
      final year = int.tryParse(datePart[2]);
      if (month != null && day != null && year != null && year > 1) {
        int hour = 0;
        int minute = 0;
        if (parts.length >= 2) {
          final timeBits = parts[1].split(':');
          hour = int.tryParse(timeBits.first) ?? 0;
          if (timeBits.length >= 2) minute = int.tryParse(timeBits[1]) ?? 0;
          final meridiem = parts.length >= 3 ? parts[2].toUpperCase() : '';
          if (meridiem == 'PM' && hour < 12) hour += 12;
          if (meridiem == 'AM' && hour == 12) hour = 0;
        }
        return DateTime(year, month, day, hour, minute);
      }
    }
    return null;
  }

  /// "14 يونيو 2026" — or [fallback] when the date is invalid.
  static String arabicDate(String? value, {String fallback = '—'}) {
    final d = parse(value);
    if (d == null) return fallback;
    return '${d.day} ${_months[d.month - 1]} ${d.year}';
  }

  /// "الأحد" — or an empty string when the date is invalid.
  static String arabicWeekday(String? value) {
    final d = parse(value);
    if (d == null) return '';
    return _weekdays[d.weekday - 1];
  }

  /// "1:01 ص" — or an empty string when there is no time.
  static String arabicTime(String? value) {
    final d = parse(value);
    if (d == null) return '';
    final isPm = d.hour >= 12;
    var hour12 = d.hour % 12;
    if (hour12 == 0) hour12 = 12;
    final minute = d.minute.toString().padLeft(2, '0');
    return '$hour12:$minute ${isPm ? 'م' : 'ص'}';
  }

  /// "مساءا 9:27" — period word followed by h:mm (empty when invalid).
  static String arabicClock(String? value) {
    final d = parse(value);
    if (d == null) return '';
    final isPm = d.hour >= 12;
    var hour12 = d.hour % 12;
    if (hour12 == 0) hour12 = 12;
    final minute = d.minute.toString().padLeft(2, '0');
    return '${isPm ? 'مساءا' : 'صباحا'} $hour12:$minute';
  }
}
