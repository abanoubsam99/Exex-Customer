// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ports_respond_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortsRespondModel _$PortsRespondModelFromJson(Map<String, dynamic> json) =>
    PortsRespondModel(
      index: (json['index'] as num?)?.toInt(),
      size: (json['size'] as num?)?.toInt(),
      count: (json['count'] as num?)?.toInt(),
      pages: (json['pages'] as num?)?.toInt(),
      from: (json['from'] as num?)?.toInt(),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasPrevious: json['hasPrevious'] as bool?,
      hasNext: json['hasNext'] as bool?,
    );

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      cheapestServicePrice: (json['cheapestServicePrice'] as num?)?.toInt(),
      portDescription: json['portDescription'],
      rate: (json['rate'] as num?)?.toInt(),
      companyId: (json['companyId'] as num?)?.toInt(),
      lastUpdateDate: json['lastUpdateDate'] == null
          ? null
          : DateTime.parse(json['lastUpdateDate'] as String),
      periodEditingServices: (json['periodEditingServices'] as num?)?.toInt(),
      periodEditingDateAndLocaltion:
          (json['periodEditingDateAndLocaltion'] as num?)?.toInt(),
      cancellationPeriod: (json['cancellationPeriod'] as num?)?.toInt(),
      costOfModifyingServicesAfterPeriod:
          (json['costOfModifyingServicesAfterPeriod'] as num?)?.toInt(),
      costOfModifyingServicesBeforePeriod:
          (json['costOfModifyingServicesBeforePeriod'] as num?)?.toInt(),
      costOfModifyingDateAndLocationAfterPeriod:
          (json['costOfModifyingDateAndLocationAfterPeriod'] as num?)?.toInt(),
      costOfModifyingDateAndLocationBeforePeriod:
          (json['costOfModifyingDateAndLocationBeforePeriod'] as num?)?.toInt(),
      costOfCancellationAfterPeriod:
          (json['costOfCancellationAfterPeriod'] as num?)?.toInt(),
      costOfCancellationBeforePeriod:
          (json['costOfCancellationBeforePeriod'] as num?)?.toInt(),
      otherPolicies: json['otherPolicies'],
      governorate: json['governorate'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      gps: json['gps'] as String?,
      phoneNumber1: json['phoneNumber1'] as String?,
      phoneNumber2: json['phoneNumber2'] as String?,
      openingTime: json['openingTime'] as String?,
      closingTime: json['closingTime'] as String?,
      workDays: json['workDays'] as String?,
      checkReservationResponse: json['checkReservationResponse'] == null
          ? null
          : CheckReservationResponse.fromJson(
              json['checkReservationResponse'] as Map<String, dynamic>),
      id: (json['id'] as num?)?.toInt(),
      portName: json['portName'] as String?,
      portTypeDto: json['portTypeDTO'] == null
          ? null
          : PortTypeDto.fromJson(json['portTypeDTO'] as Map<String, dynamic>),
      accepted: json['accepted'] as bool?,
      portKey: json['portKey'] as String?,
      isAllowedForUploadFiles: json['isAllowedForUploadFiles'] as bool?,
      picturesAlbumName: json['picturesAlbumName'] as String?,
      portImages: json['portImages'],
    );

CheckReservationResponse _$CheckReservationResponseFromJson(
        Map<String, dynamic> json) =>
    CheckReservationResponse(
      dayIsLocked: json['dayIsLocked'] as bool?,
      numberOfReservations: (json['numberOfReservations'] as num?)?.toInt(),
      numberOfConfirmedReservations:
          (json['numberOfConfirmedReservations'] as num?)?.toInt(),
      allowedToReserveWorkTeam: json['allowedToReserveWorkTeam'] as bool?,
      workTeamIsReserved: json['workTeamIsReserved'] as bool?,
      allowedToReservation: json['allowedToReservation'] as bool?,
      confirmationIsRequiredFromVendor:
          json['confirmationIsRequiredFromVendor'] as bool?,
      reservationTimeAllowed: json['reservationTimeAllowed'],
      reservationLocationAllowed: json['reservationLocationAllowed'],
      unreservedServices: json['unreservedServices'] as List<dynamic>?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      verificationResultMessage: json['verificationResultMessage'] as String?,
      verificationResult: (json['verificationResult'] as num?)?.toInt(),
      message: json['message'],
      isSuccess: json['isSuccess'] as bool?,
      errors: json['errors'],
      expireDate: json['expireDate'],
      modelId: (json['modelId'] as num?)?.toInt(),
    );

PortTypeDto _$PortTypeDtoFromJson(Map<String, dynamic> json) => PortTypeDto(
      id: (json['id'] as num?)?.toInt(),
      nameAr: json['nameAr'] as String?,
      nameEn: json['nameEn'] as String?,
      portIcone: json['portIcone'],
      portIconePath: json['portIconePath'] as String?,
      portCategoryId: (json['portCategoryId'] as num?)?.toInt(),
      portCategoryNameAr: json['portCategoryNameAr'] as String?,
      portCategoryNameEn: json['portCategoryNameEn'] as String?,
    );
