import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/helpers/image_url_helper.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ServiceCardItem extends StatefulWidget {
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
  State<ServiceCardItem> createState() => _ServiceCardItemState();
}

class _ServiceCardItemState extends State<ServiceCardItem> {
  final PageController _pageController = PageController();
  int _activeImage = 0;

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
        width: 141.w,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shadows: [
            BoxShadow(
              color: const Color(0x19000000),
              blurRadius: 16.r,
              offset: Offset(0, 4.r),
              spreadRadius: -2,
            ),
          ],
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 2.r,
              color:
                  widget.isSelected ? const Color(0xFFF38B4A) : Colors.transparent,
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
                        child: _buildImages(),
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
                        child: Container(
                          width: 13.r,
                          height: 13.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF79E2B2),
                          ),
                        ),
                      ),
                    ),
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
                              activeDotColor: const Color(0xFFF38B4A),
                              dotColor: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              3.verticalSpace,
              Text(
                widget.title,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                widget.subtitle,
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
              const Spacer(),
              Row(
                children: [
                  Text.rich(
                    textDirection: TextDirection.ltr,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${widget.price}',
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
                  const Spacer(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 25.r,
                    height: 25.r,
                    decoration: ShapeDecoration(
                      color: widget.isSelected
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
                        widget.isSelected
                            ? AppImages.iconsMinus
                            : AppImages.iconsPlus,
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

  /// بيعرض كل صور الخدمة في PageView قابل للتمرير.
  /// لو مفيش صور بيعرض صورة افتراضية.
  Widget _buildImages() {
    if (widget.images.isEmpty) {
      return CustomImageHandler(AppImages.imagesWedding2, fit: BoxFit.fill);
    }
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.images.length,
      onPageChanged: (i) => setState(() => _activeImage = i),
      itemBuilder: (context, i) => CustomImageHandler(
        ImageUrlHelper.full(widget.images[i]) ?? AppImages.imagesWedding2,
        fit: BoxFit.fill,
        errorIcon: const Icon(Icons.broken_image_outlined),
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
    paint0Stroke.color = const Color(0xffFF928E).withValues(alpha: 1.0);
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
