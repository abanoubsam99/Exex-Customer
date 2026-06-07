import 'package:json_annotation/json_annotation.dart';

part 'ports_respond_model.g.dart';

@JsonSerializable(createToJson: false)
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

    factory PortsRespondModel.fromJson(Map<String, dynamic> json) => _$PortsRespondModelFromJson(json);

}

@JsonSerializable(createToJson: false)
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
        required this.id,
        required this.portName,
        required this.portTypeDto,
        required this.accepted,
        required this.portKey,
        required this.isAllowedForUploadFiles,
        required this.picturesAlbumName,
        required this.portImages,
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
    final int? id;
    final String? portName;

    @JsonKey(name: 'portTypeDTO') 
    final PortTypeDto? portTypeDto;
    final bool? accepted;
    final String? portKey;
    final bool? isAllowedForUploadFiles;
    final String? picturesAlbumName;
    final dynamic portImages;

    factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

}

@JsonSerializable(createToJson: false)
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

    factory CheckReservationResponse.fromJson(Map<String, dynamic> json) => _$CheckReservationResponseFromJson(json);

}

@JsonSerializable(createToJson: false)
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

    factory PortTypeDto.fromJson(Map<String, dynamic> json) => _$PortTypeDtoFromJson(json);

}
