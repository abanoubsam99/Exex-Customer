class City {
  final int? id;
  final int? governorateId;
  final String? cityNameEn;
  final String? cityNameAr;

  City({
    this.id,
    this.governorateId,
    this.cityNameEn,
    this.cityNameAr,
  });

  City.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num?)?.toInt(),
        governorateId = (json['governorate_id'] as num?)?.toInt(),
        cityNameEn = json['city_name_en'] as String?,
        cityNameAr = json['city_name_ar'] as String?;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'governorate_id': governorateId,
      'city_name_en': cityNameEn,
      'city_name_ar': cityNameAr,
    };
  }

  @override
  String toString() => cityNameAr ?? '';
}
