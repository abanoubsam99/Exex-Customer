// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userViewModel: json['userViewModel'] == null
          ? null
          : UserViewModel.fromJson(
              json['userViewModel'] as Map<String, dynamic>),
      token: json['token'] as String?,
      message: json['message'] as String?,
      isSuccess: json['isSuccess'] as bool?,
      errors: json['errors'],
      expireDate: json['expireDate'] as String?,
      modelId: (json['modelId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'userViewModel': instance.userViewModel,
      'token': instance.token,
      'message': instance.message,
      'isSuccess': instance.isSuccess,
      'errors': instance.errors,
      'expireDate': instance.expireDate,
      'modelId': instance.modelId,
    };

UserViewModel _$UserViewModelFromJson(Map<String, dynamic> json) =>
    UserViewModel(
      userId: json['userId'] as String?,
      roles: json['roles'] as List<dynamic>?,
      phoneNumber: json['phoneNumber'] as String?,
      emailVerified: json['emailVerified'] as bool?,
      phoneVerified: json['phoneVerified'] as bool?,
      isAcceptedAsVendor: json['isAcceptedAsVendor'] as bool?,
      isAllowedForUploadFiles: json['isAllowedForUploadFiles'] as bool?,
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      password: json['password'],
      confirmPassword: json['confirmPassword'],
      agree: json['agree'] as bool?,
      governorate: json['governorate'] as String?,
      city: json['city'] as String?,
      planDto: json['planDto'] == null
          ? null
          : PlanDto.fromJson(json['planDto'] as Map<String, dynamic>),
      imageName: json['imageName'] as String?,
    );

Map<String, dynamic> _$UserViewModelToJson(UserViewModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'roles': instance.roles,
      'phoneNumber': instance.phoneNumber,
      'emailVerified': instance.emailVerified,
      'phoneVerified': instance.phoneVerified,
      'isAcceptedAsVendor': instance.isAcceptedAsVendor,
      'isAllowedForUploadFiles': instance.isAllowedForUploadFiles,
      'userName': instance.userName,
      'email': instance.email,
      'password': instance.password,
      'confirmPassword': instance.confirmPassword,
      'agree': instance.agree,
      'governorate': instance.governorate,
      'city': instance.city,
      'imageName': instance.imageName,
      'planDto': instance.planDto,
    };

PlanDto _$PlanDtoFromJson(Map<String, dynamic> json) => PlanDto(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      details: json['details'],
      benefits: json['benefits'],
      price: (json['price'] as num?)?.toInt(),
      period: (json['period'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PlanDtoToJson(PlanDto instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'details': instance.details,
      'benefits': instance.benefits,
      'price': instance.price,
      'period': instance.period,
    };
