import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/helpers/image_url_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/shimmer_skelton.dart';
import 'package:evex_user/core/ui/widgets/special_banner_slide.dart';
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/data/cubits/home/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class SpecialOffersSection extends StatelessWidget {
  const SpecialOffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: [
              Container(
                width: 6.r,
                height: 18.r,
                decoration: ShapeDecoration(
                  color: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
              ),
              8.horizontalSpace,
              Text(
                'عروض مميزه !',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.24,
                ),
              ),
            ],
          ),
        ),
        11.verticalSpace,
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final carouselOptions = CarouselOptions(
              height: 135.h,
              viewportFraction: 0.84,
              initialPage: 0,
              reverse: false,
              // Auto-rotate the offers one after another without user input.
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 7),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.2,
              scrollDirection: Axis.horizontal,
            );

            if (state.isLoadingOffers) {
              return CarouselSlider(
                items: [
                  ShimmerSkelton(height: 135.h),
                  ShimmerSkelton(height: 135.h),
                  ShimmerSkelton(height: 135.h),
                ],
                options: carouselOptions,
              );
            }

            // The static promo banner always leads the carousel; the backend
            // offers follow. So even with no offers for the user's area the
            // section still shows the banner instead of an empty state.
            return CarouselSlider(
              items: <Widget>[
                const SpecialBannerSlide(),
                ...state.specialOffers.map(
                    (offer) => InkWell(
                      onTap: () => NavigationHelper.pushNamed(
                        Routes.bookingServiceDetailsScreen,
                        arguments: offer,
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: 1.sw,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Transform.scale(
                                scale: 1.1,
                                child: CustomImageHandler(
                                  offer.serviceImages.isNotEmpty
                                      ? ImageUrlHelper.full(
                                          offer.serviceImages.first,
                                        )
                                      : null,
                                  smartFill: true,
                                  alignment: const Alignment(0, -0.58),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.blacksoft.withValues(alpha: 0),
                                  Colors.black.withValues(alpha: 0.5),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          // Top-left badge
                          Positioned(
                            top: 6.r,
                            left: 6.r,
                            child: Container(
                              width: 74.r,
                              height: 19.r,
                              decoration: ShapeDecoration(
                                color: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(13.r),
                                    topRight: Radius.circular(4.r),
                                    bottomLeft: Radius.circular(4.r),
                                    bottomRight: Radius.circular(4.r),
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'الاكثر طلبا ً',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            ),
                          ),
                          // Port name — blur pill at top right
                          Positioned(
                            top: 6.r,
                            right: 8.r,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.r),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                child: Container(
                                  color: Colors.white.withValues(alpha: 0.55),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 3.h),
                                  child: Text(
                                    offer.portName??"",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.r,
                                      fontFamily: 'Almarai',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Description at bottom
                          Positioned(
                            bottom: 5.h,
                            right: 8.r,
                            left: 8.r,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        offer.name??"",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.r,
                                          fontFamily: 'Almarai',
                                          fontWeight: FontWeight.w800,
                                          // Tight drop shadow (no spread) so the
                                          // text reads over the photo behind it.
                                          shadows: [
                                            Shadow(
                                              offset: Offset(0, 1.5.r),
                                              blurRadius: 4.r,
                                              color: Colors.black
                                                  .withValues(alpha: 0.6),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        offer.details??"",
                                        textAlign: TextAlign.right,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.r,
                                          fontFamily: 'Almarai',
                                          fontWeight: FontWeight.w400,
                                          height: 1.35,
                                          letterSpacing: -0.24.w,
                                          shadows: [
                                            Shadow(
                                              offset: Offset(0, 1.r),
                                              blurRadius: 3.r,
                                              color: Colors.black.withValues(alpha: 0.55),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
              options: carouselOptions,
            );
          },
        ),
      ],
    );
  }
}
