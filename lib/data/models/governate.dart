class Governate {
  final int? id;
  final String? governorateNameEn;
  final String? governorateNameAr;

  Governate({
    this.id,
    this.governorateNameEn,
    this.governorateNameAr,
  });

  Governate.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num?)?.toInt(),
        governorateNameEn = json['governorate_name_en'] as String?,
        governorateNameAr = json['governorate_name_ar'] as String?;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'governorate_name_en': governorateNameEn,
      'governorate_name_ar': governorateNameAr,
    };
  }

  @override
  String toString() => governorateNameAr ?? '';
}
