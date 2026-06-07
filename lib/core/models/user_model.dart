import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  UserViewModel? userViewModel;
  String? token;
  String? message;
  bool? isSuccess;
  dynamic errors;
  String? expireDate;
  int? modelId;

  UserModel({
    this.userViewModel,
    this.token,
    this.message,
    this.isSuccess,
    this.errors,
    this.expireDate,
    this.modelId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class UserViewModel {
  String? userId;
  List<dynamic>? roles;
  String? phoneNumber;
  bool? emailVerified;
  bool? phoneVerified;
  bool? isAcceptedAsVendor;
  bool? isAllowedForUploadFiles;
  String? userName;
  String? email;
  dynamic password;
  dynamic confirmPassword;
  bool? agree;

  final String? governorate;
  final String? city;
  final String? imageName;
  final PlanDto? planDto;

  UserViewModel({
    this.userId,
    this.roles,
    this.phoneNumber,
    this.emailVerified,
    this.phoneVerified,
    this.isAcceptedAsVendor,
    this.isAllowedForUploadFiles,
    this.userName,
    this.email,
    this.password,
    this.confirmPassword,
    this.agree,
    this.governorate,
    this.city,
    this.planDto,
    this.imageName,
  });

  factory UserViewModel.fromJson(Map<String, dynamic> json) =>
      _$UserViewModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserViewModelToJson(this);
}

@JsonSerializable()
class PlanDto {
  final int? id;
  final String? name;
  final dynamic details;
  final dynamic benefits;
  final int? price;
  final int? period;

  PlanDto({
    required this.id,
    required this.name,
    required this.details,
    required this.benefits,
    required this.price,
    required this.period,
  });

  factory PlanDto.fromJson(Map<String, dynamic> json) =>
      _$PlanDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PlanDtoToJson(this);
}
