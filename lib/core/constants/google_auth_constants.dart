/// Google OAuth client IDs (from Google Cloud console).
class GoogleAuthConstants {
  GoogleAuthConstants._();

  /// Web client id — used as `serverClientId` so Android/iOS return an idToken
  /// that the backend can verify. Its matching client secret lives on the
  /// backend only (never in the app).
  static const webClientId =
      '461662438992-laf4cf3cjci2pd02fa0bdf1o7rqdlem3.apps.googleusercontent.com';

  /// iOS client id — configured in Info.plist (GIDClientID + URL scheme).
  static const iosClientId =
      '588244655147-2cl52q5u5q9u5f5d3tv4nt8spa2r9f5e.apps.googleusercontent.com';

  /// Android client id — matched in the console via SHA-1 + package name.
  static const androidClientId =
      '588244655147-k0oj8lnttnsc9dd4lgtnd1c40jv0atu2.apps.googleusercontent.com';
}
