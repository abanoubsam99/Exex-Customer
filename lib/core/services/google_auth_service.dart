// Google sign-in is disabled while its dependency is commented out in
// pubspec.yaml.
//
// import 'dart:io';
//
// import 'package:evex_user/core/constants/google_auth_constants.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// class GoogleAuthResult {
//   final String? idToken;
//   final String? email;
//   final String? name;
//
//   GoogleAuthResult({this.idToken, this.email, this.name});
// }
//
// class GoogleAuthService {
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     serverClientId: GoogleAuthConstants.webClientId,
//     clientId: Platform.isIOS ? GoogleAuthConstants.iosClientId : null,
//     scopes: const ['email', 'profile'],
//   );
//
//   Future<GoogleAuthResult?> signIn() async {
//     try {
//       final account = await _googleSignIn.signIn();
//       if (account == null) return null;
//       final auth = await account.authentication;
//       return GoogleAuthResult(
//         idToken: auth.idToken,
//         email: account.email,
//         name: account.displayName,
//       );
//     } on PlatformException catch (e) {
//       debugPrint('GoogleSignIn PlatformException: code=${e.code} ${e.message}');
//       rethrow;
//     } catch (e) {
//       debugPrint('GoogleSignIn error: $e');
//       rethrow;
//     }
//   }
//
//   Future<void> signOut() async {
//     try {
//       await _googleSignIn.signOut();
//     } catch (_) {}
//   }
// }
