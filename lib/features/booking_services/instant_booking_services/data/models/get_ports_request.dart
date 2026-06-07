import 'package:json_annotation/json_annotation.dart';

part 'get_ports_request.g.dart';

@JsonSerializable(includeIfNull: false)
class GetPortsRequest {
  int? portType;
  int? occasionId;
  int? numberAllowed;
  int? minPrice;
  int? maxPrice;
  int? index;
  int? size;
  DateTime? date;

  GetPortsRequest({
    this.portType,
    this.occasionId,
    this.numberAllowed,
    this.minPrice,
    this.maxPrice,
    this.index = 0,
    this.size = 20,
    this.date,
  });

  // factory GetPortsRequest.fromJson(Map<String, dynamic> json) => _$GetPortsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetPortsRequestToJson(this);
}
