import '../constants/MyColors.dart';
import '../constants/app_images.dart';
import '../constants/app_text_styles.dart';
import 'custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropDownFormField extends StatelessWidget {
  const CustomDropDownFormField({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.icon,
    this.title,
    this.hintText,
    this.validator,
    this.color,
  });

  final List<DropdownMenuItem>? items;
  final void Function(dynamic value)? onChanged;
  final dynamic value;
  final Widget? icon;
  final String? title;
  final String? hintText;
  final String? Function(dynamic value)? validator;
  final Color? color;

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
          isExpanded: true,
          items: items,
          // style: AppTextStyles.font14BrownBold,
          hint: Text(
            hintText ?? '',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14.r,
              fontFamily: 'Almarai',
              color: const Color(0xff99A2AC),
            ),
          ),
          selectedItemBuilder:
              (context) =>
                  items!
                      .map(
                        (item) => FittedBox(
                          child: Text(
                            item.value.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.font14BlacksoftRegular,
                          ),
                        ),
                      )
                      .toList(),
          onChanged: onChanged,
          validator: validator,
          value: value,
          icon:
              icon ??
              CustomImageHandler(
                AppImages.iconsArrowDown,
                height: 24.r,
                fit: BoxFit.cover,
              ),
          dropdownColor: Colors.white,
          decoration: InputDecoration(
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

// import 'package:evex/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CustomDropDownFormField extends StatelessWidget {
//   const CustomDropDownFormField(
//       {super.key,
//       required this.items,
//       required this.onChanged,
//       this.value,
//       this.icon,
//       this.hintText,
//       this.validator,
//       this.size = 30,
//       this.color});

//   final List<DropdownMenuItem>? items;
//   final void Function(dynamic)? onChanged;
//   final dynamic value;
//   final Widget? icon;
//   final String? hintText;
//   final String? Function(dynamic)? validator;
//   final Color? color;
//   final double? size;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       // height: 46,
//       child: DropdownButtonFormField(
//         value: value,
//         items: items,

//         onChanged: onChanged,
//         dropdownColor: Colors.white,

//         style: TextStyle(
//           fontFamily: 'din',
//           fontWeight: FontWeight.w600,
//           fontSize: 2.sp,
//           color: const Color(0xFF121212),
//         ),

//         hint: hintText != null
//             ? Text(
//                 hintText ?? '',
//                 style: TextStyle(
//                   fontFamily: 'din',
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.normal,
//                 ),
//               )
//             : null,

//         autovalidateMode: AutovalidateMode.onUnfocus,
//         // iconSize: 24.r,
//         icon: icon,
//         decoration: InputDecoration(
//           floatingLabelBehavior: FloatingLabelBehavior.always,
//           isDense: true,
//           contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
//           // suffixIcon: Icon(Icons.arrow_back),
//           filled: true,

//           errorStyle: TextStyle(fontSize: 12.sp),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide.none,
//             borderRadius: BorderRadius.circular(16.r),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: AppColors.darkPrimaryColor),
//             borderRadius: BorderRadius.circular(16.r),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.red),
//             borderRadius: BorderRadius.circular(16.r),
//           ),
//           focusedErrorBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.red),
//             borderRadius: BorderRadius.circular(16.r),
//           ),
//         ),
//       ),
//     );
//   }
// }
