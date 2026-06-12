/// عنصر من GET /api/Reservations/GetMyReservations — الحجوزات المؤكدة.
class ReservationModel {
  final int? id;
  final int? portId;
  final String? portName;
  final String? governorate;
  final String? city;
  final String? portLocation;
  final String? occasionDate;
  final String? reservationStatus;
  final String? serviceName;

  /// السعر الظاهر (قبل خصم عدد الحجوزات).
  final num? apparentPrice;

  /// التكلفة النهائية حسب عدد الحجوزات (بعد الخصم).
  final num? finalCost;

  /// مقدم الحجز.
  final num? deposit;

  ReservationModel({
    this.id,
    this.portId,
    this.portName,
    this.governorate,
    this.city,
    this.portLocation,
    this.occasionDate,
    this.reservationStatus,
    this.serviceName,
    this.apparentPrice,
    this.finalCost,
    this.deposit,
  });

  ReservationModel.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num?)?.toInt(),
        portId = (json['portId'] as num?)?.toInt(),
        portName = json['portName'] as String?,
        governorate = json['governorate'] as String?,
        city = json['city'] as String?,
        portLocation = json['portLocation'] as String?,
        occasionDate = json['occasionDate'] as String?,
        reservationStatus = json['reservationStatus'] as String?,
        serviceName = json['serviceName'] as String?,
        apparentPrice = json['apparentPrice'] as num?,
        finalCost = json['theFinalCostBasedOnNumberOfReservations'] as num?,
        deposit = json['deposit'] as num?;
}
