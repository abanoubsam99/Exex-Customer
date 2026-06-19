// Facebook sign-in — fully prepared but disabled for now (hidden for the store).
// To enable: uncomment this file, add `flutter_facebook_auth` to pubspec, do the
// Android/iOS platform setup, then wire it in LoginCubit + the router.
//
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
//
// /// Result of a Facebook sign-in: the access token (verified by the backend)
// /// plus basic profile info.
// class FacebookAuthResult {
//   final String? accessToken;
//   final String? email;
//   final String? name;
//
//   FacebookAuthResult({this.accessToken, this.email, this.name});
// }
//
// class FacebookAuthService {
//   /// Opens the Facebook login dialog. Returns null if the user cancels.
//   Future<FacebookAuthResult?> signIn() async {
//     try {
//       final result = await FacebookAuth.instance.login(
//         permissions: const ['email', 'public_profile'],
//       );
//       if (result.status != LoginStatus.success || result.accessToken == null) {
//         return null;
//       }
//       final data = await FacebookAuth.instance.getUserData(
//         fields: 'email,name',
//       );
//       return FacebookAuthResult(
//         accessToken: result.accessToken!.tokenString,
//         email: data['email'] as String?,
//         name: data['name'] as String?,
//       );
//     } catch (_) {
//       return null;
//     }
//   }
//
//   Future<void> signOut() async {
//     try {
//       await FacebookAuth.instance.logOut();
//     } catch (_) {}
//   }
// }
