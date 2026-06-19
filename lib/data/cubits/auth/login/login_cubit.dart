import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
// Social sign-in services — prepared but disabled for now (hidden for the store).
// import 'package:evex_user/core/services/google_auth_service.dart';
// import 'package:evex_user/core/services/facebook_auth_service.dart';
// import 'package:evex_user/core/services/apple_auth_service.dart';
import 'package:evex_user/core/services/local_auth_service.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/models/login_request.dart';
import 'package:evex_user/data/models/user_model.dart';
import 'package:evex_user/data/repos/login_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;
  final UserService _userService;
  final LocalAuthService _localAuthService;
  // Social services — uncomment + inject when enabling social login.
  // final GoogleAuthService _googleAuthService;
  // final FacebookAuthService _facebookAuthService;
  // final AppleAuthService _appleAuthService;

  LoginCubit(
    this._loginRepo,
    this._userService,
    this._localAuthService,
    // this._googleAuthService,
    // this._facebookAuthService,
    // this._appleAuthService,
  ) : super(LoginInitial());

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// "تخطّي" — enter the app as a guest (browse-only, no account).
  Future<void> continueAsGuest() async {
    await _userService.continueAsGuest();
    NavigationHelper.pushNamedAndRemoveUntil(Routes.mainScreen);
  }

  /// Logs in using the locally stored credentials after a successful
  /// biometric check. Used by the fingerprint / Face ID button.
  Future<void> loginWithBiometrics() async {
    if (!await _localAuthService.canUseBiometric()) {
      ToastManager.showError('البصمة غير متاحة على هذا الجهاز');
      return;
    }
    final creds = await _localAuthService.getCredentials();
    final email = creds['email'];
    final password = creds['password'];
    if (email == null ||
        email.isEmpty ||
        password == null ||
        password.isEmpty) {
      ToastManager.showError('سجّل دخولك مرة أولاً لتفعيل البصمة');
      return;
    }
    final authenticated = await _localAuthService.authenticateWithBiometrics();
    if (!authenticated) return;
    // Reuse the normal login flow with the cached credentials.
    emailController.text = email;
    passwordController.text = password;
    await login();
  }

  Future<void> login() async {
    emit(LoginLoading());
    final user = await _loginRepo.login(
      LoginRequest(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ),
    );
    if (user != null) {
      await _localAuthService.saveCredentials(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      await _onLoggedIn(user);
    } else {
      emit(LoginError('فشل تسجيل الدخول'));
    }
  }

  // ─────────────────── Social sign-in (prepared, disabled) ───────────────────
  // All three flows are fully written; they're commented out so nothing social
  // ships to the store yet. To enable a provider: uncomment its service file +
  // pubspec package + this method + the button in AllSocalMediaWidget.

  // /// Sign in with Google, then exchange the idToken via /ExternalLogin.
  // Future<void> loginWithGoogle() async {
  //   final google = await _googleAuthService.signIn();
  //   if (google == null || (google.idToken ?? '').isEmpty) return; // cancelled
  //   emit(LoginLoading());
  //   final user = await _loginRepo.externalLogin(
  //     provider: 'google',
  //     token: google.idToken!,
  //     email: google.email,
  //     name: google.name,
  //   );
  //   if (user != null) {
  //     await _onLoggedIn(user);
  //   } else {
  //     emit(LoginError('فشل تسجيل الدخول بجوجل'));
  //     ToastManager.showError('تعذّر تسجيل الدخول بجوجل، حاول مرة أخرى');
  //   }
  // }

  // /// Sign in with Facebook, then exchange the accessToken via /ExternalLogin.
  // Future<void> loginWithFacebook() async {
  //   final fb = await _facebookAuthService.signIn();
  //   if (fb == null || (fb.accessToken ?? '').isEmpty) return; // cancelled
  //   emit(LoginLoading());
  //   final user = await _loginRepo.externalLogin(
  //     provider: 'facebook',
  //     token: fb.accessToken!,
  //     email: fb.email,
  //     name: fb.name,
  //   );
  //   if (user != null) {
  //     await _onLoggedIn(user);
  //   } else {
  //     emit(LoginError('فشل تسجيل الدخول بفيسبوك'));
  //     ToastManager.showError('تعذّر تسجيل الدخول بفيسبوك، حاول مرة أخرى');
  //   }
  // }

  // /// Sign in with Apple, then exchange the identityToken via /ExternalLogin.
  // Future<void> loginWithApple() async {
  //   final apple = await _appleAuthService.signIn();
  //   if (apple == null || (apple.identityToken ?? '').isEmpty) return; // cancelled
  //   emit(LoginLoading());
  //   final user = await _loginRepo.externalLogin(
  //     provider: 'apple',
  //     token: apple.identityToken!,
  //     email: apple.email,
  //     name: apple.name,
  //   );
  //   if (user != null) {
  //     await _onLoggedIn(user);
  //   } else {
  //     emit(LoginError('فشل تسجيل الدخول بأبل'));
  //     ToastManager.showError('تعذّر تسجيل الدخول بأبل، حاول مرة أخرى');
  //   }
  // }

  /// Shared post-login handling: persist the user and route to the right
  /// screen depending on the account completion state.
  Future<void> _onLoggedIn(UserModel user) async {
    await _userService.saveUser(user);
    emit(LoginSuccess());
    ToastManager.showSuccess(user.message ?? 'تم تسجيل الدخول بنجاح');
    if (!user.hasPhone) {
      NavigationHelper.pushNamedAndRemoveUntil(Routes.addPhoneScreen);
    } else if (!user.isPhoneVerified) {
      NavigationHelper.pushNamed(Routes.addPhoneOptScreen);
    } else if (!user.isAccountComplete) {
      NavigationHelper.pushNamedAndRemoveUntil(Routes.addClientScreen);
    } else {
      NavigationHelper.pushNamedAndRemoveUntil(Routes.mainScreen);
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
