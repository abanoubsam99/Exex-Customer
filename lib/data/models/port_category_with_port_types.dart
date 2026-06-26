class PortCategoryWithPortTypes {
  PortCategoryWithPortTypes({
    required this.id,
    this.key,
    this.nameAr,
    this.nameEn,
    this.icone,
    this.iconePath,
    this.subscriptionType,
    this.subscriptionTypeName,
    this.portTypeDtos = const [],
  });

  final int? id;
  final String? key;
  final String? nameAr;
  final String? nameEn;
  final String? icone;
  final String? iconePath;
  final int? subscriptionType;
  final String? subscriptionTypeName;
  final List<PortTypeDto> portTypeDtos;

  PortCategoryWithPortTypes.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num?)?.toInt(),
        key = json['key'] as String?,
        nameAr = json['nameAr'] as String?,
        nameEn = json['nameEn'] as String?,
        icone = json['icone'] as String?,
        iconePath = json['iconePath'] as String?,
        subscriptionType = (json['subscriptionType'] as num?)?.toInt(),
        subscriptionTypeName = json['_SubscriptionType'] as String?,
        portTypeDtos = (json['portTypeDtos'] as List?)
                ?.map((e) => PortTypeDto.fromJson(e))
                .toList() ??
            const [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'icone': icone,
      'iconePath': iconePath,
      'subscriptionType': subscriptionType,
      '_SubscriptionType': subscriptionTypeName,
      'portTypeDtos': portTypeDtos.map((e) => e.toJson()).toList(),
    };
  }
}

class PortTypeDto {
  PortTypeDto({
    required this.id,
    this.nameAr,
    this.nameEn,
    this.portIcone,
    this.portIconePath,
    this.portCategoryId,
    this.portCategoryNameAr,
    this.portCategoryNameEn,
  });

  final int? id;
  final String? nameAr;
  final String? nameEn;
  final String? portIcone;
  final String? portIconePath;
  final int? portCategoryId;
  final String? portCategoryNameAr;
  final String? portCategoryNameEn;

  PortTypeDto.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num?)?.toInt(),
        nameAr = json['nameAr'] as String?,
        nameEn = json['nameEn'] as String?,
        portIcone = json['portIcone'] as String?,
        portIconePath = json['portIconePath'] as String?,
        portCategoryId = (json['portCategoryId'] as num?)?.toInt(),
        portCategoryNameAr = json['portCategoryNameAr'] as String?,
        portCategoryNameEn = json['portCategoryNameEn'] as String?;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'portIcone': portIcone,
      'portIconePath': portIconePath,
      'portCategoryId': portCategoryId,
      'portCategoryNameAr': portCategoryNameAr,
      'portCategoryNameEn': portCategoryNameEn,
    };
  }
}
