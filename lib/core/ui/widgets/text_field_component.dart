import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/theme/app_text_styles.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class TextFieldComponent extends StatefulWidget {
  TextFieldComponent({
    super.key,
    this.controller,
    this.validator,
    this.borderColor,
    this.onChange,
    this.onSubmit,
    this.onPress,
    this.inputFormatters = const [],
    this.suffixIcon,
    this.keyboardType,
    this.textStyle,
    this.focusNode,
    this.onTapWhileTextFieldIsEnabled,
    this.hintTextStyle,
    this.prefixIcon,
    this.isDatePicker,
    this.fillColor,
    this.maxlines,
    this.suffix,
    this.maxLength,
    this.isReadOnly = false,
    this.hasShowPasswordIcon = false,
    this.textAlign = TextAlign.right,
    this.textDirection,
    this.label = "",
    this.radius = 12,
    required this.hint,
  }) {
    fillColor = AppColors.boarderFillColor;
    textStyle = textStyle ?? AppTextStyles.font16BlackBold;
    hintTextStyle ??
        TextStyle(color: AppColors.textDarkGreyColor, fontSize: 14.r);
  }

  late String? label;
  late TextEditingController? controller;
  late String? Function(String? value)? validator;
  late Function(String? value)? onSubmit;
  late Function(String? value)? onChange;
  late Function? onTapWhileTextFieldIsEnabled;
  late Function? onPress;
  late Widget? suffixIcon, prefixIcon, suffix;
  late FocusNode? focusNode;
  late TextStyle? textStyle, hintTextStyle;
  late TextInputType? keyboardType;
  late Color? fillColor;
  final bool hasShowPasswordIcon;
  final bool isReadOnly;
  final bool? isDatePicker;
  final String hint;
  final int? maxlines, maxLength;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final double radius;
  Color? borderColor;
  final List<TextInputFormatter> inputFormatters;

  @override
  State<TextFieldComponent> createState() => _TextFieldComponentState();
}

class _TextFieldComponentState extends State<TextFieldComponent> {
  late bool changeObsecureStatus;
  late FocusNode _focusNode; // Add a focus node to track focus

  @override
  void initState() {
    super.initState();
    _focusNode =
        widget.focusNode ??
        FocusNode(); // If no focusNode is passed, create one.

    // Listen for focus changes to update the fillColor dynamically.
    _focusNode.addListener(() {
      setState(() {
        // Rebuild when focus changes
      });
    });

    if (widget.isReadOnly) {
      widget.fillColor = AppColors.boarderFillColor;
      widget.borderColor = AppColors.boarderFillColor;
    }
    changeObsecureStatus = widget.hasShowPasswordIcon;
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose(); // Dispose the focus node when done.
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onPress != null) {
          widget.onPress!();
        }
      },
      child: SizedBox(
        child: TextFormField(
          onTapOutside: (PointerDownEvent event) {
            FocusManager.instance.primaryFocus?.unfocus();
            _focusNode.unfocus();
          },
          focusNode: _focusNode, // Use the focusNode to track focus
          readOnly: widget.isReadOnly,
          inputFormatters: widget.inputFormatters,

          textAlign: widget.textAlign ?? TextAlign.right,
          textDirection: widget.textDirection,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          maxLines: widget.maxlines ?? 1,
          maxLength: widget.maxLength,
          controller: widget.controller,
          validator: widget.validator,
          buildCounter:
              (widget.maxLength == null)
                  ? null
                  : (
                    context, {
                    currentLength = 1,
                    maxLength,
                    isFocused = false,
                  }) {
                    return Text(
                      '$currentLength/$maxLength',
                      style: const TextStyle(color: AppColors.primaryColor),
                    );
                  },
          autovalidateMode:
              widget.isDatePicker ?? false
                  ? AutovalidateMode.disabled
                  : AutovalidateMode.onUserInteraction,
          onTap: () {
            if (widget.onTapWhileTextFieldIsEnabled != null) {
              widget.onTapWhileTextFieldIsEnabled!();
            }
            //fix cursor position for english text
            if (widget.controller?.selection ==
                TextSelection.fromPosition(const TextPosition(offset: 0))) {
              setState(() {
                widget.controller!.selection = TextSelection.fromPosition(
                  TextPosition(offset: widget.controller!.text.length),
                );
              });
            }
          },
          onFieldSubmitted: (value) {
            if (widget.onSubmit != null) {
              widget.onSubmit!(value);
            }
          },
          onChanged: (value) {
            if (widget.onChange != null) {
              widget.onChange!(value);
            }
          },
          obscureText: changeObsecureStatus,
          obscuringCharacter: '*',
          style: widget.textStyle,
          decoration: InputDecoration(
            suffix: widget.suffix,
            labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
            label:
                widget.label != null && widget.label!.isNotEmpty
                    ? Text(widget.label!)
                    : null,
            enabled: widget.onPress == null,
            suffixIcon:
                widget.suffixIcon ??
                (widget.hasShowPasswordIcon
                    ? IconButton(
                      onPressed: () {
                        setState(() {
                          changeObsecureStatus = !changeObsecureStatus;
                        });
                      },
                      icon: CustomImageHandler(
                        changeObsecureStatus
                            ? AppImages.imagesEye
                            : AppImages.imagesEyeOff,
                        color: const Color.fromARGB(255, 135, 136, 137),
                      ),
                    )
                    : null),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.bgGray,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.bgGray,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.darkPrimaryColor,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.bgGray,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: Colors.red.shade700),
            ),
            prefixIcon: widget.prefixIcon,
            filled: true,
            focusColor: Colors.white,
            fillColor:
                _focusNode.hasFocus
                    ? AppColors.whiteColor
                    : widget.fillColor ?? AppColors.whiteColor,
            hintText: widget.hint,
            errorStyle: TextStyle(fontSize: 12.0.r, color: Colors.red.shade800),
            hintStyle:
                widget.hintTextStyle ??
                TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 14.r,
                  fontFamily: 'Almarai',
                  color: AppColors.blueGrey,
                ),
          ),
        ),
      ),
    );
  }
}
