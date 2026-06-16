/// Central place to translate backend reservation statuses to Arabic.
/// Use [arabic] wherever a `reservationStatus` is shown to the user, so the
/// whole project stays Arabic and changes happen here only.
class ReservationStatusHelper {
  ReservationStatusHelper._();

  static const Map<String, String> _ar = {
    'confirmed': 'حجز مؤكد',
    'cancelled': 'ملغي',
    'canceled': 'ملغي',
    'pending': 'قيد الانتظار',
    'waiting': 'في الانتظار',
    'rejected': 'مرفوض',
    'accepted': 'مقبول',
    'completed': 'مكتمل',
    'expired': 'منتهي',
    'new': 'جديد',
    'request': 'طلب حجز',
  };

  /// Arabic label for [status]. Unknown values (often already Arabic, like the
  /// request availability messages) are returned as-is.
  static String arabic(String? status) {
    final raw = status?.trim() ?? '';
    if (raw.isEmpty) return '';
    return _ar[raw.toLowerCase()] ?? raw;
  }

  static bool isConfirmed(String? status) =>
      (status?.trim().toLowerCase() ?? '') == 'confirmed';

  static bool isCancelled(String? status) {
    final s = status?.trim().toLowerCase() ?? '';
    return s == 'cancelled' || s == 'canceled';
  }
}
