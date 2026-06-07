// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_client_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddClientResponse _$AddClientResponseFromJson(Map<String, dynamic> json) =>
    AddClientResponse(
      json['message'] as String,
      (json['modelId'] as num).toInt(),
    );

Map<String, dynamic> _$AddClientResponseToJson(AddClientResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'modelId': instance.modelId,
    };
