class Profile {
  Profile({
    required this.userId,
    required this.roles,
    required this.phoneNumber,
    required this.countryCode,
    required this.emailVerified,
    required this.phoneVerified,
    required this.isAcceptedAsVendor,
    required this.isAllowedForUploadFiles,
    required this.governorate,
    required this.city,
    required this.imageName,
    required this.userName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.agree,
  });

  final String? userId;
  final List<String>? roles;
  final String? phoneNumber;
  final String? countryCode;
  final bool? emailVerified;
  final bool? phoneVerified;
  final bool? isAcceptedAsVendor;
  final bool? isAllowedForUploadFiles;
  final String? governorate;
  final String? city;
  final dynamic imageName;
  final String? userName;
  final String? email;
  final dynamic password;
  final dynamic confirmPassword;
  final bool? agree;

  Profile.fromJson(Map<String, dynamic> json)
      : userId = json['userId'] as String?,
        roles =
            (json['roles'] as List?)?.map((e) => e as String).toList(),
        phoneNumber = json['phoneNumber'] as String?,
        countryCode = json['countryCode'] as String?,
        emailVerified = json['emailVerified'] as bool?,
        phoneVerified = json['phoneVerified'] as bool?,
        isAcceptedAsVendor = json['isAcceptedAsVendor'] as bool?,
        isAllowedForUploadFiles = json['isAllowedForUploadFiles'] as bool?,
        governorate = json['governorate'] as String?,
        city = json['city'] as String?,
        imageName = json['imageName'],
        userName = json['userName'] as String?,
        email = json['email'] as String?,
        password = json['password'],
        confirmPassword = json['confirmPassword'],
        agree = json['agree'] as bool?;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['roles'] = roles;
    data['phoneNumber'] = phoneNumber;
    data['countryCode'] = countryCode;
    data['emailVerified'] = emailVerified;
    data['phoneVerified'] = phoneVerified;
    data['isAcceptedAsVendor'] = isAcceptedAsVendor;
    data['isAllowedForUploadFiles'] = isAllowedForUploadFiles;
    data['governorate'] = governorate;
    data['city'] = city;
    data['imageName'] = imageName;
    data['userName'] = userName;
    data['email'] = email;
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;
    data['agree'] = agree;
    return data;
  }
}
