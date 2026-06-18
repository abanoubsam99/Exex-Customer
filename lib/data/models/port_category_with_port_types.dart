class PortCategoryWithPortTypes {
  PortCategoryWithPortTypes({
    required this.id,
    required this.key,
    required this.nameAr,
    required this.nameEn,
    this.icone,
    this.iconePath,
    required this.subscriptionType,
    required this.subscriptionTypeName,
    required this.portTypeDtos,
  });

  final int id;
  final String key;
  final String? nameAr;
  final String? nameEn;
  final String? icone;
  final String? iconePath;
  final int subscriptionType;
  final String subscriptionTypeName;
  final List<PortTypeDto> portTypeDtos;

  PortCategoryWithPortTypes.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num).toInt(),
        key = json['key'] as String,
        nameAr = json['nameAr'] as String?,
        nameEn = json['nameEn'] as String?,
        icone = json['icone'] as String?,
        iconePath = json['iconePath'] as String?,
        subscriptionType = (json['subscriptionType'] as num).toInt(),
        subscriptionTypeName = json['_SubscriptionType'] as String,
        portTypeDtos = (json['portTypeDtos'] as List)
            .map((e) => PortTypeDto.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['key'] = key;
    data['nameAr'] = nameAr;
    data['nameEn'] = nameEn;
    data['icone'] = icone;
    data['iconePath'] = iconePath;
    data['subscriptionType'] = subscriptionType;
    data['_SubscriptionType'] = subscriptionTypeName;
    data['portTypeDtos'] = portTypeDtos.map((e) => e.toJson()).toList();
    return data;
  }
}

class PortTypeDto {
  PortTypeDto({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.portIcone,
    this.portIconePath,
    required this.portCategoryId,
    this.portCategoryNameAr,
    this.portCategoryNameEn,
  });

  final int id;
  final String? nameAr;
  final String? nameEn;
  final String? portIcone;
  final String? portIconePath;
  final int portCategoryId;
  final String? portCategoryNameAr;
  final String? portCategoryNameEn;

  PortTypeDto.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num).toInt(),
        nameAr = json['nameAr'] as String?,
        nameEn = json['nameEn'] as String?,
        portIcone = json['portIcone'] as String?,
        portIconePath = json['portIconePath'] as String?,
        portCategoryId = (json['portCategoryId'] as num).toInt(),
        portCategoryNameAr = json['portCategoryNameAr'] as String?,
        portCategoryNameEn = json['portCategoryNameEn'] as String?;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nameAr'] = nameAr;
    data['nameEn'] = nameEn;
    data['portIcone'] = portIcone;
    data['portIconePath'] = portIconePath;
    data['portCategoryId'] = portCategoryId;
    data['portCategoryNameAr'] = portCategoryNameAr;
    data['portCategoryNameEn'] = portCategoryNameEn;
    return data;
  }
}
