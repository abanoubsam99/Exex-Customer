import 'package:evex_user/core/helpers/image_url_helper.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/models/port_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:evex_user/core/theme/app_colors.dart';

/// كارت منتج/خدمة في شاشة الدفع المباشر (عرض فقط — بيفتح bottom sheet التفاصيل).
class DirectProductCard extends StatefulWidget {
  final PortService service;
  final VoidCallback onTap;

  const DirectProductCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  State<DirectProductCard> createState() => _DirectProductCardState();
}

class _DirectProductCardState extends State<DirectProductCard> {
  final PageController _pageController = PageController();
  int _activeImage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;
    // When the vendor keeps the price private, hide the price + discount badge.
    final showPrice = !service.displayPrice;
    // Show the price the customer actually pays (after discount), with the
    // original price struck through — same as the instant-booking cards.
    final before = service.priceBeforDiscount;
    final price = service.priceAfterDiscount ?? service.price ?? 0;
    // Discount percentage comes straight from the API (not recomputed).
    final discountPercent = service.discountPercentage ?? 0;
    final hasDiscount =
        showPrice && discountPercent > 0 && before != null && before > price;
    final images = service.serviceImages ?? const <String>[];

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 141.w,
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
                        child: _buildImages(images),
                      ),
                    ),
                    if (hasDiscount)
                      Positioned(
                        top: 4.r,
                        left: 4.r,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            '$discountPercent%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    // Dots indicator when the service has more than one image.
                    if (images.length > 1)
                      Positioned(
                        bottom: 4.h,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: AnimatedSmoothIndicator(
                            activeIndex: _activeImage,
                            count: images.length,
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
              6.verticalSpace,
              Text(
                service.name ?? '',
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.blacksoft,
                  fontSize: 14.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                  letterSpacing: -0.24,
                ),
              ),
              Text(
                service.details ?? '',
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.blueGrey,
                  fontSize: 12.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  letterSpacing: -0.24,
                ),
              ),
              8.verticalSpace,
              if (showPrice)
                Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    if (hasDiscount) ...[
                      Text(
                        '$before LE',
                        style: TextStyle(
                          color: AppColors.unitGrey,
                          fontSize: 11.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.salmon,
                        ),
                      ),
                      6.horizontalSpace,
                    ],
                    Text.rich(
                      textDirection: TextDirection.ltr,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '$price',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextSpan(
                            text: ' LE',
                            style: TextStyle(
                              color: AppColors.blueGrey,
                              fontSize: 12.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
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

  /// Swipeable gallery of all the service images (falls back to the placeholder
  /// when there are none) — same behaviour as the instant-booking service card.
  Widget _buildImages(List<String> images) {
    if (images.isEmpty) {
      return const CustomImageHandler(null);
    }
    if (images.length == 1) {
      return CustomImageHandler(
        ImageUrlHelper.full(images.first),
        smartFill: true,
      );
    }
    return PageView.builder(
      controller: _pageController,
      itemCount: images.length,
      onPageChanged: (i) => setState(() => _activeImage = i),
      itemBuilder: (context, i) => CustomImageHandler(
        ImageUrlHelper.full(images[i]),
        smartFill: true,
      ),
    );
  }
}
