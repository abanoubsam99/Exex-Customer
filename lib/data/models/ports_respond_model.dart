class PortsRespondModel {
  PortsRespondModel({
    required this.index,
    required this.size,
    required this.count,
    required this.pages,
    required this.from,
    required this.items,
    required this.hasPrevious,
    required this.hasNext,
  });

  final int? index;
  final int? size;
  final int? count;
  final int? pages;
  final int? from;
  final List<Item>? items;
  final bool? hasPrevious;
  final bool? hasNext;

  PortsRespondModel.fromJson(Map<String, dynamic> json)
      : index = (json['index'] as num?)?.toInt(),
        size = (json['size'] as num?)?.toInt(),
        count = (json['count'] as num?)?.toInt(),
        pages = (json['pages'] as num?)?.toInt(),
        from = (json['from'] as num?)?.toInt(),
        items = (json['items'] as List?)
            ?.map((e) => Item.fromJson(e))
            .toList(),
        hasPrevious = json['hasPrevious'] as bool?,
        hasNext = json['hasNext'] as bool?;
}

class Item {
  Item({
    required this.cheapestServicePrice,
    required this.portDescription,
    required this.rate,
    required this.companyId,
    required this.lastUpdateDate,
    required this.periodEditingServices,
    required this.periodEditingDateAndLocaltion,
    required this.cancellationPeriod,
    required this.costOfModifyingServicesAfterPeriod,
    required this.costOfModifyingServicesBeforePeriod,
    required this.costOfModifyingDateAndLocationAfterPeriod,
    required this.costOfModifyingDateAndLocationBeforePeriod,
    required this.costOfCancellationAfterPeriod,
    required this.costOfCancellationBeforePeriod,
    required this.otherPolicies,
    required this.governorate,
    required this.city,
    required this.address,
    required this.gps,
    required this.phoneNumber1,
    required this.phoneNumber2,
    required this.openingTime,
    required this.closingTime,
    required this.workDays,
    required this.checkReservationResponse,
    required this.minimumDays,
    required this.isFavorite,
    required this.numberAllowed,
    required this.id,
    required this.portName,
    required this.portTypeDto,
    required this.accepted,
    required this.portKey,
    required this.isAllowedForUploadFiles,
    required this.picturesAlbumName,
    required this.portImages,
    required this.theMainImageFileName,
    required this.goolgeDriveLink,
    this.displayPrice = false,
  });

  final int? cheapestServicePrice;
  final dynamic portDescription;
  final int? rate;
  final int? companyId;
  final DateTime? lastUpdateDate;
  final int? periodEditingServices;
  final int? periodEditingDateAndLocaltion;
  final int? cancellationPeriod;
  final int? costOfModifyingServicesAfterPeriod;
  final int? costOfModifyingServicesBeforePeriod;
  final int? costOfModifyingDateAndLocationAfterPeriod;
  final int? costOfModifyingDateAndLocationBeforePeriod;
  final int? costOfCancellationAfterPeriod;
  final int? costOfCancellationBeforePeriod;
  final dynamic otherPolicies;
  final String? governorate;
  final String? city;
  final String? address;
  final String? gps;
  final String? phoneNumber1;
  final String? phoneNumber2;
  final String? openingTime;
  final String? closingTime;
  final String? workDays;
  final CheckReservationResponse? checkReservationResponse;

  /// Minimum lead time (in days) the vendor requires before an event can be
  /// booked. The earliest selectable booking date is today + [minimumDays].
  final int? minimumDays;

  /// Whether the signed-in client favorited this port (false for guests).
  final bool? isFavorite;

  /// Maximum number of attendees the port can host (الحد الأقصى لعدد الحضور).
  final int? numberAllowed;
  final int? id;
  final String? portName;
  final PortTypeDto? portTypeDto;
  final bool? accepted;
  final String? portKey;
  final bool? isAllowedForUploadFiles;
  final String? picturesAlbumName;
  final dynamic portImages;
  final String? theMainImageFileName;
  final String? goolgeDriveLink;

  /// When true the vendor keeps all prices private for this port: every price on
  /// the details screen (services, additions, buffets, total) is hidden and the
  /// "إضافة لحجوزاتي" button is not shown.
  final bool displayPrice;

  Item.fromJson(Map<String, dynamic> json)
      : cheapestServicePrice =
            (json['cheapestServicePrice'] as num?)?.toInt(),
        portDescription = json['portDescription'],
        rate = (json['rate'] as num?)?.toInt(),
        companyId = (json['companyId'] as num?)?.toInt(),
        lastUpdateDate = json['lastUpdateDate'] != null
            ? DateTime.parse(json['lastUpdateDate'] as String)
            : null,
        periodEditingServices =
            (json['periodEditingServices'] as num?)?.toInt(),
        periodEditingDateAndLocaltion =
            (json['periodEditingDateAndLocaltion'] as num?)?.toInt(),
        cancellationPeriod = (json['cancellationPeriod'] as num?)?.toInt(),
        costOfModifyingServicesAfterPeriod =
            (json['costOfModifyingServicesAfterPeriod'] as num?)?.toInt(),
        costOfModifyingServicesBeforePeriod =
            (json['costOfModifyingServicesBeforePeriod'] as num?)?.toInt(),
        costOfModifyingDateAndLocationAfterPeriod =
            (json['costOfModifyingDateAndLocationAfterPeriod'] as num?)
                ?.toInt(),
        costOfModifyingDateAndLocationBeforePeriod =
            (json['costOfModifyingDateAndLocationBeforePeriod'] as num?)
                ?.toInt(),
        costOfCancellationAfterPeriod =
            (json['costOfCancellationAfterPeriod'] as num?)?.toInt(),
        costOfCancellationBeforePeriod =
            (json['costOfCancellationBeforePeriod'] as num?)?.toInt(),
        otherPolicies = json['otherPolicies'],
        governorate = json['governorate'] as String?,
        city = json['city'] as String?,
        address = json['address'] as String?,
        gps = json['gps'] as String?,
        phoneNumber1 = json['phoneNumber1'] as String?,
        phoneNumber2 = json['phoneNumber2'] as String?,
        openingTime = json['openingTime'] as String?,
        closingTime = json['closingTime'] as String?,
        workDays = json['workDays'] as String?,
        checkReservationResponse = json['checkReservationResponse'] != null
            ? CheckReservationResponse.fromJson(
                json['checkReservationResponse'])
            : null,
        minimumDays = (json['minimumDays'] as num?)?.toInt(),
        isFavorite = json['isFavorite'] as bool?,
        numberAllowed = (json['numberAllowed'] as num?)?.toInt(),
        id = (json['id'] as num?)?.toInt(),
        portName = json['portName'] as String?,
        portTypeDto = json['portTypeDTO'] != null
            ? PortTypeDto.fromJson(json['portTypeDTO'])
            : null,
        accepted = json['accepted'] as bool?,
        portKey = json['portKey'] as String?,
        isAllowedForUploadFiles = json['isAllowedForUploadFiles'] as bool?,
        picturesAlbumName = json['picturesAlbumName'] as String?,
        portImages = json['portImages'],
        theMainImageFileName = json['theMainImageFileName'] as String?,
        goolgeDriveLink = json['goolgeDriveLink'] as String?,
        displayPrice = json['displayPrice'] as bool? ?? false;
}

class CheckReservationResponse {
  CheckReservationResponse({
    required this.dayIsLocked,
    required this.numberOfReservations,
    required this.numberOfConfirmedReservations,
    required this.allowedToReserveWorkTeam,
    required this.workTeamIsReserved,
    required this.allowedToReservation,
    required this.confirmationIsRequiredFromVendor,
    required this.reservationTimeAllowed,
    required this.reservationLocationAllowed, 
    required this.unreservedServices,
    required this.date,
    required this.verificationResultMessage,
    required this.verificationResult,
    required this.message,
    required this.isSuccess,
    required this.errors,
    required this.expireDate,
    required this.modelId,
  });

  final bool? dayIsLocked;
  final int? numberOfReservations;
  final int? numberOfConfirmedReservations;
  final bool? allowedToReserveWorkTeam;
  final bool? workTeamIsReserved;
  final bool? allowedToReservation;
  final bool? confirmationIsRequiredFromVendor;
  final dynamic reservationTimeAllowed;
  final dynamic reservationLocationAllowed;
  final List<dynamic>? unreservedServices;
  final DateTime? date;
  final String? verificationResultMessage;
  final int? verificationResult;
  final dynamic message;
  final bool? isSuccess;
  final dynamic errors;
  final dynamic expireDate;
  final int? modelId;

  CheckReservationResponse.fromJson(Map<String, dynamic> json)
      : dayIsLocked = json['dayIsLocked'] as bool?,
        numberOfReservations =
            (json['numberOfReservations'] as num?)?.toInt(),
        numberOfConfirmedReservations =
            (json['numberOfConfirmedReservations'] as num?)?.toInt(),
        allowedToReserveWorkTeam =
            json['allowedToReserveWorkTeam'] as bool?,
        workTeamIsReserved = json['workTeamIsReserved'] as bool?,
        allowedToReservation = json['allowedToReservation'] as bool?,
        confirmationIsRequiredFromVendor =
            json['confirmationIsRequiredFromVendor'] as bool?,
        reservationTimeAllowed = json['reservationTimeAllowed'],
        reservationLocationAllowed = json['reservationLocationAllowed'],
        unreservedServices = json['unreservedServices'] as List<dynamic>?,
        date = json['date'] != null
            ? DateTime.parse(json['date'] as String)
            : null,
        verificationResultMessage =
            json['verificationResultMessage'] as String?,
        verificationResult = (json['verificationResult'] as num?)?.toInt(),
        message = json['message'],
        isSuccess = json['isSuccess'] as bool?,
        errors = json['errors'],
        expireDate = json['expireDate'],
        modelId = (json['modelId'] as num?)?.toInt();

  /// Ids of the port services that are still free (not reserved) on [date].
  /// The backend sends them in `unreservedServices` whenever only *some* of the
  /// services can be booked (e.g. `verificationResult == 6`).
  List<int> get unreservedServiceIds => (unreservedServices ?? const [])
      .map((e) => (e as num?)?.toInt())
      .whereType<int>()
      .toList();

  /// Whether the service [serviceId] can be booked on [date].
  /// When the backend sent no per-service list we fall back to the day-level
  /// flag, so the whole day is either bookable or not.
  bool allowsService(int? serviceId) {
    final ids = unreservedServiceIds;
    if (ids.isEmpty) return allowedToReservation == true;
    return serviceId != null && ids.contains(serviceId);
  }
}

class PortTypeDto {
  PortTypeDto({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.portIcone,
    required this.portIconePath,
    required this.portCategoryId,
    required this.portCategoryNameAr,
    required this.portCategoryNameEn,
  });

  final int? id;
  final String? nameAr;
  final String? nameEn;
  final dynamic portIcone;
  final String? portIconePath;
  final int? portCategoryId;
  final String? portCategoryNameAr;
  final String? portCategoryNameEn;

  PortTypeDto.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num?)?.toInt(),
        nameAr = json['nameAr'] as String?,
        nameEn = json['nameEn'] as String?,
        portIcone = json['portIcone'],
        portIconePath = json['portIconePath'] as String?,
        portCategoryId = (json['portCategoryId'] as num?)?.toInt(),
        portCategoryNameAr = json['portCategoryNameAr'] as String?,
        portCategoryNameEn = json['portCategoryNameEn'] as String?;
}
