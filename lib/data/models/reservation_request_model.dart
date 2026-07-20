/// عنصر من GET /api/Reservations/GetMyRequestReservations — الطلبات الحالية.
class ReservationRequestModel {
  final int? id;
  final int? portId;
  final int? serviceId;
  final int? occasionId;
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
  final String? userNotes;

  /// Pending message text from the vendor awaiting the client's accept/refuse.
  final String? reservationPendingMessage;

  /// Whether a pending message exists (the envelope badge shows 1 when true,
  /// 0 otherwise). Source of truth for the badge — [reservationPendingMessage]
  /// carries the text to display.
  final bool? messageStatus;

  ReservationRequestModel({
    this.id,
    this.portId,
    this.serviceId,
    this.occasionId,
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
    this.userNotes,
    this.reservationPendingMessage,
    this.messageStatus,
  });

  ReservationRequestModel.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num?)?.toInt(),
        portId = (json['portId'] as num?)?.toInt(),
        serviceId = (json['serviceId'] as num?)?.toInt(),
        occasionId = (json['occasionId'] as num?)?.toInt(),
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
        paid = json['paid'] as bool?,
        userNotes = json['userNotes'] as String?,
        reservationPendingMessage =
            json['reservationPendingMessage'] as String?,
        messageStatus = json['messageStatus'] as bool?;
}
