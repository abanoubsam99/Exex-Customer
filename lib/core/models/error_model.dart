import 'package:json_annotation/json_annotation.dart';

part 'error_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ErrorModel<T> {
  @JsonKey(defaultValue: 'An error occurred')
  final String message;
  final int? code;
  final dynamic errors;
  final T? data;

  ErrorModel({required this.message, this.code, this.errors, this.data});

  factory ErrorModel.fromJson(
    Map<String, dynamic> json, [
    T Function(Object? json)? fromJsonT,
  ]) => _$ErrorModelFromJson(json, fromJsonT ?? (x) => x as T);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ErrorModelToJson(this, toJsonT);
}
