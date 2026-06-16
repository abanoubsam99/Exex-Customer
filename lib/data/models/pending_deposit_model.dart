/// Response of GET /api/Reservations/CalculatePendingDeposit — the deposit
/// summary for all of the client's pending reservation requests.
class PendingDepositModel {
  final num totalDeposit;
  final int totalRequests;
  final int availableCount;
  final int unavailableCount;
  final int numberOfReservationsAdditionalDiscount;
  final num additionalDiscountAmount;
  final num additionalDiscountPercentage;
  final List<PendingDepositItem> items;

  const PendingDepositModel({
    this.totalDeposit = 0,
    this.totalRequests = 0,
    this.availableCount = 0,
    this.unavailableCount = 0,
    this.numberOfReservationsAdditionalDiscount = 0,
    this.additionalDiscountAmount = 0,
    this.additionalDiscountPercentage = 0,
    this.items = const [],
  });

  PendingDepositModel.fromJson(Map<String, dynamic> json)
      : totalDeposit = (json['totalDeposit'] as num?) ?? 0,
        totalRequests = (json['totalRequests'] as num?)?.toInt() ?? 0,
        availableCount = (json['availableCount'] as num?)?.toInt() ?? 0,
        unavailableCount = (json['unavailableCount'] as num?)?.toInt() ?? 0,
        numberOfReservationsAdditionalDiscount =
            (json['numberOfReservations_AdditionalDiscount'] as num?)?.toInt() ??
                0,
        additionalDiscountAmount =
            (json['additionalDiscountAmount'] as num?) ?? 0,
        additionalDiscountPercentage =
            (json['additionalDiscountPercentage'] as num?) ?? 0,
        items = ((json['items'] as List?) ?? const [])
            .map((e) => PendingDepositItem.fromJson(e as Map<String, dynamic>))
            .toList();
}

/// A single pending reservation request inside [PendingDepositModel].
class PendingDepositItem {
  final int? id;
  final String? portName;
  final String? serviceName;
  final String? occasionDate;
  final num deposit;
  final num netCost;
  final bool isAvailable;
  final bool isWaiting;
  final String? statusMessage;

  const PendingDepositItem({
    this.id,
    this.portName,
    this.serviceName,
    this.occasionDate,
    this.deposit = 0,
    this.netCost = 0,
    this.isAvailable = false,
    this.isWaiting = false,
    this.statusMessage,
  });

  PendingDepositItem.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num?)?.toInt(),
        portName = json['portName'] as String?,
        serviceName = json['serviceName'] as String?,
        occasionDate = json['occasionDate'] as String?,
        deposit = (json['deposit'] as num?) ?? 0,
        netCost = (json['netCost'] as num?) ?? 0,
        isAvailable = json['isAvailable'] == true,
        isWaiting = json['isWaiting'] == true,
        statusMessage = json['statusMessage'] as String?;
}
