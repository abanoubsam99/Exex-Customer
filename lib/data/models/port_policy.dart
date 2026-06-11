/// سياسات التاجر/البوابة — رد GET /api/Ports/GetPortPolicy/{portId}.
class PortPolicy {
  final int? id;

  /// فترة السماح بالتعديل في الخدمات (عدد الأيام قبل المناسبة).
  final int? periodEditingServices;

  /// فترة السماح بالتعديل في التاريخ والمكان (عدد الأيام قبل المناسبة).
  final int? periodEditingDateAndLocaltion;

  /// فترة السماح بإلغاء الحجز (عدد الأيام قبل المناسبة).
  final int? cancellationPeriod;

  // تكاليف التعديل في الخدمات (جنيه / لكل مرة).
  final num? costOfModifyingServicesAfterPeriod;
  final num? costOfModifyingServicesBeforePeriod;

  // تكاليف التعديل في التاريخ والمكان (جنيه / لكل مرة).
  final num? costOfModifyingDateAndLocationAfterPeriod;
  final num? costOfModifyingDateAndLocationBeforePeriod;

  // تكاليف الإلغاء (% من مقدم الحجز).
  final num? costOfCancellationAfterPeriod;
  final num? costOfCancellationBeforePeriod;

  final num? cancellationDepositLossPercentage;

  /// مبلغ التأمين (جنيه).
  final num? insuranceAmount;

  /// سياسات أخرى (نص حر).
  final String? otherPolicies;

  final DateTime? createdAt;
  final DateTime? expiryDate;
  final bool? valid;
  final int? portId;

  PortPolicy({
    this.id,
    this.periodEditingServices,
    this.periodEditingDateAndLocaltion,
    this.cancellationPeriod,
    this.costOfModifyingServicesAfterPeriod,
    this.costOfModifyingServicesBeforePeriod,
    this.costOfModifyingDateAndLocationAfterPeriod,
    this.costOfModifyingDateAndLocationBeforePeriod,
    this.costOfCancellationAfterPeriod,
    this.costOfCancellationBeforePeriod,
    this.cancellationDepositLossPercentage,
    this.insuranceAmount,
    this.otherPolicies,
    this.createdAt,
    this.expiryDate,
    this.valid,
    this.portId,
  });

  PortPolicy.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num?)?.toInt(),
        periodEditingServices =
            (json['periodEditingServices'] as num?)?.toInt(),
        periodEditingDateAndLocaltion =
            (json['periodEditingDateAndLocaltion'] as num?)?.toInt(),
        cancellationPeriod = (json['cancellationPeriod'] as num?)?.toInt(),
        costOfModifyingServicesAfterPeriod =
            json['costOfModifyingServicesAfterPeriod'] as num?,
        costOfModifyingServicesBeforePeriod =
            json['costOfModifyingServicesBeforePeriod'] as num?,
        costOfModifyingDateAndLocationAfterPeriod =
            json['costOfModifyingDateAndLocationAfterPeriod'] as num?,
        costOfModifyingDateAndLocationBeforePeriod =
            json['costOfModifyingDateAndLocationBeforePeriod'] as num?,
        costOfCancellationAfterPeriod =
            json['costOfCancellationAfterPeriod'] as num?,
        costOfCancellationBeforePeriod =
            json['costOfCancellationBeforePeriod'] as num?,
        cancellationDepositLossPercentage =
            json['cancellationDepositLossPercentage'] as num?,
        insuranceAmount = json['insuranceAmount'] as num?,
        otherPolicies = json['otherPolicies'] as String?,
        createdAt = _parseDate(json['createdAt']),
        expiryDate = _parseDate(json['expiryDate']),
        valid = json['valid'] as bool?,
        portId = (json['portId'] as num?)?.toInt();

  /// بيتجاهل القيمة الافتراضية "0001-01-01T00:00:00" اللي بيرجّعها الـ backend
  /// لما مفيش تاريخ حقيقي.
  static DateTime? _parseDate(dynamic value) {
    if (value is! String || value.trim().isEmpty) return null;
    final parsed = DateTime.tryParse(value);
    if (parsed == null || parsed.year <= 1) return null;
    return parsed;
  }

  /// تاريخ آخر تحديث بصيغة "dd/MM/yyyy"، أو null لو مفيش تاريخ صالح.
  String? get lastUpdatedLabel {
    final date = createdAt;
    if (date == null) return null;
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(date.day)}/${two(date.month)}/${date.year}';
  }
}
