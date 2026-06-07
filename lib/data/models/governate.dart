class Governate {
  final int id;
  final String governorateNameEn;
  final String governorateNameAr;

  Governate({
    required this.id,
    required this.governorateNameEn,
    required this.governorateNameAr,
  });

  Governate.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num).toInt(),
        governorateNameEn = json['governorate_name_en'] as String,
        governorateNameAr = json['governorate_name_ar'] as String;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['governorate_name_en'] = governorateNameEn;
    data['governorate_name_ar'] = governorateNameAr;
    return data;
  }
}
