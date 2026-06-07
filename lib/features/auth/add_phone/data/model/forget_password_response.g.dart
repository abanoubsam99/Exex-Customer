// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forget_password_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgetPasswordResponse _$ForgetPasswordResponseFromJson(
        Map<String, dynamic> json) =>
    ForgetPasswordResponse(
      message: json['message'] as String?,
      isSuccess: json['isSuccess'] as bool?,
      errors: json['errors'],
      expireDate: json['expireDate'],
      modelId: (json['modelId'] as num?)?.toInt(),
      code: json['code'] as String?,
    );

Map<String, dynamic> _$ForgetPasswordResponseToJson(
        ForgetPasswordResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'isSuccess': instance.isSuccess,
      'errors': instance.errors,
      'expireDate': instance.expireDate,
      'modelId': instance.modelId,
      'code': instance.code,
    };
