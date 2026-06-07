// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'port_category_with_port_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortCategoryWithPortTypes _$PortCategoryWithPortTypesFromJson(
        Map<String, dynamic> json) =>
    PortCategoryWithPortTypes(
      id: (json['id'] as num).toInt(),
      key: json['key'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      icone: json['icone'] as String?,
      iconePath: json['iconePath'] as String?,
      subscriptionType: (json['subscriptionType'] as num).toInt(),
      subscriptionTypeName: json['_SubscriptionType'] as String,
      portTypeDtos: (json['portTypeDtos'] as List<dynamic>)
          .map((e) => PortTypeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PortCategoryWithPortTypesToJson(
        PortCategoryWithPortTypes instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'icone': instance.icone,
      'iconePath': instance.iconePath,
      'subscriptionType': instance.subscriptionType,
      '_SubscriptionType': instance.subscriptionTypeName,
      'portTypeDtos': instance.portTypeDtos,
    };

PortTypeDto _$PortTypeDtoFromJson(Map<String, dynamic> json) => PortTypeDto(
      id: (json['id'] as num).toInt(),
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      portIcone: json['portIcone'] as String?,
      portIconePath: json['portIconePath'] as String?,
      portCategoryId: (json['portCategoryId'] as num).toInt(),
      portCategoryNameAr: json['portCategoryNameAr'] as String?,
      portCategoryNameEn: json['portCategoryNameEn'] as String?,
    );

Map<String, dynamic> _$PortTypeDtoToJson(PortTypeDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'portIcone': instance.portIcone,
      'portIconePath': instance.portIconePath,
      'portCategoryId': instance.portCategoryId,
      'portCategoryNameAr': instance.portCategoryNameAr,
      'portCategoryNameEn': instance.portCategoryNameEn,
    };
