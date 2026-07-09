import 'dart:io';

import 'package:evex_user/core/constants/google_auth_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Result of a Google sign-in: the idToken (verified by the backend) plus
/// basic profile info.
class GoogleAuthResult {
  final String? idToken;
  final String? email;
  final String? name;

  GoogleAuthResult({this.idToken, this.email, this.name});
}

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // serverClientId must be the WEB client id so Android returns an idToken.
    serverClientId: GoogleAuthConstants.webClientId,
    // On iOS the dedicated iOS client id is used.
    clientId: Platform.isIOS ? GoogleAuthConstants.iosClientId : null,
    scopes: const ['email', 'profile'],
  );

  /// Triggers the Google account picker. Returns null only when the user
  /// cancels. Any real failure is rethrown so the caller can surface it instead
  /// of the sign-in dying silently after an account is picked.
  Future<GoogleAuthResult?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null; // user dismissed the picker
      final auth = await account.authentication;
      return GoogleAuthResult(
        idToken: auth.idToken,
        email: account.email,
        name: account.displayName,
      );
    } on PlatformException catch (e) {
      // code '10' = DEVELOPER_ERROR: the installed build's SHA-1/SHA-256 isn't
      // registered for this OAuth client (package com.evex.evexuser) in Google
      // Cloud console — the usual cause of "pick account → nothing happens".
      debugPrint('GoogleSignIn PlatformException: code=${e.code} ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('GoogleSignIn error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }
}
