import 'package:evex_user/core/helpers/image_url_helper.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/looping_marquee_text.dart';

import 'BlinkingDot.dart';

class ServiceCardItem extends StatefulWidget {
  final String title;
  final int price;

  /// Original price before the discount. When it's higher than [price] the card
  /// shows a discount badge and a struck-through old price.
  final int? priceBeforeDiscount;
  final String subtitle;

  /// "20/6/2026 - 20/7/2026" — the special-price period the picked date falls
  /// in. Empty when the normal price applies (the row is then hidden).
  final String dateRange;
  final List<String> images;
  final bool isSelected;

  /// When true the price (and discount badge) is hidden — the vendor didn't
  /// publish a fixed price for this service.
  final bool displayPrice;

  /// Whether the service can be booked on the picked date (the backend's
  /// `unreservedServices`). An unavailable card dims, shows a red dot and can't
  /// be selected.
  final bool isAvailable;
  final VoidCallback onSelectionChanged;

  const ServiceCardItem({
    super.key,
    required this.title,
    required this.price,
    this.priceBeforeDiscount,
    required this.subtitle,
    this.dateRange = '',
    this.images = const [],
    this.isSelected = false,
    this.isAvailable = true,
    this.displayPrice = false,
    required this.onSelectionChanged,
  });

  @override
  State<ServiceCardItem> createState() => _ServiceCardItemState();
}

class _ServiceCardItemState extends State<ServiceCardItem> {
  final PageController _pageController = PageController();
  int _activeImage = 0;

  /// Discount percentage derived from the before/after prices (0 when there is
  /// no real discount, so the badge stays hidden).
  int get _discountPercent {
    final before = widget.priceBeforeDiscount ?? 0;
    if (before <= 0 || before <= widget.price) return 0;
    return (((before - widget.price) / before) * 100).round();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onSelectionChanged(),
      child: Container(
        width: 145.w,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shadows: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 16.r,
              offset: Offset(0, 4.r),
              spreadRadius: -2,
            ),
          ],
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 2.r,
              color: widget.isSelected && widget.isAvailable
                  ? AppColors.primaryColor
                  : Colors.transparent,
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
                      // Dim the image of a service that can't be booked today.
                      child: Opacity(
                        opacity: widget.isAvailable ? 1 : 0.45,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: _buildImages(),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -1.r,
                      right: -1.r,
                      child: Container(
                        width: 21.r,
                        height: 21.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: BlinkingDot(
                          color: widget.isAvailable
                              ? AppColors.greenSoft
                              : AppColors.coral,
                          blink: widget.isAvailable,
                        ),
                      ),
                    ),
                    // Discount badge (top-left) — only when there's a real
                    // discount and the price isn't hidden.
                    if (!widget.displayPrice && _discountPercent > 0)
                      Positioned(
                        top: 4.h,
                        left: 4.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 0.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            '$_discountPercent%',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                    // Positioned(
                    //   top: -1.r,
                    //   right: -1.r,
                    //   child: Container(
                    //     width: 21.r,
                    //     height: 21.r,
                    //     decoration: const BoxDecoration(
                    //       shape: BoxShape.circle,
                    //       color: Colors.white,
                    //     ),
                    //     alignment: Alignment.center,
                    //     child: Container(
                    //       width: 13.r,
                    //       height: 13.r,
                    //       decoration: const BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         color: AppColors.greenSoft,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    if (widget.images.length > 1)
                      Positioned(
                        bottom: 4.h,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: AnimatedSmoothIndicator(
                            activeIndex: _activeImage,
                            count: widget.images.length,
                            effect: JumpingDotEffect(
                              dotHeight: 5.r,
                              dotWidth: 5.r,
                              activeDotColor: AppColors.primaryColor,
                              dotColor: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              3.verticalSpace,
              SizedBox(
                width: double.infinity,
                child: LoopingMarqueeText(
                  widget.title,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.blacksoft,
                    fontSize: 12.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                    letterSpacing: -0.24,
                  ),
                ),
              ),
              Text(
                widget.subtitle,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.blueGrey,
                  fontSize: 12.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                  letterSpacing: -0.24,
                ),
              ),
              // Special-price window (e.g. "20/6/2026 - 20/7/2026") — shown only
              // when the picked date falls inside one of the service's periods.
              if (widget.dateRange.isNotEmpty) ...[
                2.verticalSpace,
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon(
                    //   Icons.calendar_today_rounded,
                    //   size: 11.r,
                    //   color: AppColors.cyan,
                    // ),
                    // 4.horizontalSpace,
                    Text(
                      widget.dateRange,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.ltr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.descriptionText,
                        fontSize: 12.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                        height: 1.40,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ],
                ),
              ],
              const Spacer(),
              // Hide the whole price row when the vendor keeps the price private.
              if (!widget.displayPrice)
              Row(
                children: [
                  // السعر الحالي (بعد الخصم)
                  Text.rich(
                    textDirection: TextDirection.ltr,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${widget.price}',
                          style: TextStyle(
                            color: AppColors.primaryColor,
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
                            color: AppColors.blueGrey,
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
                  // السعر قبل الخصم (مشطوب) — يظهر فقط عند وجود خصم فعلي.
                  if (_discountPercent > 0) ...[
                    6.horizontalSpace,
                    Text(
                      '${widget.priceBeforeDiscount} LE',
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: AppColors.salmon,
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                        letterSpacing: -0.24,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: AppColors.salmon,
                      ),
                    ),
                  ],
                  const Spacer(),
                  // AnimatedContainer(
                  //   duration: const Duration(milliseconds: 300),
                  //   width: 25.r,
                  //   height: 25.r,
                  //   decoration: ShapeDecoration(
                  //     color: widget.isSelected
                  //         ? AppColors.primaryColor
                  //         : AppColors.primaryAlpha33,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(8.r),
                  //     ),
                  //   ),
                  //   child: Center(
                  //     child: CustomImageHandler(
                  //       width: 17.r,
                  //       height: 17.r,
                  //       widget.isSelected
                  //           ? AppImages.iconsMinus
                  //           : AppImages.iconsPlus,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// بيعرض كل صور الخدمة في PageView قابل للتمرير.
  /// لو مفيش صور بيعرض صورة افتراضية.
  Widget _buildImages() {
    if (widget.images.isEmpty) {
      return const CustomImageHandler(null);
    }
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.images.length,
      onPageChanged: (i) => setState(() => _activeImage = i),
      itemBuilder: (context, i) => CustomImageHandler(
        ImageUrlHelper.full(widget.images[i]),
        smartFill: true,
      ),
    );
  }
}

class StrikethroughPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01562500;
    paint0Stroke.color = AppColors.salmon.withValues(alpha: 1.0);
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
