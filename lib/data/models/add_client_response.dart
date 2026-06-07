class AddClientResponse {
  final String message;
  final int modelId;

  AddClientResponse(this.message, this.modelId);

  AddClientResponse.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String? ?? '',
        modelId = (json['modelId'] as num?)?.toInt() ?? 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['modelId'] = modelId;
    return data;
  }
}
