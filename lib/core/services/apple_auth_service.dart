import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthResult {
  final String? identityToken;
  final String? email;
  final String? name;

  AppleAuthResult({this.identityToken, this.email, this.name});
}

/// Apple sign-in (iOS). Apple only sends the email and full name on the very
/// first authorization for an app — later sign-ins return the identityToken
/// alone, so the backend must key the account off the token's `sub`.
class AppleAuthService {
  /// Returns null when the user cancels the sheet. Any other failure is
  /// rethrown so the caller can show why it failed.
  Future<AppleAuthResult?> signIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final name = [credential.givenName, credential.familyName]
          .where((e) => e != null && e.isNotEmpty)
          .join(' ');
      return AppleAuthResult(
        identityToken: credential.identityToken,
        email: credential.email,
        name: name.isEmpty ? null : name,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) return null;
      rethrow;
    }
  }
}
