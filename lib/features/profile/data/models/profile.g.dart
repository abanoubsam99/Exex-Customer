// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      userId: json['userId'] as String?,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
      phoneNumber: json['phoneNumber'] as String?,
      countryCode: json['countryCode'] as String?,
      emailVerified: json['emailVerified'] as bool?,
      phoneVerified: json['phoneVerified'] as bool?,
      isAcceptedAsVendor: json['isAcceptedAsVendor'] as bool?,
      isAllowedForUploadFiles: json['isAllowedForUploadFiles'] as bool?,
      governorate: json['governorate'] as String?,
      city: json['city'] as String?,
      imageName: json['imageName'],
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      password: json['password'],
      confirmPassword: json['confirmPassword'],
      agree: json['agree'] as bool?,
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'userId': instance.userId,
      'roles': instance.roles,
      'phoneNumber': instance.phoneNumber,
      'countryCode': instance.countryCode,
      'emailVerified': instance.emailVerified,
      'phoneVerified': instance.phoneVerified,
      'isAcceptedAsVendor': instance.isAcceptedAsVendor,
      'isAllowedForUploadFiles': instance.isAllowedForUploadFiles,
      'governorate': instance.governorate,
      'city': instance.city,
      'imageName': instance.imageName,
      'userName': instance.userName,
      'email': instance.email,
      'password': instance.password,
      'confirmPassword': instance.confirmPassword,
      'agree': instance.agree,
    };
