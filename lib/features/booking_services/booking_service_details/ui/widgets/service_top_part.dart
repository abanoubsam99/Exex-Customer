// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';

class ServiceTopPart extends StatefulWidget {
  const ServiceTopPart({super.key});

  @override
  State<ServiceTopPart> createState() => _ServiceTopPartState();
}

class _ServiceTopPartState extends State<ServiceTopPart> {
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          items: [
            Transform.scale(
              alignment: Alignment.topCenter,
              scale: 1.23,
              child: Image.asset(AppImages.imagesWedding5, fit: BoxFit.cover),
            ),
            Container(
              height: 200,
              width: 1.sw,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.asset(AppImages.imagesWedding2, fit: BoxFit.fill),
              ),
            ),
            Container(
              height: 200,
              width: 1.sw,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.asset(AppImages.imagesWedding3, fit: BoxFit.fill),
              ),
            ),
            Container(
              height: 200,
              width: 1.sw,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.asset(AppImages.imagesWedding4, fit: BoxFit.fill),
              ),
            ),
          ],
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index;
              });
            },
            height: 283.h,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: false,
            autoPlayInterval: const Duration(seconds: 7),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          ),
        ),
        Container(
          width: 1.sw,
          height: 44.h,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.white,
                Colors.white.withValues(alpha: 0.85),
                Colors.white.withValues(alpha: 0.0),
              ],
              // The corresponding stops for each color
              stops: [0.0, 0.58, 1.0],
            ),
          ),
        ),
        Positioned(
          top: 0,

          child: Container(
            width: 1.sw,
            height: 44.h,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white.withValues(alpha: 0.85),
                  Colors.white.withValues(alpha: 0.0),
                ],
                // The corresponding stops for each color
                stops: [0.18, 0.58, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          top: 40.h,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SocialNavButton(
                  height: 36.r,
                  width: 36.r,
                  icon: AppImages.iconsChevronRightSolid,
                  onTap: () {
                    Get.back();
                  },
                ),
                Spacer(),
                SocialNavButton(icon: AppImages.iconsHeart, onTap: () {}),
                6.horizontalSpace,
                SocialNavButton(icon: AppImages.iconsMarker, onTap: () {}),
                6.horizontalSpace,
                SocialNavButton(icon: AppImages.iconsPhone2, onTap: () {}),
                6.horizontalSpace,
                SocialNavButton(icon: AppImages.iconsFolder, onTap: () {}),
                6.horizontalSpace,
                SocialNavButton(icon: AppImages.iconsShare, onTap: () {}),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 40.h,
          child: AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            textDirection: TextDirection.ltr,
            count: 4,
            effect: ExpandingDotsEffect(
              dotHeight: 8.r,
              dotWidth: 8.r,
              expansionFactor: 2,
              activeDotColor: const Color(0xFFF38B4A),
              dotColor: const Color(0xFFD9D9D9),
            ),
          ),
        ),
        Positioned(
          bottom: -10.h,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                Text(
                  'قاعه الؤلؤه',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: const Color(0xFF2C262C),
                    fontSize: 20.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.24,
                  ),
                ),
                Spacer(),
                Transform.translate(
                  offset: Offset(0, -1.5.h),
                  child: CustomImageHandler(
                    AppImages.iconsStar,
                    height: 30.r,
                    width: 30.r,
                    fit: BoxFit.cover,
                  ),
                ),
                4.horizontalSpace,
                Text(
                  '4.6',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: const Color(0xFF2C262C),
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
    );
  }
}

class SocialNavButton extends StatelessWidget {
  final double? height;
  final double? width;

  final String icon;
  final void Function()? onTap;
  const SocialNavButton({
    super.key,
    required this.icon,
    this.onTap,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusDirectional.circular(10.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: height ?? 32.r,
              height: width ?? 32.r,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10.r),
              ),
              alignment: Alignment.center,
              child: CustomImageHandler(icon, height: 18.r, width: 18.r),
            ),
          ),
        ),
      ),
    );
  }
}
