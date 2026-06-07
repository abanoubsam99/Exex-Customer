import 'package:json_annotation/json_annotation.dart';

part 'add_client_response.g.dart';

@JsonSerializable()
class AddClientResponse {
  final String message;
  final int modelId;

  AddClientResponse(this.message, this.modelId);

  factory AddClientResponse.fromJson(Map<String, dynamic> json) =>
      _$AddClientResponseFromJson(json);
}
