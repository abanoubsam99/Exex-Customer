class CacheKeys {
  static const String token = "token";
  static const String userType = 'userType';
  static const String userModel = "userModel";
  static const String isGuest = "isGuest";
  static const String myCards = "myCards";
  static const String isFirstTime = "isFirstTime";
  static const String userId = "userId";
  static const String isDark = "isDark";
  static const String languageCode = "languageCode";
  static const String languageName = "languageName";
  static const String countryCode = "countryCode";
  static const String themeName = "themeName";
  static const String typeAds = "typeAds";
  static const String countryName = "countryName";
  static const String countryImage = "countryImage";

  // Last home payload, cached so the home screen paints instantly on reopen
  // (stale-while-revalidate) instead of showing a shimmer for the whole fetch.
  static const String homePorts = "homePorts";
  static const String homeOffers = "homeOffers";

  // Location chosen on onboarding (reused as gov/city in the data APIs).
  static const String selectedGovId = "selectedGovId";
  static const String selectedGovName = "selectedGovName";
  static const String selectedCityId = "selectedCityId";
  static const String selectedCityName = "selectedCityName";
}
