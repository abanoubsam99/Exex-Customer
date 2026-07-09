import 'package:carousel_slider/carousel_slider.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// One banner slide: its asset and how it fills the slot.
class _Banner {
  final String asset;
  final BoxFit fit;
  const _Banner(this.asset, this.fit);
}

/// The home banners carousel + its page indicator.
///
/// The active index lives here (not on the home screen) so the 7s auto-rotation
/// rebuilds this widget only — not the whole screen with its backdrop blur.
class HomeBannerCarousel extends StatefulWidget {
  const HomeBannerCarousel({super.key});

  @override
  State<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<HomeBannerCarousel> {
  int _activeIndex = 0;

  /// The first banner's artwork is stretched to the slot; the rest are cropped.
  static const _banners = <_Banner>[
    _Banner(AppImages.imagesBanner1, BoxFit.fill),
    _Banner(AppImages.imagesBanner2, BoxFit.cover),
    _Banner(AppImages.imagesBanner3, BoxFit.cover),
    _Banner(AppImages.imagesBanner4, BoxFit.cover),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          items: _banners
              .map((banner) => ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: SizedBox(
                      width: 1.sw,
                      child: CustomImageHandler(banner.asset, fit: banner.fit),
                    ),
                  ))
              .toList(),
          options: CarouselOptions(
            onPageChanged: (index, reason) =>
                setState(() => _activeIndex = index),
            height: 140.h,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            // Auto-rotate the banners without user input.
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 7),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: AnimatedSmoothIndicator(
            activeIndex: _activeIndex,
            textDirection: TextDirection.rtl,
            count: _banners.length,
            effect: JumpingDotEffect(
              dotHeight: 8.r,
              dotWidth: 8.r,
              activeDotColor: AppColors.primaryColor,
              dotColor: AppColors.dividerGrey,
            ),
          ),
        ),
      ],
    );
  }
}

// The first banner used to carry a dark gradient + "عايز تشكل فرحك على مزاجك ؟"
// text and an "اقتراح جديد" button on top of it. Hidden (not deleted) — restore
// by wrapping the first slide in a Stack with these children again:
//
// Container(
//   decoration: BoxDecoration(
//     gradient: LinearGradient(
//       begin: Alignment.topCenter,
//       end: Alignment.bottomCenter,
//       stops: const [0.39, 0.75, 1.0],
//       colors: [
//         Colors.black.withValues(alpha: 0.65),
//         Colors.black.withValues(alpha: 0.3705),
//         Colors.black.withValues(alpha: 0),
//       ],
//     ),
//     borderRadius: BorderRadius.circular(16.r),
//   ),
// ),
// Padding(
//   padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.h),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         'عايز تشكل فرحك على مزاجك ؟',
//         textAlign: TextAlign.right,
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 20.r,
//           fontFamily: 'Almarai',
//           fontWeight: FontWeight.w800,
//           letterSpacing: -0.24,
//         ),
//       ),
//       Flexible(
//         child: Text(
//           'اوعى تترد انك تدينا اقترحاتك وتحدد اللى انت عايزه وتختار براحتك وادينا كل اقترحاتك',
//           textAlign: TextAlign.right,
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//             color: const Color(0xFFD9D9D9),
//             fontSize: 14.r,
//             fontFamily: 'Almarai',
//             fontWeight: FontWeight.w400,
//             letterSpacing: -0.24,
//           ),
//         ),
//       ),
//       8.verticalSpace,
//       CustomButton(
//         backgroundColor: const Color(0xFFF38B4A),
//         fontSize: 14.r,
//         borderRadius: 9.r,
//         height: 30.h,
//         width: 112.w,
//         text: "اقتراح جديد",
//         onTap: () {
//           if (!AuthGuard.requireLogin(context)) return;
//           NavigationHelper.pushNamed(Routes.newSuggestionScreen);
//         },
//       ),
//     ],
//   ),
// ),
