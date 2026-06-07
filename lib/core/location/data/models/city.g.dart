// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) => City(
      id: (json['id'] as num).toInt(),
      governorateId: (json['governorate_id'] as num).toInt(),
      cityNameEn: json['city_name_en'] as String,
      cityNameAr: json['city_name_ar'] as String,
    );

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'id': instance.id,
      'governorate_id': instance.governorateId,
      'city_name_en': instance.cityNameEn,
      'city_name_ar': instance.cityNameAr,
    };
