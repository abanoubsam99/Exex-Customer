import 'package:json_annotation/json_annotation.dart';

part 'port_service.g.dart';

@JsonSerializable()
class PortService {
  int id;
  String? name;
  String? serviceKey;
  String? details;
  int? priceAfterDiscount;
  List<String>? serviceImages;
  int? price;
  int? priceBeforDiscount;
  String? picturesAlbumName;
  int? portId;

  PortService({
    required this.id,
    this.name,
    this.serviceKey,
    this.details,
    this.priceAfterDiscount,
    this.priceBeforDiscount,
    this.picturesAlbumName,
    this.serviceImages,
    this.portId,
    this.price,
  });

  factory PortService.fromJson(Map<String, dynamic> json) =>
      _$PortServiceFromJson(json);
}
