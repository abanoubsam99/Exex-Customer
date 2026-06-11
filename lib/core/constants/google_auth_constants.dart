/// Google OAuth client IDs (from Google Cloud console).
class GoogleAuthConstants {
  GoogleAuthConstants._();

  /// Web client id — used as `serverClientId` so Android/iOS return an idToken
  /// that the backend can verify.
  static const webClientId =
      '461662438992-u7eofcnd4hpq7uqoda6173p97i7ja2jp.apps.googleusercontent.com';

  /// iOS client id — configured in Info.plist (GIDClientID + URL scheme).
  static const iosClientId =
      '461662438992-2j5be2jf3ad7jcr3s7uquvjspf3pet25.apps.googleusercontent.com';

  /// Android client id — matched in the console via SHA-1 + package name.
  static const androidClientId =
      '461662438992-s0ntcrqj37k6kdoduhhkmus8n1vspd30.apps.googleusercontent.com';
}
