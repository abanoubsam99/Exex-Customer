import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:evex_user/core/localization/app_strings.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/country_picker.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/custom_dropdown_form_field.dart';
import 'package:evex_user/data/cubits/booking_services/instant_booking/instant_booking_cubit.dart';
import 'package:evex_user/data/cubits/ports_filter/ports_filter_cubit.dart';
import 'package:evex_user/data/cubits/ports_filter/ports_filter_state.dart';
import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';
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
  // Starts at the max so an untouched slider means "no price cap".
  double _currentValue = 500000;
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
    // Guests can't restrict to "الخدمات المتاحه فقط" — default them to the
    // unrestricted "جميع الخدمات" so they browse everything.
    final isLoggedIn = context.read<UserService>().currentUser != null;
    if (!isLoggedIn) isAvilableOnly = false;
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _validate();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Guests can only filter by location (مكان المناسبة). The rest of the
    // filters stay visible but inactive until they sign in.
    final isLoggedIn = context.read<UserService>().currentUser != null;
    Widget guestLock(Widget child) => Opacity(
          opacity: isLoggedIn ? 1 : 0.5,
          child: AbsorbPointer(absorbing: !isLoggedIn, child: child),
        );
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
            BlocBuilder<PortsFilterCubit, PortsFilterState>(
              builder: (context, fState) {
                final filterCubit = context.read<PortsFilterCubit>();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropDownFormField(
                            hintText: fState.isLoading
                                ? 'جاري التحميل...'
                                : AppStrings.governnorate.tr(),
                            value: fState.selectedGovernorate,
                            items: fState.governorates
                                .map((g) => DropdownMenuItem(
                                      value: g,
                                      child: Text(g.governorateNameAr ?? ''),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value is Governate) {
                                filterCubit.selectGovernorate(value);
                              }
                            },
                          ),
                        ),
                        11.horizontalSpace,
                        Expanded(
                          child: CustomDropDownFormField(
                            hintText: fState.isLoadingCities
                                ? 'جاري التحميل...'
                                : AppStrings.city.tr(),
                            value: fState.selectedCity,
                            items: fState.cities
                                .map((c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c.cityNameAr ?? ''),
                                    ))
                                .toList(),
                            onChanged: fState.selectedGovernorate == null
                                ? null
                                : (value) {
                                    if (value is City) {
                                      filterCubit.selectCity(value);
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    guestLock(
                      CustomDropDownFormField(
                        title: "حدد نوع المناسبة",
                        hintText: "حدد نوع المناسبة",
                        value: fState.selectedOccasionId,
                        items: fState.occasions
                            .where((o) => o.id != null)
                            .map((o) => DropdownMenuItem(
                                  value: o.id,
                                  child: Text(o.name ?? ''),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value is int) filterCubit.selectOccasion(value);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            18.verticalSpace,
            guestLock(
              Column(
                children: [
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
                  onChanged: isLoggedIn
                      ? (value) {
                          setState(() {
                            isAvilableOnly = value;
                          });
                        }
                      : null,
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
                  onChanged: isLoggedIn
                      ? (value) {
                          setState(() {
                            isAvilableOnly = !value;
                          });
                        }
                      : null,
                ),
              ],
            ),
                ],
              ),
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
            guestLock(
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                onChanged: isLoggedIn
                    ? (value) {
                        setState(() {
                          _currentValue = value;
                        });
                      }
                    : null,
              ),
            ),
                ],
              ),
            ),
            23.verticalSpace,
            guestLock(
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
            ),
            45.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'تأكيد',
                    onTap: () {
                      final f = context.read<PortsFilterCubit>().state;
                      final atMax = _currentValue.round() >= _max.round();
                      context.read<InstantBookingCubit>().applyFilters(
                            gov: f.selectedGovernorate?.governorateNameAr,
                            city: f.selectedCity?.cityNameAr,
                            occasionId: f.selectedOccasionId,
                            numberAllowed: count > 0 ? count : null,
                            maxPrice: atMax ? null : _currentValue.round(),
                          );
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
                      context.read<PortsFilterCubit>().clearSelections();
                      setState(() {
                        _currentValue = _max;
                        count = 0;
                        countController.clear();
                        isAvilableOnly = true;
                      });
                      context.read<InstantBookingCubit>().resetFilters();
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
