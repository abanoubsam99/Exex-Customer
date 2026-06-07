import 'package:json_annotation/json_annotation.dart';

part 'city.g.dart';

@JsonSerializable()
class City {
  final int id;
  @JsonKey(name: 'governorate_id')
  final int governorateId;
  @JsonKey(name: 'city_name_en')
  final String cityNameEn;
  @JsonKey(name: 'city_name_ar')
  final String cityNameAr;
  // @JsonKey(name: 'appoint_price')
  // int? price;

  City({
    required this.id,
    required this.governorateId,
    required this.cityNameEn,
    required this.cityNameAr,
  });

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}
