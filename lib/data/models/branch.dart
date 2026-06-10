/// A single EVEX branch/office.
/// Item of GET /api/Home/GetAllBranchs.
class Branch {
  final int? id;
  final String? name;
  final String? governorate;
  final String? cities;
  final String? address;
  final String? phoneNumber;
  final String? gps;
  final String? phoneNumber2;
  final int? officeId;
  final String? officeName;

  Branch({
    this.id,
    this.name,
    this.governorate,
    this.cities,
    this.address,
    this.phoneNumber,
    this.gps,
    this.phoneNumber2,
    this.officeId,
    this.officeName,
  });

  Branch.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num?)?.toInt(),
        name = json['name'] as String?,
        governorate = json['governorate'] as String?,
        cities = json['cities'] as String?,
        address = json['address'] as String?,
        phoneNumber = json['phoneNumber'] as String?,
        gps = json['gps'] as String?,
        phoneNumber2 = json['phoneNumber2'] as String?,
        officeId = (json['officeId'] as num?)?.toInt(),
        officeName = json['officeName'] as String?;

  /// All non-empty phone numbers for this branch.
  List<String> get phones => [phoneNumber, phoneNumber2]
      .where((p) => p != null && p.trim().isNotEmpty)
      .cast<String>()
      .toList();
}
