/// Client wallet data.
/// GET /api/Clients/GetMyClientWalletData
class ClientWalletData {
  final int? clientId;
  final String? clientName;
  final String? phoneNumber;
  final String? countryCode;
  final String? clientKey;
  final int? numberOfPoints;
  final num? pointsValue;

  /// Whether the client has already set/changed their wallet PIN.
  /// When false, the wallet screen prompts them to create one.
  final bool? passwordChanged;

  ClientWalletData({
    this.clientId,
    this.clientName,
    this.phoneNumber,
    this.countryCode,
    this.clientKey,
    this.numberOfPoints,
    this.pointsValue,
    this.passwordChanged,
  });

  ClientWalletData.fromJson(Map<String, dynamic> json)
      : clientId = (json['clientId'] as num?)?.toInt(),
        clientName = json['clientName'] as String?,
        phoneNumber = json['phoneNumber'] as String?,
        countryCode = json['countryCode'] as String?,
        clientKey = json['clientKey'] as String?,
        numberOfPoints = (json['numberOfPoints'] as num?)?.toInt(),
        pointsValue = json['pointsValue'] as num?,
        passwordChanged = json['passwordChanged'] as bool?;
}
