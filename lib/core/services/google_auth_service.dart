// import 'dart:io';
//
// import 'package:evex_user/core/constants/google_auth_constants.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// /// Result of a Google sign-in: the idToken (verified by the backend) plus
// /// basic profile info.
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
//     // serverClientId must be the WEB client id so Android returns an idToken.
//     serverClientId: GoogleAuthConstants.webClientId,
//     // On iOS the dedicated iOS client id is used.
//     clientId: Platform.isIOS ? GoogleAuthConstants.iosClientId : null,
//     scopes: const ['email', 'profile'],
//   );
//
//   /// Triggers the Google account picker. Returns null if the user cancels.
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
//     } catch (_) {
//       return null;
//     }
//   }
//
//   Future<void> signOut() async {
//     try {
//       await _googleSignIn.signOut();
//     } catch (_) {}
//   }
// }
