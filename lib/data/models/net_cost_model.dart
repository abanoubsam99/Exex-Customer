/// Response of GET /api/Reservations/Client/CalculateNetCost/{id}.
class NetCostModel {
  final num totalCost;
  final num additionalCost;
  final num discountAmount;
  final num priceAfterDiscount;
  final num netCost;
  final num deposit;
  final num tax;

  /// عمولة evex.
  final num commission;

  /// رسوم إدارية.
  final num adminFees;

  /// مبلغ التأمين.
  final num insuranceAmount;

  const NetCostModel({
    this.totalCost = 0,
    this.additionalCost = 0,
    this.discountAmount = 0,
    this.priceAfterDiscount = 0,
    this.netCost = 0,
    this.deposit = 0,
    this.tax = 0,
    this.commission = 0,
    this.adminFees = 0,
    this.insuranceAmount = 0,
  });

  NetCostModel.fromJson(Map<String, dynamic> json)
      : totalCost = _num(json, const ['totalCost']),
        additionalCost = _num(json, const ['additionalCost']),
        discountAmount = _num(json, const ['discountAmount']),
        priceAfterDiscount = _num(json, const ['priceAfterDiscount']),
        netCost = _num(json, const ['netBill', 'netCost']),
        deposit = _num(json, const ['deposit']),
        tax = _num(json, const ['vATAmount', 'tax', 'vat']),
        commission = _num(json, const [
          'evexAdditionalCommissionAmount',
          'commission',
          'evexCommission',
          'evexCommissionAmount',
          'evexComission',
        ]),
        adminFees = _num(json, const [
          'administrativeFeesFromEVEX',
          'adminFees',
          'administrativeFees',
          'administrationFees',
          'managementFees',
        ]),
        insuranceAmount = _num(json, const [
          'insuranceAmount',
          'insuranceAmountFromVendor',
        ]);

  /// Reads the first key that holds a numeric value (tolerant to the exact
  /// field name the backend uses), defaulting to 0 when none is present.
  static num _num(Map<String, dynamic> json, List<String> keys) {
    for (final k in keys) {
      final v = json[k];
      if (v is num) return v;
    }
    return 0;
  }
}
