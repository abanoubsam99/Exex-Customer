import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthService {
  final _auth = LocalAuthentication();
  final _storage = const FlutterSecureStorage();

  // Save user credentials (you can also store JWT token or session id)
  Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'password', value: password);
  }

  // Retrieve credentials
  Future<Map<String, String?>> getCredentials() async {
    final email = await _storage.read(key: 'email');
    final password = await _storage.read(key: 'password');
    return {'email': email, 'password': password};
  }

  // Check biometric availability
  Future<bool> canUseBiometric() async {
    final canCheck = await _auth.canCheckBiometrics;
    final isSupported = await _auth.isDeviceSupported();
    return canCheck && isSupported;
  }

  // Authenticate using biometrics (fingerprint on Android, Face ID on iOS)
  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'استخدم البصمة لتسجيل الدخول',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  // Clear credentials (for logout)
  Future<void> clearCredentials() async {
    await _storage.deleteAll();
  }
}
