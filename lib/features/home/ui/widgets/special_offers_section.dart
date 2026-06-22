import 'package:carousel_slider/carousel_slider.dart';
import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/helpers/image_url_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/shimmer_skelton.dart';
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
              autoPlay: false,
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

            return CarouselSlider(
              items: state.specialOffers
                  .map(
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
                                  fit: BoxFit.cover,
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
                          Positioned(
                            bottom: 14.h,
                            right: 0,
                            left: 0,
                            child: Padding(
                              padding: EdgeInsets.only(right: 12.r, left: 10.r),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          offer.name,
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
                                          offer.details,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.r,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: -0.24.w,
                                            shadows: [
                                              Shadow(
                                                offset: Offset(0, 1.r),
                                                blurRadius: 3.r,
                                                color: Colors.black
                                                    .withValues(alpha: 0.55),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  13.horizontalSpaceRadius,
                                  // CustomButton(
                                  //   height: 40.h,
                                  //   width: 75.w,
                                  //   bordereColor: AppColors.blacksoft,
                                  //   fontSize: 14.r,
                                  //   text: "تفاصيل",
                                  //   onTap: () => NavigationHelper.pushNamed(
                                  //     Routes.bookingServiceDetailsScreen,
                                  //     arguments: offer,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              options: carouselOptions,
            );
          },
        ),
      ],
    );
  }
}
