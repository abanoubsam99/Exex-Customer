// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'governate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Governate _$GovernateFromJson(Map<String, dynamic> json) => Governate(
      id: (json['id'] as num).toInt(),
      governorateNameEn: json['governorate_name_en'] as String,
      governorateNameAr: json['governorate_name_ar'] as String,
    );

Map<String, dynamic> _$GovernateToJson(Governate instance) => <String, dynamic>{
      'id': instance.id,
      'governorate_name_en': instance.governorateNameEn,
      'governorate_name_ar': instance.governorateNameAr,
    };
