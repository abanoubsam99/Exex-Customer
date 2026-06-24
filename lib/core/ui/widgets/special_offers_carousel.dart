import 'package:carousel_slider/carousel_slider.dart';
import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/helpers/image_url_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/models/special_offer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// The "عروض مميزة" banner carousel used by the instant-booking and
/// direct-services lists: shows ALL special offers coming from the backend
/// (one elaborate banner per offer) with a dot indicator below that tracks the
/// current page. Renders nothing when there are no offers.
class SpecialOffersCarousel extends StatefulWidget {
  final List<SpecialOffer> offers;
  const SpecialOffersCarousel({super.key, required this.offers});

  @override
  State<SpecialOffersCarousel> createState() => _SpecialOffersCarouselState();
}

class _SpecialOffersCarouselState extends State<SpecialOffersCarousel> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final offers = widget.offers;
    if (offers.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        CarouselSlider(
          items: offers.map((o) => Center(child: _OfferBanner(offer: o))).toList(),
          options: CarouselOptions(
            height: 160.h,
            viewportFraction: 0.92,
            enableInfiniteScroll: offers.length > 1,
            onPageChanged: (i, _) => setState(() => _index = i),
          ),
        ),
        if (offers.length > 1) ...[
          12.verticalSpace,
          AnimatedSmoothIndicator(
            activeIndex: _index,
            count: offers.length,
            textDirection: TextDirection.ltr,
            effect: ExpandingDotsEffect(
              dotHeight: 8.r,
              dotWidth: 8.r,
              expansionFactor: 2,
              activeDotColor: AppColors.primaryColor,
              dotColor: AppColors.dividerGrey,
            ),
          ),
        ],
      ],
    );
  }
}

/// A single special-offer banner (clipped orange shape + image + text), tappable
/// to the service details.
class _OfferBanner extends StatelessWidget {
  final SpecialOffer offer;
  const _OfferBanner({required this.offer});

  @override
  Widget build(BuildContext context) {
    final image = offer.serviceImages.isNotEmpty
        ? ImageUrlHelper.full(offer.serviceImages.first)
        : null;
    return GestureDetector(
      onTap: () => NavigationHelper.pushNamed(
        Routes.bookingServiceDetailsScreen,
        arguments: offer,
      ),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            width: 315.w,
            height: 144.h,
            decoration: ShapeDecoration(
              color: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
          CustomPaint(
            size: Size(305.w, 144.h),
            painter: _RPSCustomPainter(),
          ),
          ClipPath(
            clipper: _RPSClipper(),
            child: CustomImageHandler(
              image,
              smartFill: true,
              height: 159.h,
              width: 292.w,
            ),
          ),
          ClipPath(
            clipper: _RPSClipper(),
            child: Container(
              height: 159.h,
              width: 292.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(-1.0, 1),
                  end: const Alignment(1, 0.0),
                  stops: const [0, 22.0],
                  colors: [
                    Colors.black.withValues(alpha: 0.00),
                    Colors.black.withValues(alpha: 0.44),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 4.w,
            bottom: 10.h,
            child: CustomImageHandler(
              AppImages.iconsSpecialOffers,
              fit: BoxFit.contain,
              width: 78.r,
            ),
          ),
          Positioned(
            right: 11.w,
            bottom: 24.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  offer.name,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.24.w,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 4.r),
                        blurRadius: 24.r,
                        color: AppColors.pureBlack.withValues(alpha: 0.50),
                      ),
                    ],
                  ),
                ),
                2.verticalSpace,
                SizedBox(
                  width: 225.w,
                  child: Text(
                    offer.details,
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w400,
                      height: 1.30,
                      letterSpacing: -0.24.w,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2.r),
                          blurRadius: 20.r,
                          color: AppColors.pureBlack.withValues(alpha: 1.00),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.6487222, 0);
    path_0.cubicTo(
      size.width * 0.8379510,
      size.height * 0.08532639,
      size.width * 0.9908660,
      size.height * 0.2106528,
      size.width * 0.9966830,
      size.height * 0.3933681,
    );
    path_0.cubicTo(
      size.width * 1.007242,
      size.height * 0.7248403,
      size.width * 0.5231013,
      size.height * 0.9145139,
      size.width * 0.2233627,
      size.height,
    );
    path_0.lineTo(size.width * 0.05228758, size.height);
    path_0.cubicTo(
      size.width * 0.02341176,
      size.height,
      0,
      size.height * 0.9502500,
      0,
      size.height * 0.8888889,
    );
    path_0.lineTo(0, size.height * 0.1111111);
    path_0.cubicTo(
      0,
      size.height * 0.04975000,
      size.width * 0.02341176,
      0,
      size.width * 0.05228758,
      0,
    );
    path_0.lineTo(size.width * 0.6487222, 0);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = AppColors.lightOrangeColor.withValues(alpha: 1.0);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RPSClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double r = 16.r;

    Path path = Path();
    path.moveTo(size.width * 0.6025797, 0);
    path.cubicTo(
      size.width * 0.8141356,
      size.height * 0.08167296,
      size.width * 0.9934949,
      size.height * 0.2064843,
      size.width * 0.9998271,
      size.height * 0.3954214,
    );
    path.cubicTo(
      size.width * 1.011668,
      size.height * 0.7487358,
      size.width * 0.4052847,
      size.height * 0.9336730,
      size.width * 0.1260508,
      size.height,
    );
    path.lineTo(r, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - r);
    path.lineTo(0, r);
    path.quadraticBezierTo(0, 0, r, 0);
    path.lineTo(size.width * 0.6025797, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
