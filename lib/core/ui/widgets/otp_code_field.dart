import 'package:evex_user/core/helpers/otp_sms_helper.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// The OTP boxes shared by every verification screen (add-phone, reset
/// password). Beyond the common styling it handles:
///
/// * **autofill** — on Android the incoming SMS is read via the User Consent
///   API and dropped into the boxes; on iOS the field advertises
///   `AutofillHints.oneTimeCode` so the keyboard suggests the code.
/// * **auto-check** — once the boxes are full (typed, pasted or autofilled)
///   [onCompleted] fires, so the screen can submit without waiting for a tap.
class OtpCodeField extends StatefulWidget {
  final TextEditingController controller;

  /// Number of digits in the code.
  final int length;

  final ValueChanged<String>? onChanged;

  /// Called with the full code as soon as the last digit lands.
  final ValueChanged<String>? onCompleted;

  const OtpCodeField({
    super.key,
    required this.controller,
    this.length = 6,
    this.onChanged,
    this.onCompleted,
  });

  @override
  State<OtpCodeField> createState() => _OtpCodeFieldState();
}

class _OtpCodeFieldState extends State<OtpCodeField> {
  @override
  void initState() {
    super.initState();
    _listenForSms();
  }

  @override
  void dispose() {
    OtpSmsHelper.stop();
    super.dispose();
  }

  /// Keeps a listener armed until a code arrives, so a resent SMS
  /// ("إعادة الإرسال") is picked up too. Stops for good when the user declines
  /// the consent sheet or the platform can't read SMS at all.
  Future<void> _listenForSms() async {
    while (mounted) {
      final result = await OtpSmsHelper.awaitCode(length: widget.length);
      if (!mounted) return;
      final code = result.code;
      if (code != null) {
        // Setting the text fills the boxes and drives the field's own
        // onChanged / onCompleted callbacks.
        widget.controller.text = code;
        return;
      }
      if (result.stopListening) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: PinCodeTextField(
        appContext: context,
        autoDisposeControllers: false,
        controller: widget.controller,
        length: widget.length,
        obscureText: false,
        autoFocus: true,
        animationType: AnimationType.scale,
        animationDuration: const Duration(milliseconds: 300),
        keyboardType: TextInputType.number,
        enableActiveFill: true,
        cursorHeight: 20,
        errorTextSpace: 5,
        autovalidateMode: AutovalidateMode.always,
        textStyle: Theme.of(context).textTheme.headlineMedium,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(12.r),
          fieldHeight: 54.r,
          fieldWidth: 42.r,
          errorBorderColor: AppColors.redAlertColor,
          errorBorderWidth: 1,
          activeColor: AppColors.blackColor,
          activeFillColor: Colors.white,
          activeBorderWidth: 1,
          selectedColor: AppColors.primaryColor,
          selectedFillColor: Colors.white,
          inactiveFillColor: AppColors.boarderFillColor,
          inactiveColor: AppColors.blueGreyBg,
          inactiveBorderWidth: 1,
        ),
        onChanged: widget.onChanged ?? (_) {},
        onCompleted: widget.onCompleted,
        beforeTextPaste: (_) => true,
      ),
    );
  }
}
