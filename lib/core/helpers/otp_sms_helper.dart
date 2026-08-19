import 'dart:io';

import 'package:smart_auth/smart_auth.dart';

/// Outcome of one SMS-listening round.
class OtpSmsResult {
  /// The code pulled out of the message, when there was one.
  final String? code;

  /// True when the user dismissed the consent sheet, the platform has no
  /// SMS API, or the call failed — listening again would only nag them.
  final bool stopListening;

  const OtpSmsResult({this.code, this.stopListening = false});
}

/// Reads the incoming OTP SMS so the code can be filled automatically.
///
/// Android — SMS User Consent API (through `smart_auth`): no SMS permission and
/// no app-signature hash inside the message; the system shows a one-tap
/// "allow this app to read the message" sheet when the SMS arrives.
///
/// iOS — nothing happens here: the OTP field advertises
/// `AutofillHints.oneTimeCode`, so the keyboard offers the code by itself.
class OtpSmsHelper {
  OtpSmsHelper._();

  /// Only Android has an SMS-reading API; everything else relies on the
  /// platform's own autofill.
  static bool get isSupported => Platform.isAndroid;

  /// Matches exactly [length] digits, tolerating the separators senders like to
  /// put between them (`223 829`, `223-829`), and refusing longer runs so a
  /// phone number or a date in the same message isn't mistaken for the code.
  static String matcherFor(int length) =>
      r'(?<!\d)\d(?:[ -]?\d){' '${length - 1}' r'}(?!\d)';

  /// Waits for one OTP SMS and returns its code. A result with no code but
  /// [OtpSmsResult.stopListening] false means the message arrived without a
  /// usable code — the caller may listen again (e.g. after "إعادة الإرسال").
  static Future<OtpSmsResult> awaitCode({required int length}) async {
    if (!isSupported) return const OtpSmsResult(stopListening: true);
    final result = await SmartAuth.instance.getSmsWithUserConsentApi(
      matcher: matcherFor(length),
    );
    if (result.isCanceled || result.hasError) {
      return const OtpSmsResult(stopListening: true);
    }
    return OtpSmsResult(code: digitsOf(result.data?.code, length: length));
  }

  /// Strips the separators out of a matched code and keeps it only when it
  /// really holds [length] digits.
  static String? digitsOf(String? raw, {required int length}) {
    if (raw == null) return null;
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    return digits.length == length ? digits : null;
  }

  /// Drops the pending listener (screen closed before the SMS arrived).
  static Future<void> stop() async {
    if (!isSupported) return;
    await SmartAuth.instance.removeUserConsentApiListener();
  }
}
