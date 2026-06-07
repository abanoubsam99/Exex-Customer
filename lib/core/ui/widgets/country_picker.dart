import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/theme/app_text_styles.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountryPicker extends StatelessWidget {
  const CountryPicker({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.icon,
    this.title,
    this.hintText,
    this.validator,
    this.color,
    this.showCompact = false,
  });

  const CountryPicker.compact({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.icon,
    this.title,
    this.hintText,
    this.validator,
    this.color,
  }) : showCompact = true;

  final List<DropdownMenuItem>? items;
  final void Function(dynamic value)? onChanged;
  final dynamic value;
  final Widget? icon;
  final String? title;
  final String? hintText;
  final String? Function(dynamic value)? validator;
  final Color? color;
  final bool showCompact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(title!, style: AppTextStyles.font14BlacksoftRegular),
          SizedBox(height: 6.h),
        ],
        DropdownButtonFormField(
          items: items,
          style: AppTextStyles.font14BrownBold,
          hint: Text(
            hintText ?? '',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 14.r,
              fontFamily: 'Almarai',
              color: const Color(0xff99A2AC),
            ),
          ),
          onChanged: onChanged,
          validator: validator,
          selectedItemBuilder: (context) {
            return items!
                .map(
                  (item) => Center(
                    child: Row(
                      children: [
                        Container(
                          width: 30.r,
                          height: 30.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/flags/${(item.value).code.toLowerCase()}.png',
                                package: 'flutter_intl_phone_field',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (!showCompact) ...[
                          SizedBox(width: 8.w),
                          Container(
                            width: 1,
                            height: 30.h,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.5,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: const Color(0xFF99A2AC),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),

                          Text(
                            (item.value as Country).nameTranslations['ar'] ??
                                (item.value as Country).name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                )
                .toList();
          },
          isExpanded: showCompact ? false : true,
          isDense: false,
          value: value,
          icon:
              showCompact
                  ? null
                  : icon ??
                      CustomImageHandler(
                        AppImages.iconsArrowDown,
                        height: 24.r,
                        fit: BoxFit.cover,
                      ),
          dropdownColor: Colors.white,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(12, 4, 12, 4),
            filled: true,
            fillColor: color ?? AppColors.buttonSecondaryColor,
            errorStyle: TextStyle(
              fontSize: 12.0.sp,
              color: Colors.red.shade800,
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.bgGray),
              borderRadius: BorderRadius.all(Radius.circular(16.0.r)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.bgGray),
              borderRadius: BorderRadius.all(Radius.circular(16.0.r)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.bgGray),
              borderRadius: BorderRadius.all(Radius.circular(16.0.r)),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.bgGray),
              borderRadius: BorderRadius.all(Radius.circular(16.0.r)),
            ),
          ),
        ),
      ],
    );
  }
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
];
