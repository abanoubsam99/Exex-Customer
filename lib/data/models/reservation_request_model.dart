/// عنصر من GET /api/Reservations/GetMyRequestReservations — الطلبات الحالية.
class ReservationRequestModel {
  final int? id;
  final int? portId;
  final String? portName;
  final String? portAddress;
  final String? governorate;
  final String? city;
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

  final bool? acceptedByVendor;
  final bool? paid;

  ReservationRequestModel({
    this.id,
    this.portId,
    this.portName,
    this.portAddress,
    this.governorate,
    this.city,
    this.occasionDate,
    this.reservationStatus,
    this.serviceName,
    this.serviceDetails,
    this.apparentPrice,
    this.finalCost,
    this.deposit,
    this.acceptedByVendor,
    this.paid,
  });

  ReservationRequestModel.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num?)?.toInt(),
        portId = (json['portId'] as num?)?.toInt(),
        portName = json['portName'] as String?,
        portAddress = json['portAddress'] as String?,
        governorate = json['governorate'] as String?,
        city = json['city'] as String?,
        occasionDate = json['occasionDate'] as String?,
        reservationStatus = json['reservationStatus'] as String?,
        serviceName = json['serviceName'] as String?,
        serviceDetails = json['serviceDetails'] as String?,
        apparentPrice = json['apparentPrice'] as num?,
        finalCost = json['theFinalCostBasedOnNumberOfReservations'] as num?,
        deposit = json['deposit'] as num?,
        acceptedByVendor = json['acceptedByVendor'] as bool?,
        paid = json['paid'] as bool?;
}
