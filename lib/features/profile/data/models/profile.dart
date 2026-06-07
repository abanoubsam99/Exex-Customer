import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable(explicitToJson: true)
class Profile {
  Profile({
    required this.userId,
    required this.roles,
    required this.phoneNumber,
    required this.countryCode,
    required this.emailVerified,
    required this.phoneVerified,
    required this.isAcceptedAsVendor,
    required this.isAllowedForUploadFiles,
    required this.governorate,
    required this.city,
    required this.imageName,
    required this.userName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.agree,
  });

  final String? userId;
  final List<String>? roles;
  final String? phoneNumber;
  final String? countryCode;
  final bool? emailVerified;
  final bool? phoneVerified;
  final bool? isAcceptedAsVendor;
  final bool? isAllowedForUploadFiles;
  final String? governorate;
  final String? city;
  final dynamic imageName;
  final String? userName;
  final String? email;
  final dynamic password;
  final dynamic confirmPassword;
  final bool? agree;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}

// class Profile {
//   final int? numberOfPorts;
//   final DateTime? renewDate;
//   final DateTime? subscriptionDate;
//   final PlanDto? planDto;
//   final String? phoneNumber;
//   final String? email;
//   final int? numberOfAccounts;
//   final List<String>? roles;
//   final int? id;
//   final String? companyKey;
//   final String? name;
//   final String? governorate;
//   final String? city;
//   final String? serviceType;
//   final String? address;
//   final String? gps;
//   final String? link;
//   final String? additionalLink;
//   final String? additionalInfo;
//   final String? userId;

//   Profile({
//     this.numberOfPorts,
//     this.renewDate,
//     this.subscriptionDate,
//     this.planDto,
//     this.phoneNumber,
//     this.email,
//     this.numberOfAccounts,
//     this.roles,
//     this.id,
//     this.companyKey,
//     this.name,
//     this.governorate,
//     this.city,
//     this.serviceType,
//     this.address,
//     this.gps,
//     this.link,
//     this.additionalLink,
//     this.additionalInfo,
//     this.userId,
//   });

//   factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

//   Map<String, dynamic> toJson() => _$ProfileToJson(this);
// }

// @JsonSerializable()
// class PlanDto {
//   final int? id;
//   final String? name;
//   final dynamic details;
//   final dynamic benefits;
//   final int? price;
//   final int? period;

//   PlanDto({
//     required this.id,
//     required this.name,
//     required this.details,
//     required this.benefits,
//     required this.price,
//     required this.period,
//   });

//   factory PlanDto.fromJson(Map<String, dynamic> json) => _$PlanDtoFromJson(json);

//   Map<String, dynamic> toJson() => _$PlanDtoToJson(this);
// }
