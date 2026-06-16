/// Response of GET /api/Reservations/CalculateNetCost/{id}.
class NetCostModel {
  final num totalCost;
  final num additionalCost;
  final num discountAmount;
  final num priceAfterDiscount;
  final num netCost;
  final num deposit;
  final num tax;

  const NetCostModel({
    this.totalCost = 0,
    this.additionalCost = 0,
    this.discountAmount = 0,
    this.priceAfterDiscount = 0,
    this.netCost = 0,
    this.deposit = 0,
    this.tax = 0,
  });

  NetCostModel.fromJson(Map<String, dynamic> json)
      : totalCost = (json['totalCost'] as num?) ?? 0,
        additionalCost = (json['additionalCost'] as num?) ?? 0,
        discountAmount = (json['discountAmount'] as num?) ?? 0,
        priceAfterDiscount = (json['priceAfterDiscount'] as num?) ?? 0,
        netCost = (json['netCost'] as num?) ?? 0,
        deposit = (json['deposit'] as num?) ?? 0,
        tax = (json['tax'] as num?) ?? 0;
}
