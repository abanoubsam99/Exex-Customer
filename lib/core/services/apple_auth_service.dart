import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Result of an Apple sign-in: the identityToken (verified by the backend)
/// plus basic profile info (name/email are only returned on first sign-in).
class AppleAuthResult {
  final String? identityToken;
  final String? email;
  final String? name;

  AppleAuthResult({this.identityToken, this.email, this.name});
}

class AppleAuthService {
  /// Opens the native Apple sign-in sheet. Returns null if the user cancels.
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
    } catch (_) {
      return null;
    }
  }
}
