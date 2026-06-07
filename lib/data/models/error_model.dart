class ErrorModel<T> {
  final String message;
  final int? code;
  final dynamic errors;
  final T? data;

  ErrorModel({
    this.message = 'An error occurred',
    this.code,
    this.errors,
    this.data,
  });

  factory ErrorModel.fromJson(
    Map<String, dynamic> json, [
    T Function(Object? json)? fromJsonT,
  ]) {
    return ErrorModel<T>(
      message: json['message'] as String? ?? 'An error occurred',
      code: (json['code'] as num?)?.toInt(),
      errors: json['errors'],
      data: json['data'] == null
          ? null
          : (fromJsonT != null ? fromJsonT(json['data']) : json['data'] as T?),
    );
  }

  Map<String, dynamic> toJson([Object? Function(T value)? toJsonT]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['code'] = code;
    data['errors'] = errors;
    if (this.data != null) {
      data['data'] = toJsonT != null ? toJsonT(this.data as T) : this.data;
    } else {
      data['data'] = null;
    }
    return data;
  }
}
