class UserModel {
  UserViewModel? userViewModel;
  String? token;
  String? message;
  bool? isSuccess;
  dynamic errors;
  String? expireDate;
  int? modelId;

  UserModel({
    this.userViewModel,
    this.token,
    this.message,
    this.isSuccess,
    this.errors,
    this.expireDate,
    this.modelId,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userViewModel = json['userViewModel'] != null
        ? UserViewModel.fromJson(json['userViewModel'])
        : null;
    token = json['token'];
    message = json['message'];
    isSuccess = json['isSuccess'];
    errors = json['errors'];
    expireDate = json['expireDate'];
    modelId = json['modelId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userViewModel != null) {
      data['userViewModel'] = userViewModel!.toJson();
    }
    data['token'] = token;
    data['message'] = message;
    data['isSuccess'] = isSuccess;
    data['errors'] = errors;
    data['expireDate'] = expireDate;
    data['modelId'] = modelId;
    return data;
  }

  /// هل سجّل اليوزر رقم هاتف؟
  bool get hasPhone => userViewModel?.phoneNumber != null;

  /// هل اتأكد رقم الهاتف؟
  bool get isPhoneVerified => userViewModel?.phoneVerified ?? false;

  /// هل أكمل بيانات العميل (عنده clientId فعلي)؟
  bool get isAccountComplete =>
      (userViewModel?.clientId ?? 0) > 0;
}

class UserViewModel {
  String? userId;
  List<dynamic>? roles;
  String? phoneNumber;
  bool? emailVerified;
  bool? phoneVerified;
  bool? isAcceptedAsVendor;
  bool? isAllowedForUploadFiles;
  String? userName;
  String? email;
  dynamic password;
  dynamic confirmPassword;
  bool? agree;
  final String? governorate;
  final String? city;
  final String? imageName;
  final PlanDto? planDto;
  int? clientId;
  String? name;
  String? countryCode;
  String? address;
  String? gender;
  String? dateOfBirth;
  int? bookingsCount;

  UserViewModel({
    this.userId,
    this.roles,
    this.phoneNumber,
    this.emailVerified,
    this.phoneVerified,
    this.isAcceptedAsVendor,
    this.isAllowedForUploadFiles,
    this.userName,
    this.email,
    this.password,
    this.confirmPassword,
    this.agree,
    this.governorate,
    this.city,
    this.planDto,
    this.imageName,
    this.clientId,
    this.name,
    this.countryCode,
    this.address,
    this.gender,
    this.dateOfBirth,
    this.bookingsCount,
  });

  UserViewModel.fromJson(Map<String, dynamic> json)
      : governorate = json['governorate'],
        city = json['city'],
        imageName = json['imageName'],
        planDto =
            json['planDto'] != null ? PlanDto.fromJson(json['planDto']) : null {
    userId = json['userId'];
    roles = json['roles'];
    phoneNumber = json['phoneNumber'];
    emailVerified = json['emailVerified'];
    phoneVerified = json['phoneVerified'];
    isAcceptedAsVendor = json['isAcceptedAsVendor'];
    isAllowedForUploadFiles = json['isAllowedForUploadFiles'];
    userName = json['userName'];
    email = json['email'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
    agree = json['agree'];
    clientId = (json['clientId'] as num?)?.toInt();
    name = json['name'];
    countryCode = json['countryCode'];
    address = json['address'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'];
    bookingsCount = (json['bookingsCount'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['roles'] = roles;
    data['phoneNumber'] = phoneNumber;
    data['emailVerified'] = emailVerified;
    data['phoneVerified'] = phoneVerified;
    data['isAcceptedAsVendor'] = isAcceptedAsVendor;
    data['isAllowedForUploadFiles'] = isAllowedForUploadFiles;
    data['userName'] = userName;
    data['email'] = email;
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;
    data['agree'] = agree;
    data['governorate'] = governorate;
    data['city'] = city;
    data['imageName'] = imageName;
    data['clientId'] = clientId;
    data['name'] = name;
    data['countryCode'] = countryCode;
    data['address'] = address;
    data['gender'] = gender;
    data['dateOfBirth'] = dateOfBirth;
    data['bookingsCount'] = bookingsCount;
    if (planDto != null) {
      data['planDto'] = planDto!.toJson();
    }
    return data;
  }
}

class PlanDto {
  final int? id;
  final String? name;
  final dynamic details;
  final dynamic benefits;
  final int? price;
  final int? period;

  PlanDto({
    this.id,
    this.name,
    this.details,
    this.benefits,
    this.price,
    this.period,
  });

  PlanDto.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num?)?.toInt(),
        name = json['name'],
        details = json['details'],
        benefits = json['benefits'],
        price = (json['price'] as num?)?.toInt(),
        period = (json['period'] as num?)?.toInt();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['details'] = details;
    data['benefits'] = benefits;
    data['price'] = price;
    data['period'] = period;
    return data;
  }
}
