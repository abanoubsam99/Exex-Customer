import 'package:json_annotation/json_annotation.dart';

part 'forget_password_response.g.dart';

@JsonSerializable()
class ForgetPasswordResponse {
  String? message;
  bool? isSuccess;
  dynamic errors;
  dynamic expireDate;
  int? modelId;
  String? code;

  ForgetPasswordResponse({
    this.message,
    this.isSuccess,
    this.errors,
    this.expireDate,
    this.modelId,
    this.code,
  });

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) => _$ForgetPasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ForgetPasswordResponseToJson(this);

}