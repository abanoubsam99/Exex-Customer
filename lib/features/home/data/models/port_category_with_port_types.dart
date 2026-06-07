import 'package:json_annotation/json_annotation.dart';

part 'port_category_with_port_types.g.dart';

@JsonSerializable()
class PortCategoryWithPortTypes {
  PortCategoryWithPortTypes({
    required this.id,
    required this.key,
    required this.nameAr,
    required this.nameEn,
    this.icone,
    this.iconePath,
    required this.subscriptionType,
    required this.subscriptionTypeName,
    required this.portTypeDtos,
  });

  final int id;
  final String key;
  final String nameAr;
  final String nameEn;
  final String? icone;
  final String? iconePath;
  final int subscriptionType;
  @JsonKey(name: '_SubscriptionType')
  final String subscriptionTypeName;
  final List<PortTypeDto> portTypeDtos;

  factory PortCategoryWithPortTypes.fromJson(Map<String, dynamic> json) =>
      _$PortCategoryWithPortTypesFromJson(json);
}

@JsonSerializable()
class PortTypeDto {
  PortTypeDto({
    required this.id,
    required this.nameAr,
    required this.nameEn,
     this.portIcone,
     this.portIconePath,
    required this.portCategoryId,
     this.portCategoryNameAr,
     this.portCategoryNameEn,
  });

  final int id;
  final String nameAr;
  final String nameEn;
  final String? portIcone;
  final String? portIconePath;
  final int portCategoryId;
  final String? portCategoryNameAr;
  final String? portCategoryNameEn;

  factory PortTypeDto.fromJson(Map<String, dynamic> json) =>
      _$PortTypeDtoFromJson(json);

}
