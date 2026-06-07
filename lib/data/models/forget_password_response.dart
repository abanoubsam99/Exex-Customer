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

  ForgetPasswordResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    isSuccess = json['isSuccess'];
    errors = json['errors'];
    expireDate = json['expireDate'];
    modelId = (json['modelId'] as num?)?.toInt();
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['isSuccess'] = isSuccess;
    data['errors'] = errors;
    data['expireDate'] = expireDate;
    data['modelId'] = modelId;
    data['code'] = code;
    return data;
  }
}
