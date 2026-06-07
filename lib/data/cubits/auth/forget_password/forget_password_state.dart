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
  OtpForgetTimerTick({required this.seconds, required this.isValid});
}

class ResetPasswordLoading extends ForgetPasswordState {}

class ResetPasswordSuccess extends ForgetPasswordState {}

class ResetPasswordError extends ForgetPasswordState {
  final String message;
  ResetPasswordError(this.message);
}
