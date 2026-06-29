import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_images.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'custom_image_handler.dart';

class EvexTextFormField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxlines, maxLength;
  final Widget? suffixIcon, prefixIcon, suffix;
  final bool obscureText;
  final bool isPassword;

  /// Optional override for the label text style (defaults to the shared header
  /// style). Lets callers use a smaller label without changing it everywhere.
  final TextStyle? labelStyle;

  /// Optional spacing between the label and the input frame (defaults to 4.r).
  /// Lets callers lift the label a bit higher above the field.
  final double? labelGap;

  /// Optional input formatters (e.g. digits-only restriction).
  final List<TextInputFormatter>? inputFormatters;

  const EvexTextFormField({
    super.key,
    required this.label,
    required this.textEditingController,
    this.hint,
    this.validator,
    this.keyboardType,
    this.maxlines,
    this.maxLength,
    this.suffixIcon,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.isPassword = false,
    this.labelStyle,
    this.labelGap,
    this.inputFormatters,
  });

  @override
  State<EvexTextFormField> createState() => _EvexTextFormFieldState();
}

class _EvexTextFormFieldState extends State<EvexTextFormField> {
  late FocusNode _focusNode; // Use the focusNode to track focus
  final ValueNotifier<bool> _myFocusNotifier = ValueNotifier<bool>(false);
  bool isError = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _myFocusNotifier.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    _myFocusNotifier.value = _focusNode.hasFocus;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: widget.labelStyle ?? AppTextStyles.font16BlackRegularHeader,
        ),
        (widget.labelGap ?? 4.r).verticalSpace,
        ValueListenableBuilder(
          valueListenable: _myFocusNotifier,
          builder: (_, isFocus, child) {
            return TextFormField(
              controller: widget.textEditingController,
              onTap: () {
                if (widget.textEditingController.selection ==
                    TextSelection.fromPosition(TextPosition(offset: 0))) {
                  setState(() {
                    widget
                        .textEditingController
                        .selection = TextSelection.fromPosition(
                      TextPosition(
                        offset: widget.textEditingController.text.length,
                      ),
                    );
                  });
                }
              },
              focusNode: _focusNode,
              textAlign: TextAlign.start,
              textDirection: TextDirection.rtl,
              keyboardType: widget.keyboardType ?? TextInputType.text,
              inputFormatters: widget.inputFormatters,
              maxLines: widget.maxlines ?? 1,
              maxLength: widget.maxLength,

              style: AppTextStyles.font16BlackRegularHeader,
              validator:
                  widget.validator ??
                  (value) {
                    if (value!.isEmpty) {
                      isError = true;
                      return "يجب ادخال الحقل";
                    }
                    isError = false;

                    return null;
                  },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              obscureText: widget.isPassword && _obscureText,
              obscuringCharacter: '∗',
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffix: widget.suffix,
                suffixIcon:
                    widget.suffixIcon ??
                    (widget.isPassword
                        ? IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: CustomImageHandler(
                            _obscureText
                                ? AppImages.imagesEye
                                : AppImages.imagesEyeOff,
                            color: const Color.fromARGB(255, 135, 136, 137),
                          ),
                        )
                        : null),
                filled: true,
                hintText: widget.hint,
                hintStyle: AppTextStyles.font16GreyRegularHint,
                fillColor:
                    isError
                        ? AppColors.backgroundColor
                        : isFocus
                        ? AppColors.backgroundColor
                        : AppColors.boarderFillColor,

                errorStyle: TextStyle(fontSize: 12.r),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.orangeColor),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
