import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/theme/app_text_styles.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/phone_field_component.dart';
import 'package:evex_user/core/ui/widgets/text_field_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldBuilder extends StatelessWidget {
  final String? title;
  final bool isPassword;

  final TextInputType keyboardType;
  final bool isPhone;
  final bool isDatePicker;
  final Function(String)? datePickerFunction;
  final TextEditingController? controller;
  final TextEditingController? countryController;
  final Color? bgColor;
  final Color? fillColor;
  final int? maxLines;
  final double? radius;
  final bool? readOnly;
  final bool? autoFocus;
  final String? Function(String?)? validator;
  final Function(String? value)? onSubmit;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? padding;
  final Widget? suffix;
  final void Function()? onPressed;
  final String? hintText;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Function(String? value)? onChange;

  const TextFieldBuilder({
    super.key,
    this.title,
    this.isPassword = false,
    this.countryController,
    this.onSubmit,
    this.suffix,
    this.radius,
    this.autoFocus,
    this.keyboardType = TextInputType.text,
    this.isPhone = false,
    this.isDatePicker = false,
    this.maxLines = 1,
    this.controller,
    this.datePickerFunction,
    this.bgColor,
    this.readOnly,
    this.fillColor,
    this.validator,
    this.inputFormatters,
    this.padding,
    this.onPressed,
    this.hintText,
    this.textStyle,
    this.hintStyle,
    this.textAlign,
    this.textDirection,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: textStyle ?? AppTextStyles.font14BlacksoftRegular,
          ),
          SizedBox(height: 6.h),
        ],
        isPhone
            ? PhoneFieldComponent(
              hint: hintText ?? title ?? '',
              radius: radius ?? 16.r,
              onSubmit: onSubmit,

              isDatePicker: isDatePicker,
              // suffix: suffix,
              textStyle: AppTextStyles.font16BlackBold,
              // validator: validator ??
              //     (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'الحقل مطلوب';
              //       }
              //       return null;
              //     },
              // inputFormatters: [
              //   ...inputFormatters ?? [],
              // ],
              fillColor: fillColor ?? Colors.white,
              isReadOnly: readOnly ?? false,
              keyboardType: keyboardType,
              maxlines: maxLines,
              hasShowPasswordIcon: isPassword,
              controller: controller,
              countryController: countryController,
              hintTextStyle:
                  hintStyle ??
                  TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.r,
                    fontFamily: 'Almarai',
                    color: const Color(0xff99A2AC),
                  ),
              suffixIcon:
                  isDatePicker
                      ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: CustomImageHandler(
                          isDatePicker
                              ? AppImages.iconsCalendar
                              : AppImages.imagesEye,
                        ),
                      )
                      : suffix,
              onPress:
                  !isDatePicker
                      ? onPressed
                      : () {
                        showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        ).then((value) {
                          if (value != null) {
                            // datePickerFunction!(value.toString());

                            controller?.text =
                                DateFormat('yyyy-MM-dd')
                                    .parse(value.toString())
                                    .toString()
                                    .split(' ')[0];
                          }
                        });
                      },
            )
            : TextFieldComponent(
              hint: hintText ?? title ?? '',
              radius: 16.r,
              onSubmit: onSubmit,
              onChange: onChange,
              isDatePicker: isDatePicker,
              textAlign: textAlign,
              textDirection: textDirection,
              // suffix: suffix,
              textStyle: AppTextStyles.font14BlacksoftRegular,
              validator:
                  validator ??
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'الحقل مطلوب';
                    }
                    return null;
                  },
              inputFormatters: [...inputFormatters ?? []],
              fillColor: fillColor ?? Colors.white,
              isReadOnly: readOnly ?? false,
              keyboardType: keyboardType,
              maxlines: maxLines,
              hasShowPasswordIcon: isPassword,
              controller: controller,
              hintTextStyle:
                  hintStyle ??
                  TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.r,
                    fontFamily: 'Almarai',
                    color: const Color(0xff99A2AC),
                  ),
              suffixIcon:
                  isDatePicker
                      ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: CustomImageHandler(
                          isDatePicker
                              ? AppImages.iconsCalendar
                              : AppImages.imagesEye,
                        ),
                      )
                      : suffix,
              onPress:
                  !isDatePicker
                      ? onPressed
                      : () {
                        showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        ).then((value) {
                          if (value != null) {
                            // datePickerFunction!(value.toString());

                            controller?.text =
                                DateFormat('yyyy-MM-dd')
                                    .parse(value.toString())
                                    .toString()
                                    .split(' ')[0];
                          }
                        });
                      },
            ),
      ],
    );
  }
}
