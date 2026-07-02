import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/evex_text_form_field.dart';
import 'package:evex_user/data/cubits/wallet/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shows the wallet PIN dialog (create on first visit, or change later).
///
/// The dialog is dismissible — the user can close it and keep browsing; the
/// wallet screen re-prompts on every open until a PIN is actually set.
/// [walletCubit] is passed explicitly so the dialog (built by the root
/// navigator overlay) can reach the cubit without depending on the calling
/// context's provider scope.
Future<void> showWalletPasswordDialog(
  BuildContext context, {
  required WalletCubit walletCubit,
  bool isChange = false,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => _WalletPasswordDialog(
      walletCubit: walletCubit,
      isChange: isChange,
    ),
  );
}

class _WalletPasswordDialog extends StatefulWidget {
  final WalletCubit walletCubit;
  final bool isChange;

  const _WalletPasswordDialog({
    required this.walletCubit,
    required this.isChange,
  });

  @override
  State<_WalletPasswordDialog> createState() => _WalletPasswordDialogState();
}

class _WalletPasswordDialogState extends State<_WalletPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  /// Smaller label style for the field labels above the inputs.
  TextStyle get _labelStyle => TextStyle(
        color: AppColors.blacksoft,
        fontSize: 13.r,
        fontFamily: 'Almarai',
        fontWeight: FontWeight.w600,
      );

  // Smaller typed-text font inside the fields.
  TextStyle get _inputStyle => TextStyle(
        color: AppColors.blacksoft,
        fontSize: 13.r,
        fontFamily: 'Almarai',
      );

  // Smaller hint font inside the fields.
  TextStyle get _hintStyle => TextStyle(
        color: AppColors.grey,
        fontSize: 13.r,
        fontFamily: 'Almarai',
      );

  /// PIN must be exactly 6 digits (numbers only).
  String? _pinValidator(String? value) {
    final pin = value?.trim() ?? '';
    if (pin.isEmpty) {
      return 'يجب إدخال الرقم السري';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(pin)) {
      return 'الرقم السري يجب أن يكون ٦ أرقام فقط';
    }
    return null;
  }

  Future<void> _submit() async {
    if (_isLoading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    final success =
        await widget.walletCubit.changeWalletPassword(_passwordController.text);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pop();
      ToastManager.showSuccess(
        widget.isChange
            ? 'تم تغيير الرقم السري للمحفظة بنجاح'
            : 'تم إنشاء الرقم السري للمحفظة بنجاح',
      );
    }
    // On failure DioHelper already surfaces the server message as a toast.
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      // Shrink to fit the space left above the keyboard and let the content
      // scroll instead of overflowing.
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 56.r,
                  height: 56.r,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryAlpha1A,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.primaryColor,
                    size: 28.r,
                  ),
                ),
              ),
              16.verticalSpace,
              Text(
                widget.isChange
                    ? 'تغيير الرقم السري للمحفظة'
                    : 'إنشاء رقم سري للمحفظة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blacksoft,
                  fontSize: 16.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w800,
                ),
              ),
              8.verticalSpace,
              Text(
                'لإستخدامه في الخدمات المباشرة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 13.r,
                  fontFamily: 'Almarai',
                  height: 1.6,
                ),
              ),
              20.verticalSpace,
              EvexTextFormField(
                label: 'الرقم السري (من ٦ أرقام فقط)',
                labelStyle: _labelStyle,
                labelGap: 10.h,
                hint: 'أدخل الرقم السري',
                textStyle: _inputStyle,
                hintStyle: _hintStyle,
                textEditingController: _passwordController,
                isPassword: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                validator: _pinValidator,
              ),
              16.verticalSpace,
              EvexTextFormField(
                label: 'تأكيد الرقم السري',
                labelStyle: _labelStyle,
                labelGap: 10.h,
                hint: 'أعد إدخال الرقم السري',
                textStyle: _inputStyle,
                hintStyle: _hintStyle,
                textEditingController: _confirmController,
                isPassword: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يجب تأكيد الرقم السري';
                  }
                  if (value.trim() != _passwordController.text.trim()) {
                    return 'الرقم السري غير متطابق';
                  }
                  return null;
                },
              ),
              24.verticalSpace,
              CustomButton(
                text: 'حفظ',
                height: 48.h,
                // backgroundColor: AppColors.grey4,
                // bordereColor: AppColors.grey4,
                isLoading: _isLoading,
                onTap: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
