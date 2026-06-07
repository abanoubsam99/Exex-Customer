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
  OtpTimerTick({required this.seconds, required this.isValid});
}

class OtpConfirmLoading extends AddPhoneState {}

class OtpConfirmSuccess extends AddPhoneState {}

class OtpConfirmError extends AddPhoneState {
  final String message;
  OtpConfirmError(this.message);
}
