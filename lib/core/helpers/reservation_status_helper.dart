import 'package:easy_localization/easy_localization.dart';

/// Helpers for reservation statuses. The status itself is kept raw in the
/// models; translation happens here via easy_localization (keys live in
/// assets/translations/*.json), so screens just call [label].
class ReservationStatusHelper {
  ReservationStatusHelper._();

  /// Localized label for a raw backend [status] (e.g. 'confirmed' → 'حجز مؤكد').
  /// Unknown values (often already-localized availability messages) fall back to
  /// the original text, since `.tr()` returns the key when it has no entry.
  static String label(String? status) {
    final raw = status?.trim() ?? '';
    if (raw.isEmpty) return '';
    return raw.toLowerCase().tr();
  }

  /// Whether a request's availability status means it can be booked now.
  /// The backend sends Arabic messages like "متاح للحجز ..." / "غير متاح ...".
  /// Note "غير متاح" also *contains* "متاح", so a plain `contains('متاح')`
  /// wrongly reads unavailable requests as available — we exclude "غير" here.
  static bool isAvailable(String? status) {
    final s = status?.trim() ?? '';
    return s.contains('متاح') && !s.contains('غير');
  }

  /// Localized-independent label for a request that is still waiting on the
  /// vendor's confirmation.
  static const String awaitingVendorLabel = 'بأنتظار التأكيد من ناحية التاجر';

  /// True when the request is still waiting on the vendor's confirmation
  /// (waiting == true and not yet accepted). Such a request isn't bookable or
  /// payable yet and shows the [awaitingVendorLabel] status.
  static bool isAwaitingVendor({bool? waiting, bool? acceptedByVendor}) =>
      waiting == true && acceptedByVendor != true;

  static bool isConfirmed(String? status) =>
      (status?.trim().toLowerCase() ?? '') == 'confirmed';

  static bool isCancelled(String? status) {
    final s = status?.trim().toLowerCase() ?? '';
    // Accept the raw backend value and the already-translated Arabic label.
    return s == 'cancelled' || s == 'canceled' || s == 'ملغي' || s == 'ملغى';
  }
}
