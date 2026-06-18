/// Generic envelope the backend returns for write operations
/// (add/remove favorite, etc.): `{ message, isSuccess, errors, expireDate,
/// modelId }`. Reuse this instead of mapping each endpoint to its own model.
class GeneralResponse {
  final String? message;
  final bool? isSuccess;
  final dynamic errors;
  final dynamic expireDate;
  final int? modelId;

  GeneralResponse({
    this.message,
    this.isSuccess,
    this.errors,
    this.expireDate,
    this.modelId,
  });

  GeneralResponse.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String?,
        isSuccess = json['isSuccess'] as bool?,
        errors = json['errors'],
        expireDate = json['expireDate'],
        modelId = (json['modelId'] as num?)?.toInt();
}
