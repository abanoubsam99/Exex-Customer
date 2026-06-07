import 'dart:math' as math;

import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ServiceCardItem extends StatelessWidget {
  final String title;
  final int price;
  final String subtitle;
  final List<String> images;
  final bool isSelected;
  final VoidCallback onSelectionChanged;

  const ServiceCardItem({
    super.key,
    required this.title,
    required this.price,
    required this.subtitle,
    this.images = const [],
    this.isSelected = false,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelectionChanged(),
      child: Container(
        width: 141.w,
        // height: 180.h,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
      
          shadows: [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 16.r,
              offset: Offset(0, 4.r),
              spreadRadius: -2,
            ),
          ],
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 2.r,
              color: isSelected ? const Color(0xFFF38B4A) : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 89.h,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: CustomImageHandler(
                          images.isEmpty ? AppImages.imagesWedding2 : images[0],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -1.r,
                      right: -1.r,
                      child: Container(
                        width: 21.r,
                        height: 21.r,
                        // padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          width: 13.r,
                          height: 13.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF79E2B2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              3.verticalSpace,
              Text(
                'عرض تورته',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: const Color(0xFF2C262C),
                  fontSize: 14.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  height: 1.50,
                  letterSpacing: -0.24,
                ),
              ),
              Text(
                'تفاصيل اكتر عن عرض الت...',
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF99A2AC),
                  fontSize: 12.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                  letterSpacing: -0.24,
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Text.rich(
                    textDirection: TextDirection.ltr,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '100',
                          style: TextStyle(
                            color: const Color(0xFFF38B4A),
                            fontSize: 16.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w800,
                            height: 1.50,
                            letterSpacing: -0.24,
                          ),
                        ),
                        TextSpan(
                          text: ' LE',
                          style: TextStyle(
                            color: const Color(0xFF99A2AC),
                            fontSize: 12.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                            letterSpacing: -0.24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  3.horizontalSpace,
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        '125 LE',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: const Color(0xFFFF928E),
                          fontSize: 13.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                          letterSpacing: -0.24,
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 2.25.h,
                        child: CustomPaint(
                          size: Size(32.w, 10.h),
                          painter: StrikethroughPainter(),
                        ),
                      ),
                      // Transform.rotate(
                      //   angle: 170 * math.pi / 180,
                      //   child: Container(
                      //     width: 33,
                      //     decoration: ShapeDecoration(
                      //       shape: RoundedRectangleBorder(
                      //         side: BorderSide(
                      //           width: 0.50,
                      //           strokeAlign: BorderSide.strokeAlignCenter,
                      //           color: const Color(0xFFFF928E),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Spacer(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 25.r,
                    height: 25.r,
                    decoration: ShapeDecoration(
                      color:
                          isSelected
                              ? const Color(0xFFF38B4A)
                              : const Color(0x33F38B4A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Center(
                      child: CustomImageHandler(
                        width: 17.r,
                        height: 17.r,
                        isSelected ? AppImages.iconsMinus : AppImages.iconsPlus,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StrikethroughPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0Stroke =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.01562500;
    paint0Stroke.color = Color(0xffFF928E).withOpacity(1.0);
    canvas.drawLine(
      Offset(size.width * 0.002021556, size.height * 0.8782440),
      Offset(size.width * 0.9981313, size.height * 0.02414160),
      paint0Stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
