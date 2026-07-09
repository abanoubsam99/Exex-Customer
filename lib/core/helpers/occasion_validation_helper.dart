/// Validation for the occasion (نوع + تاريخ المناسبة) that both the
/// service-details screen and the complete-booking screen require before a
/// reservation can be created. Kept in one place so the two screens can never
/// disagree on the wording.
class OccasionValidationHelper {
  const OccasionValidationHelper._();

  /// The error to toast for whatever the user still hasn't picked, or `null`
  /// when both the occasion type and its date are set.
  static String? missingOccasionMessage({
    required DateTime? date,
    required int? occasionId,
  }) {
    final noDate = date == null;
    final noType = (occasionId ?? 0) <= 0;
    if (noDate && noType) return 'حدد نوع وتاريخ المناسبة لاستكمال الحجز';
    if (noDate) return 'حدد تاريخ المناسبة لاستكمال الحجز';
    if (noType) return 'حدد نوع المناسبة لاستكمال الحجز';
    return null;
  }
}
