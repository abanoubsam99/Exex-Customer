import 'package:evex_user/core/constants/app_images.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:evex_user/core/localization/app_strings.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/theme/app_text_styles.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_dropdown_form_field.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/text_field_builder_widget.dart';
import 'package:evex_user/core/ui/widgets/title_inbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class NewSuggestionScreen extends StatelessWidget {
  const NewSuggestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomBackButtonWidget(),
                      12.horizontalSpace,
                      Text(
                        'اقتراح جديد',
                        textAlign: TextAlign.right,
                        style: AppTextStyles.font18BlackExtraBoldHeader,
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Text(
                    'دورت على تاجر أو مقدم خدمة معين ومالقيتهوش ؟\nشاركنا بمعلومات عنه وسيب الباقي علينا',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.font12greyRegular.copyWith(
                      height: 1.67,
                    ),
                  ),
                  18.verticalSpace,
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      border: Border.all(color: const Color(0xffE4E7EC)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TitleInBox(
                          title: 'معلومات عن التاجر',
                          // extraTitle: 'جميع الحقول مطلوبه',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFieldBuilder(
                                title: 'اسم التاجر أو مقدم الخدمة',
                                fillColor: AppColors.buttonSecondaryColor,
                              ),
                              8.verticalSpace,

                              CustomDropDownFormField(
                                title: AppStrings.governnorate.tr(),
                                hintText: 'المحافظة',
                                icon: CustomImageHandler(
                                  AppImages.iconsArrowDown,
                                  width: 18,
                                ),
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
                              8.verticalSpace,
                              CustomDropDownFormField(
                                title: AppStrings.city.tr(),
                                icon: CustomImageHandler(
                                  AppImages.iconsArrowDown,
                                  width: 18,
                                ),
                                hintText: 'المدينة',
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
                              InternationalPhoneNumberInput(
                                countries: ['EG'],

                                onInputChanged: (PhoneNumber value) {
                                  print(value);
                                },
                              ),

                              ///h
                              const SizedBox(height: 14),
                              TextFieldBuilder(
                                radius: 16,
                                title: 'رقم الهاتف',
                                isPhone: true,
                                // controller: controller.phoneNumberController,
                                // validator: (phone) =>
                                //     AppValidationFunctions.phoneValidationFunction(
                                //   phone,
                                // ),
                                fillColor: AppColors.buttonSecondaryColor,
                              ),
                              const SizedBox(height: 14),
                              TextFieldBuilder(
                                radius: 16,
                                title: 'رقم الواتساب',
                                // controller: controller.whatsPhoneNumberController,
                                validator: (p0) {
                                  return null;
                                },
                                fillColor: AppColors.buttonSecondaryColor,
                              ),
                              SizedBox(height: 16.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),

                  SpeechBubbleContainer(
                    width: 74.w,
                    height: 68.h,
                    backgroundColor: Colors.white,
                    borderColor: const Color(0xffF38B4A),
                    borderWidth: 2,
                    child: Text(
                      'Hello! This is a speech bubble.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 40.h),

                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      width: 80,
                      height: 100,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: SpeechBubbleBorder(
                          borderColor: const Color(0xffF38B4A),
                          borderWidth: 2,
                          tailPosition: 0.70, // 70% from left (biased right)
                        ),
                        shadows: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Hello! This is a speech bubble.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SpeechBubbleContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;

  const SpeechBubbleContainer({
    super.key,
    required this.child,
    this.width = 74,
    this.height = 60,
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0xffF38B4A),
    this.borderWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height + 8), // +8 for the tail
      painter: _SpeechBubblePainter(
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        borderWidth: borderWidth,
      ),
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(12),
        child: child,
      ),
    );
  }
}

class _SpeechBubblePainter extends CustomPainter {
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;

  _SpeechBubblePainter({
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final tailHeight = 8.0;
    final height = size.height - tailHeight;
    final borderRadius = 12.0;

    // Calculate tail dimensions relative to width
    final tailWidth = 14.0; // Base width of the tail
    final tailCenter =
        width * 0.75; // Position tail towards the right (70% from left)

    Path path = Path();

    // Start from top-left, draw rounded rectangle with tail
    path.moveTo(borderRadius, 0);
    path.lineTo(width - borderRadius, 0);
    path.arcToPoint(
      Offset(width, borderRadius),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );
    path.lineTo(width, height - borderRadius);
    path.arcToPoint(
      Offset(width - borderRadius, height),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );

    // Right side before tail
    path.lineTo(tailCenter + tailWidth / 2, height);

    // Right side of tail (points down to center)
    path.lineTo(tailCenter, height + tailHeight);

    // Left side of tail (points back up)
    path.lineTo(tailCenter - tailWidth / 2, height);

    // Left side after tail
    path.lineTo(borderRadius, height);
    path.arcToPoint(
      Offset(0, height - borderRadius),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );
    path.lineTo(0, borderRadius);
    path.arcToPoint(
      Offset(borderRadius, 0),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );
    path.close();

    // Draw shadow
    canvas.drawShadow(path, Colors.black, 4, true);

    // Draw background
    Paint backgroundPaint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = backgroundColor;
    canvas.drawPath(path, backgroundPaint);

    // Draw border
    Paint borderPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = borderColor
          ..strokeWidth = borderWidth;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class SpeechBubbleBorder extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final double tailWidth;
  final double tailHeight;
  final double tailPosition; // 0.0 to 1.0, where 0.5 is center
  final double borderRadius;

  const SpeechBubbleBorder({
    this.borderColor = const Color(0xffF38B4A),
    this.borderWidth = 1.5,
    this.tailWidth = 14.0,
    this.tailHeight = 8.0,
    this.tailPosition = 0.70, // 70% from left (biased right)
    this.borderRadius = 12.0,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: tailHeight);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _createPath(rect.deflate(borderWidth / 2));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    // Deflate rect by half border width to prevent clipping
    return _createPath(rect.deflate(borderWidth / 2));
  }

  Path _createPath(Rect rect) {
    final width = rect.width;
    final height = rect.height - tailHeight;
    final left = rect.left;
    final top = rect.top;

    final tailCenter = left + (width * tailPosition);

    Path path = Path();

    // Start from top-left corner
    path.moveTo(left + borderRadius, top);

    // Top edge
    path.lineTo(left + width - borderRadius, top);

    // Top-right corner (using arc for better rendering)
    path.arcToPoint(
      Offset(left + width, top + borderRadius),
      radius: Radius.circular(borderRadius),
    );

    // Right edge
    path.lineTo(left + width, top + height - borderRadius);

    // Bottom-right corner (using arc for better rendering)
    path.arcToPoint(
      Offset(left + width - borderRadius, top + height),
      radius: Radius.circular(borderRadius),
    );

    // Bottom edge (right side before tail)
    path.lineTo(tailCenter + tailWidth / 2, top + height);

    // Right side of tail
    path.lineTo(tailCenter, top + height + tailHeight);

    // Left side of tail
    path.lineTo(tailCenter - tailWidth / 2, top + height);

    // Bottom edge (left side after tail)
    path.lineTo(left + borderRadius, top + height);

    // Bottom-left corner (using arc for better rendering)
    path.arcToPoint(
      Offset(left, top + height - borderRadius),
      radius: Radius.circular(borderRadius),
    );

    // Left edge
    path.lineTo(left, top + borderRadius);

    // Top-left corner (using arc for better rendering)
    path.arcToPoint(
      Offset(left + borderRadius, top),
      radius: Radius.circular(borderRadius),
    );

    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final path = getOuterPath(rect, textDirection: textDirection);

    // Draw border with centered stroke
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = borderColor
          ..strokeWidth = borderWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);
  }

  @override
  ShapeBorder scale(double t) {
    return SpeechBubbleBorder(
      borderColor: borderColor,
      borderWidth: borderWidth * t,
      tailWidth: tailWidth * t,
      tailHeight: tailHeight * t,
      tailPosition: tailPosition,
      borderRadius: borderRadius * t,
    );
  }
}
