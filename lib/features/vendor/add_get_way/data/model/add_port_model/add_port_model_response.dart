class AddPortModelResponse {
  final String message;
  final bool isSuccess;
  final dynamic errors;
  final DateTime? expireDate;
  final int modelId;

  AddPortModelResponse({
    required this.message,
    required this.isSuccess,
    this.errors,
    this.expireDate,
    required this.modelId,
  });

  /// لتحويل JSON إلى كائن Dart
  factory AddPortModelResponse.fromJson(Map<String, dynamic> json) {
    return AddPortModelResponse(
      message: json['message'] as String,
      isSuccess: json['isSuccess'] as bool,
      errors: json['errors'], // قد تحتاج لتحديد نوعها لاحقًا
      expireDate: json['expireDate'] != null
          ? DateTime.parse(json['expireDate'])
          : null,
      modelId: json['modelId'] as int,
    );
  }

  /// لتحويل كائن Dart إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'isSuccess': isSuccess,
      'errors': errors,
      'expireDate': expireDate?.toIso8601String(),
      'modelId': modelId,
    };
  }
}
