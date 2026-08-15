abstract class ForgetPasswordState {}

class ForgetPasswordInitial extends ForgetPasswordState {}

class ForgetPasswordLoading extends ForgetPasswordState {}

class ForgetPasswordSent extends ForgetPasswordState {
  final String phone;
  ForgetPasswordSent(this.phone);
}

class ForgetPasswordError extends ForgetPasswordState {
  final String message;
  ForgetPasswordError(this.message);
}

class OtpForgetTimerTick extends ForgetPasswordState {
  final int seconds;
  final bool isValid;

  /// True while a "resend code" request is in flight, so the resend button can
  /// show progress and reject a second tap.
  final bool isResending;

  OtpForgetTimerTick({
    required this.seconds,
    required this.isValid,
    this.isResending = false,
  });
}

class ResetPasswordLoading extends ForgetPasswordState {}

class ResetPasswordSuccess extends ForgetPasswordState {}

class ResetPasswordError extends ForgetPasswordState {
  final String message;
  ResetPasswordError(this.message);
}
