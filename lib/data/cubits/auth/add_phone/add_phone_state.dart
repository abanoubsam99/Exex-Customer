abstract class AddPhoneState {}

class AddPhoneInitial extends AddPhoneState {}

class AddPhoneLoading extends AddPhoneState {}

class AddPhoneSent extends AddPhoneState {
  final String phone;
  AddPhoneSent(this.phone);
}

class AddPhoneError extends AddPhoneState {
  final String message;
  AddPhoneError(this.message);
}

// OTP states
class OtpTimerTick extends AddPhoneState {
  final int seconds;
  final bool isValid;

  /// True while a "resend code" request is in flight, so the resend button can
  /// show progress and reject a second tap.
  final bool isResending;

  OtpTimerTick({
    required this.seconds,
    required this.isValid,
    this.isResending = false,
  });
}

class OtpConfirmLoading extends AddPhoneState {}

class OtpConfirmSuccess extends AddPhoneState {}

class OtpConfirmError extends AddPhoneState {
  final String message;
  OtpConfirmError(this.message);
}
