class City {
  final int id;
  final int governorateId;
  final String cityNameEn;
  final String cityNameAr;

  City({
    required this.id,
    required this.governorateId,
    required this.cityNameEn,
    required this.cityNameAr,
  });

  City.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num).toInt(),
        governorateId = (json['governorate_id'] as num).toInt(),
        cityNameEn = json['city_name_en'] as String,
        cityNameAr = json['city_name_ar'] as String;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['governorate_id'] = governorateId;
    data['city_name_en'] = cityNameEn;
    data['city_name_ar'] = cityNameAr;
    return data;
  }
}
