class GetPortsRequest {
  /// Governorate id — sent as `Id` to /api/Ports/Filter (the location filter).
  int? id;
  int? portType;
  int? occasionId;
  int? numberAllowed;
  int? minPrice;
  int? maxPrice;
  int? index;
  int? size;
  DateTime? date;

  GetPortsRequest({
    this.id,
    this.portType,
    this.occasionId,
    this.numberAllowed,
    this.minPrice,
    this.maxPrice,
    this.index = 0,
    this.size = 20,
    this.date,
  });

  GetPortsRequest.fromJson(Map<String, dynamic> json) {
    id = (json['Id'] ?? json['id']) is num
        ? (json['Id'] ?? json['id'] as num).toInt()
        : null;
    portType = (json['portType'] as num?)?.toInt();
    occasionId = (json['occasionId'] as num?)?.toInt();
    numberAllowed = (json['numberAllowed'] as num?)?.toInt();
    minPrice = (json['minPrice'] as num?)?.toInt();
    maxPrice = (json['maxPrice'] as num?)?.toInt();
    index = (json['index'] as num?)?.toInt();
    size = (json['size'] as num?)?.toInt();
    date = json['date'] != null ? DateTime.parse(json['date'] as String) : null;
  }

  // Mirrors json_serializable(includeIfNull: false): null fields are omitted.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['Id'] = id;
    if (portType != null) data['portType'] = portType;
    if (occasionId != null) data['occasionId'] = occasionId;
    if (numberAllowed != null) data['numberAllowed'] = numberAllowed;
    if (minPrice != null) data['minPrice'] = minPrice;
    if (maxPrice != null) data['maxPrice'] = maxPrice;
    if (index != null) data['index'] = index;
    if (size != null) data['size'] = size;
    if (date != null) data['date'] = date!.toIso8601String();
    return data;
  }
}
