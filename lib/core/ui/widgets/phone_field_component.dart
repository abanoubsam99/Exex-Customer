import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import 'package:flutter_intl_phone_field/country_picker_dialog.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class PhoneFieldComponent extends StatefulWidget {
  PhoneFieldComponent({
    super.key,
    this.controller,
    this.countryController,
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
    this.textAlign = TextAlign.start,
    this.label = "",
    this.radius = 12,
    required this.hint,
  }) {
    fillColor ?? const Color(0xffF8F8F8);
    textStyle ?? const TextStyle(color: AppColors.blackColor);
    hintTextStyle ?? const TextStyle(color: AppColors.textDarkGreyColor);
  }

  final String? label;
  final TextEditingController? controller;
  final TextEditingController? countryController;
  late String? Function(String? value)? validator;
  final Function(String? value)? onSubmit;
  final Function(String? value)? onChange;
  final Function? onTapWhileTextFieldIsEnabled;
  final Function? onPress;
  final Widget? suffixIcon, prefixIcon, suffix;
  final FocusNode? focusNode;
  final TextStyle? textStyle, hintTextStyle;
  final TextInputType? keyboardType;
  Color? fillColor;
  final bool hasShowPasswordIcon;
  final bool isReadOnly;
  final bool? isDatePicker;
  final String hint;
  final int? maxlines, maxLength;
  final TextAlign textAlign;
  final double radius;
  Color? borderColor;
  final List<TextInputFormatter> inputFormatters;

  @override
  State<PhoneFieldComponent> createState() => _PhoneFieldComponentState();
}

class _PhoneFieldComponentState extends State<PhoneFieldComponent> {
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
      widget.fillColor = const Color(0xffF4F4F4);
      widget.borderColor = const Color(0xffF4F4F4);
    }
    changeObsecureStatus = widget.hasShowPasswordIcon;
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose(); // Dispose the focus node when done.
  }

  final List<Country> customCountries = [
    const Country(
      name: "Egypt",
      flag: "🇪🇬",
      code: "EG",
      dialCode: "20",
      nameTranslations: {"en": "Egypt", "ar": "مصر"},
      minLength: 10,
      maxLength: 11,
    ),
    // const Country(
    //   name: "United Arab Emirates",
    //   flag: "🇦🇪",
    //   code: "AE",
    //   dialCode: "971",
    //   nameTranslations: {
    //     "en": "United Arab Emirates",
    //     "ar": "الإمارات العربية المتحدة",
    //   },
    //   minLength: 9,
    //   maxLength: 9,
    // ),
  ];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onPress != null) {
          widget.onPress!();
        }
      },
      child: SizedBox(
        child: IntlPhoneField(
          focusNode: _focusNode, // Use the focusNode to track focus
          readOnly: widget.isReadOnly,
          dropdownIcon: CustomImageHandler(
            AppImages.iconsArrowDown2,
            height: 5.r,
            width: 10.r,
            fit: BoxFit.cover,
          ),
          flagsButtonPadding: EdgeInsets.only(right: 8.r),
          inputFormatters: widget.inputFormatters,
          textAlign: widget.textAlign,
          onSubmitted: (value) {
            if (widget.onSubmit != null) {
              widget.onSubmit!(value);
            }
          },

          validator: (v) {
            if (v == null || v.number.isEmpty) {
              return 'يجب ادخال رقم الهاتف';
            }
            return null;
          },
          controller: widget.controller,

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

          decoration: InputDecoration(
            suffix: widget.suffix,
            labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
            counter: const SizedBox(),
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
                    ? Colors
                        .transparent // No fill color when focused
                    : widget.fillColor ?? AppColors.whiteColor,
            hintText: widget.hint,
            errorStyle: TextStyle(fontSize: 12.0, color: Colors.red.shade800),
            hintStyle:
                widget.hintTextStyle ??
                const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                  fontFamily: 'Almarai',
                  color: Color(0xff99A2AC),
                ),
          ),

          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.primaryColor.withOpacity(0.03),
          ),

          initialCountryCode: 'EG',
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          countries: customCountries,
          dropdownIconPosition: IconPosition.trailing,
          style: Theme.of(context).textTheme.bodyMedium,
          pickerDialogStyle: PickerDialogStyle(
            backgroundColor: AppColors.whiteColor,
            countryNameStyle: Theme.of(context).textTheme.labelSmall!,
            countryCodeStyle: Theme.of(context).textTheme.labelSmall!,
          ),
          onCountryChanged: (value) {
            widget.countryController?.text = '+${value.dialCode}';
          },
          onChanged: (phone) {
            widget.controller?.text = phone.number;
            widget.countryController?.text = phone.countryCode;
          },
        ),
      ),
    );
  }
}
