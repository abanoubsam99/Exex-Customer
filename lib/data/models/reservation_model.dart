/// عنصر من GET /api/Reservations/GetMyReservations — الحجوزات المؤكدة.
class ReservationModel {
  final int? id;
  final int? portId;
  final int? serviceId;
  final int? occasionId;
  final String? portName;
  final String? governorate;
  final String? city;
  final String? portLocation;
  final String? occasionDate;
  final String? reservationStatus;
  final String? serviceName;
  final String? serviceDetails;

  /// السعر الظاهر (قبل خصم عدد الحجوزات).
  final num? apparentPrice;

  /// التكلفة النهائية حسب عدد الحجوزات (بعد الخصم).
  final num? finalCost;

  /// مقدم الحجز.
  final num? deposit;

  /// إجمالي المبلغ المدفوع من العميل (تاب المؤكدة/الملغاه).
  final num? paid;

  /// المبلغ المتبقي على العميل (تاب المؤكدة).
  final num? remaining;

  /// المبلغ المسترد للعميل (تاب الملغاه).
  final num? refunded;

  ReservationModel({
    this.id,
    this.portId,
    this.serviceId,
    this.occasionId,
    this.portName,
    this.governorate,
    this.city,
    this.portLocation,
    this.occasionDate,
    this.reservationStatus,
    this.serviceName,
    this.serviceDetails,
    this.apparentPrice,
    this.finalCost,
    this.deposit,
    this.paid,
    this.remaining,
    this.refunded,
  });

  ReservationModel.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num?)?.toInt(),
        portId = (json['portId'] as num?)?.toInt(),
        serviceId = (json['serviceId'] as num?)?.toInt(),
        occasionId = (json['occasionId'] as num?)?.toInt(),
        portName = json['portName'] as String?,
        governorate = json['governorate'] as String?,
        city = json['city'] as String?,
        portLocation = json['portLocation'] as String?,
        occasionDate = json['occasionDate'] as String?,
        reservationStatus = json['reservationStatus'] as String?,
        serviceName = json['serviceName'] as String?,
        serviceDetails = json['serviceDetails'] as String?,
        apparentPrice = json['apparentPrice'] as num?,
        finalCost = json['theFinalCostBasedOnNumberOfReservations'] as num?,
        deposit = json['deposit'] as num?,
        paid = (json['totalAmountPaid'] ??
            json['totalAmountReceivedFromCustomer']) as num?,
        remaining = json['remainingAmount'] as num?,
        refunded = json['totalAmountRefundedToCustomer'] as num?;
}
