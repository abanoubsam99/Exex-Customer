/// EVEX contact info + social media links.
/// GET /api/Home/GetEVEXContactInfoAndSocialMedia
class ContactInfo {
  final String? phoneNumber;
  final String? whatsappNumber;
  final String? email;
  final String? facebook;
  final String? xAccount;
  final String? instagram;
  final String? youtube;
  final String? tiktok;

  ContactInfo({
    this.phoneNumber,
    this.whatsappNumber,
    this.email,
    this.facebook,
    this.xAccount,
    this.instagram,
    this.youtube,
    this.tiktok,
  });

  ContactInfo.fromJson(Map<String, dynamic> json)
      : phoneNumber = json['phoneNumber'] as String?,
        whatsappNumber = json['whatsappNumber'] as String?,
        email = json['email'] as String?,
        facebook = json['facebook'] as String?,
        xAccount = json['xAccount'] as String?,
        instagram = json['instagram'] as String?,
        youtube = json['youtube'] as String?,
        tiktok = json['tiktok'] as String?;

  Map<String, dynamic> toJson() => {
        'phoneNumber': phoneNumber,
        'whatsappNumber': whatsappNumber,
        'email': email,
        'facebook': facebook,
        'xAccount': xAccount,
        'instagram': instagram,
        'youtube': youtube,
        'tiktok': tiktok,
      };
}
