import 'package:json_annotation/json_annotation.dart';

part 'governate.g.dart';

@JsonSerializable()
class Governate {
  final int id;
  @JsonKey(name: 'governorate_name_en')
  final String governorateNameEn;
  @JsonKey(name: 'governorate_name_ar')
  final String governorateNameAr;
  // @JsonKey(name: 'appoint_price')
  // int? price;

  Governate({required this.id, required this.governorateNameEn, required this.governorateNameAr});

  factory Governate.fromJson(Map<String, dynamic> json) => _$GovernateFromJson(json);
}
