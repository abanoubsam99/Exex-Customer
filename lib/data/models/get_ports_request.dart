import 'package:evex_user/core/helpers/date_format_helper.dart';

class GetPortsRequest {
  /// Generic filter id sent as `Id` to /api/Ports/Filter.
  int? id;
  int? portType;
  int? occasionId;
  int? numberAllowed;
  int? minPrice;
  int? maxPrice;
  int? index;
  int? size;
  DateTime? date;

  /// Location filter (governorate / city names) — defaults to the user's saved
  /// onboarding location, overridable from the filter sheet.
  String? gov;
  String? city;
  int? companyId;
  bool? fav;

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
    this.gov,
    this.city,
    this.companyId,
    this.fav,
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
    gov = json['gov'] as String?;
    city = json['city'] as String?;
    companyId = (json['companyId'] as num?)?.toInt();
    fav = json['fav'] as bool?;
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
    if (date != null) data['date'] = DateFormatHelper.apiDate(date!);
    if ((gov ?? '').isNotEmpty) data['gov'] = gov;
    if ((city ?? '').isNotEmpty) data['city'] = city;
    if (companyId != null) data['companyId'] = companyId;
    if (fav != null) data['fav'] = fav;
    return data;
  }
}
