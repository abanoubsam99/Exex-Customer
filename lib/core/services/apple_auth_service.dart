// Apple sign-in is disabled while its dependency is commented out in
// pubspec.yaml.
//
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
//
// class AppleAuthResult {
//   final String? identityToken;
//   final String? email;
//   final String? name;
//
//   AppleAuthResult({this.identityToken, this.email, this.name});
// }
//
// class AppleAuthService {
//   Future<AppleAuthResult?> signIn() async {
//     try {
//       final credential = await SignInWithApple.getAppleIDCredential(
//         scopes: const [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//       );
//       final name = [credential.givenName, credential.familyName]
//           .where((e) => e != null && e.isNotEmpty)
//           .join(' ');
//       return AppleAuthResult(
//         identityToken: credential.identityToken,
//         email: credential.email,
//         name: name.isEmpty ? null : name,
//       );
//     } catch (_) {
//       return null;
//     }
//   }
// }
