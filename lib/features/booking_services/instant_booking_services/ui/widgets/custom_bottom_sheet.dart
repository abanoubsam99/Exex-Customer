import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:evex_user/core/localization/app_strings.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/country_picker.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/custom_dropdown_form_field.dart';
import 'package:evex_user/data/cubits/booking_services/instant_booking/instant_booking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({super.key});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  bool isAvilableOnly = true;
  double myValue = 5;
  double _currentValue = 170000;
  final double _min = 0;
  final double _max = 500000;
  int count = 0;
  TextEditingController countController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _validate() {
    final value = int.tryParse(countController.text);
    if (value == null || value < 1) {
      countController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _validate();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 21.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 80.w,
                height: 4.r,
                decoration: BoxDecoration(
                  color: AppColors.borderGrey,
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            ),
            24.verticalSpace,
            Text(
              'تصفيه',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.blacksoft,
                fontSize: 18.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
                height: 1.50,
              ),
            ),
            8.verticalSpace,
            Text(
              'حدد مكان المناسبة',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
            13.verticalSpace,
            CountryPicker(
              value: customCountries.first,
              items: [
                ...customCountries.map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Row(
                      children: [
                        Container(
                          width: 30.r,
                          height: 30.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/flags/${e.code.toLowerCase()}.png',
                                package: 'flutter_intl_phone_field',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          width: 1,
                          height: 30.h,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 0.5,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: AppColors.blueGrey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),

                        Text(
                          e.nameTranslations['ar'] ?? e.name,
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
                    ),
                  ),
                ),
              ],
              onChanged: (value) {},
            ),
            16.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomDropDownFormField(
                    // title: AppStrings.governnorate.tr(),
                    hintText: AppStrings.governnorate.tr(),

                    items: [],
                    // items: controller.governates.value
                    //     .map((g) => DropdownMenuItem(
                    //           value: g.governorateNameAr,
                    //           // alignment: Alignment.center,
                    //           child: Text(
                    //             g.governorateNameAr ?? "",
                    //             style: CustomTextTheme.font16BlackMedium,
                    //           ),
                    //         ),)
                    //     .toList(),
                    onChanged: (p0) {
                      // controller.selectedCity.value = null;
                      // controller.selectedGovernateName.value = p0;
                      // controller.getCities(gName: p0);
                    },
                    // value: controller.selectedGovernateName.value,
                    validator: (value) {
                      if (value == null) {
                        return 'يرجي اختيار محافظة';
                      }
                      return null;
                    },
                  ),
                ),
                11.horizontalSpace,
                Expanded(
                  child: CustomDropDownFormField(
                    // title: AppStrings.city.tr(),
                    hintText: AppStrings.city.tr(),
                    // value: controller.selectedCity.value,
                    items: [],
                    // items: controller.cities.value
                    //     .map((g) => DropdownMenuItem(
                    //           value: g.cityNameAr,
                    //           // alignment: Alignment.center,
                    //           child: Text(
                    //             g.cityNameAr ?? "",
                    //             style: CustomTextTheme.font16BlackMedium,
                    //           ),
                    //         ))
                    //     .toList(),
                    onChanged: (city) {
                      // controller.selectedCity.value = city;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'يرجي اختيار مدينة';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            20.verticalSpace,
            CustomDropDownFormField(
              title: "حدد نوع المناسبة",
              hintText: "حدد نوع المناسبة",
              items: [],
              onChanged: (value) {},
            ),
            18.verticalSpace,
            Row(
              children: [
                Text(
                  'الخدمات المتاحه فقط',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                Spacer(),
                Switch(
                  value: isAvilableOnly,
                  activeTrackColor: AppColors.primaryColor,
                  inactiveTrackColor: AppColors.dividerGrey,
                  inactiveThumbColor: Colors.white,
                  thumbColor: WidgetStateProperty.all(Colors.white),

                  thumbIcon: WidgetStateProperty.all(
                    Icon(Icons.circle, size: 5, color: Colors.white),
                  ),

                  trackOutlineColor: WidgetStateProperty.resolveWith((
                    final Set<WidgetState> states,
                  ) {
                    if (states.contains(WidgetState.selected)) {
                      return null;
                    }

                    return Colors.transparent;
                  }),
                  onChanged: (value) {
                    setState(() {
                      isAvilableOnly = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'جميع الخدمات',  // mutually exclusive with "available only"
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                Spacer(),
                Switch(
                  value: !isAvilableOnly,
                  activeTrackColor: AppColors.primaryColor,
                  inactiveTrackColor: AppColors.dividerGrey,
                  inactiveThumbColor: Colors.white,
                  thumbColor: WidgetStateProperty.all(Colors.white),

                  thumbIcon: WidgetStateProperty.all(
                    Icon(Icons.circle, size: 5, color: Colors.white),
                  ),

                  trackOutlineColor: WidgetStateProperty.resolveWith((
                    final Set<WidgetState> states,
                  ) {
                    if (states.contains(WidgetState.selected)) {
                      return null;
                    }

                    return Colors.transparent;
                  }),
                  onChanged: (value) {
                    setState(() {
                      isAvilableOnly = !value;
                    });
                  },
                ),
              ],
            ),

            // SliderTheme(
            //   data: SliderThemeData(
            //     showValueIndicator: ShowValueIndicator.always,

            //     thumbShape: CustomThumbShape(),
            //   ),
            //   child: Slider(
            //     // inactiveColor: PrimaryColor(),
            //     // activeColor: AccentColor(),
            //     min: 5,
            //     max: 20,
            //     value: myValue,
            //     onChanged: (newValue) {
            //       setState(() {
            //         myValue = newValue;
            //       });
            //     },
            //     // divisions: 3,
            //     label: "5",
            //   ),
            // ),
            18.verticalSpace,
            Row(
              children: [
                Text(
                  'حدد سعر معين',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                3.horizontalSpace,
                Text(
                  '(EGP)',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.blueGrey,
                    fontSize: 13.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ],
            ),
            13.verticalSpace,
            Row(
              children: [
                Text(
                  '500',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.blueGrey,
                    fontSize: 14.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                Spacer(),
                Text(
                  '250k',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.blueGrey,
                    fontSize: 14.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.primaryColor,
                inactiveTrackColor: AppColors.boarderFillColor,
                trackHeight: 5.0.r,
                thumbShape: CustomThumbShape(
                  thumbRadius: 12.0,
                  label: '${(_currentValue / 1000).round()}k',
                ),
                // overlayColor: AppColors.primaryColor.withOpacity(0.2),
                // overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
              ),
              child: Slider(
                value: _currentValue,
                min: _min,
                max: _max,
                padding: EdgeInsets.symmetric(horizontal: 0),

                thumbColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    _currentValue = value;
                  });
                },
              ),
            ),
            23.verticalSpace,
            TextFormField(
              onTapOutside: (PointerDownEvent event) {
                FocusManager.instance.primaryFocus?.unfocus();
                _focusNode.unfocus();
              },
              controller: countController,
              focusNode: _focusNode,
              onChanged: (value) {
                setState(() {
                  count = int.parse(value == '' ? "0" : value);
                });
                countController.selection = TextSelection.fromPosition(
                  TextPosition(offset: countController.text.length),
                );
              },
              onTap: () {
                //fix cursor position for english text
                if (countController.selection ==
                    TextSelection.fromPosition(const TextPosition(offset: 0))) {
                  setState(() {
                    countController.selection = TextSelection.fromPosition(
                      TextPosition(offset: countController.text.length),
                    );
                  });
                }
              },
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,

              decoration: InputDecoration(
                isDense: true,
                // prefixIconConstraints: BoxConstraints(
                //   maxHeight: 46.h,
                //   maxWidth: 100.w,
                // ),
                hintText: "حدد عدد الحضور",
                hintStyle: TextStyle(
                  color: AppColors.blueGrey,
                  fontSize: 16.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: GestureDetector(
                    onTap: () {
                      count = count + 1;

                      countController.text = count.toString();
                      setState(() {});
                    },
                    onLongPress: () {
                      count = count + 5;

                      countController.text = count.toString();
                      setState(() {});
                    },
                    child: CircleAvatar(
                      radius: 16.r,
                      backgroundColor: AppColors.secondaryColor,
                      child: Icon(Icons.add, size: 22.r, color: Colors.white),
                    ),
                  ),
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: GestureDetector(
                    onTap: () {
                      if (count >= 1) {
                        count = count - 1;
                        countController.text = count.toString();
                        setState(() {});
                      }
                    },
                    onLongPress: () {
                      if (count >= 5) {
                        count = count - 5;
                        countController.text = count.toString();
                        setState(() {});
                      } else if (count >= 1) {
                        count = count - 1;
                        countController.text = count.toString();
                        setState(() {});
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: AppColors.whiteColor,
                      radius: 16.r,
                      child: Icon(
                        Icons.remove_rounded,
                        size: 22.r,
                        color: AppColors.offBlackColor,
                      ),
                    ),
                  ),
                ),
                filled: true,
                focusColor: AppColors.boarderFillColor,
                fillColor:
                    _focusNode.hasFocus
                        ?
                        // No fill color when focused
                        AppColors.whiteColor
                        : AppColors.boarderFillColor,
                // contentPadding: const EdgeInsets.symmetric(
                //   horizontal: 16,
                //   vertical: 16,
                // ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: const BorderSide(color: AppColors.boarderFillColor),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: const BorderSide(color: AppColors.boarderFillColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: const BorderSide(
                    color: AppColors.darkPrimaryColor,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: const BorderSide(color: AppColors.boarderFillColor),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.red.shade700),
                ),
              ),
            ),
            45.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'تأكيد',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                14.horizontalSpace,
                Expanded(
                  child: CustomButton(
                    isfilled: false,
                    // backgroundColor: Colors.transparent,
                    text: 'إعادة التعيين',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            16.verticalSpace,
          ],
        ),
      ),
    );
  }
}

// class CustomThumbShape extends SliderComponentShape {
//   @override
//   Size getPreferredSize(bool isEnabled, bool isDiscrete) {
//     return const Size(50, 50);
//   }

//   @override
//   void paint(
//     PaintingContext context,
//     Offset center, {
//     required Animation<double> activationAnimation,
//     required Animation<double> enableAnimation,
//     required bool isDiscrete,
//     required TextPainter labelPainter,
//     required RenderBox parentBox,
//     required SliderThemeData sliderTheme,
//     required TextDirection textDirection,
//     required double value,
//     required double textScaleFactor,
//     required Size sizeWithOverflow,
//   }) {
//     TextSpan span = TextSpan(
//       style: TextStyle(color: Colors.white),
//       text: value.toStringAsFixed(1),
//     );
//     TextPainter tp = TextPainter(
//       text: span,
//       textAlign: TextAlign.left,
//       textDirection: TextDirection.ltr,
//     );
//     tp.layout();
//     tp.paint(context.canvas, ui.Offset(center.dx - 12, -60));
//   }
// }

class CustomThumbShape extends SliderComponentShape {
  final double thumbRadius;
  final String label;

  CustomThumbShape({required this.thumbRadius, required this.label});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // Draw shadow for the thumb
    final shadowPaint =
        Paint()
          ..color = AppColors.blackAlpha23
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(center, thumbRadius, shadowPaint);

    // Draw the white thumb circle
    final thumbPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    canvas.drawCircle(center, thumbRadius, thumbPaint);

    // Draw the label above the thumb
    final textSpan = TextSpan(
      text: label,
      style: TextStyle(
        color: AppColors.blacksoft,
        fontSize: 16.r,
        fontFamily: 'Almarai',
        fontWeight: FontWeight.w800,
        height: 1.50,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: textDirection,
    );

    textPainter.layout();

    // Position the label above the thumb
    final labelOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - thumbRadius - textPainter.height - 8,
    );

    textPainter.paint(canvas, labelOffset);
  }
}
