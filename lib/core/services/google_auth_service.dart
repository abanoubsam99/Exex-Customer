import 'package:evex_user/core/constants/google_auth_constants.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthResult {
  final String? idToken;
  final String? email;
  final String? name;

  GoogleAuthResult({this.idToken, this.email, this.name});
}

/// Google sign-in (Android). Written against google_sign_in 7.x, where the
/// plugin is a singleton that must be initialized once before any other call,
/// and `authenticate()` throws instead of returning null.
class GoogleAuthService {
  bool _initialized = false;

  /// `initialize` must be awaited exactly once per app run — calling it twice is
  /// undefined behaviour per the plugin docs, hence the guard.
  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    // serverClientId = the WEB client id. It's what makes Android return an
    // idToken the backend can verify; the Android client is matched in the
    // console by SHA-1 + package name, not passed here.
    await GoogleSignIn.instance.initialize(
      serverClientId: GoogleAuthConstants.webClientId,
    );
    _initialized = true;
  }

  /// Returns null when the user backs out of the account picker. Any other
  /// failure (misconfigured client, network) is rethrown so the caller can
  /// surface it instead of failing silently.
  Future<GoogleAuthResult?> signIn() async {
    await _ensureInitialized();
    try {
      final account = await GoogleSignIn.instance.authenticate();
      return GoogleAuthResult(
        idToken: account.authentication.idToken,
        email: account.email,
        name: account.displayName,
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _ensureInitialized();
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
  }
}
