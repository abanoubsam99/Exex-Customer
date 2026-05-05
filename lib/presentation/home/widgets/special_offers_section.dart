import 'package:carousel_slider/carousel_slider.dart';
import 'package:evexcustomer/app/constants/app_endpoints.dart';
import 'package:evexcustomer/app/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/widgets/custom_button.dart';
import '../../../app/widgets/custom_image_handler.dart';
import '../../../app/widgets/shimmer_skelton.dart';


class SpecialOffersSection  extends StatelessWidget {
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
                  color: const Color(0xFFF38B4A),
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
        false==true
            ? CarouselSlider(
          items: [
            ShimmerSkelton(height: 135.h),
            ShimmerSkelton(height: 135.h),
            ShimmerSkelton(height: 135.h),
          ],
          options: CarouselOptions(
            height: 135.h,
            viewportFraction: 0.84,
            initialPage: 0,
            reverse: false,
            autoPlay: false,
            autoPlayInterval: const Duration(seconds: 7),
            autoPlayAnimationDuration: const Duration(
              milliseconds: 800,
            ),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.2,
            scrollDirection: Axis.horizontal,
          ),
        )
            : CarouselSlider(
          items:[]
              .map(
                (offer) => Stack(
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
                            ? '${AppEndpoints.baseUrl}${offer.serviceImages.first}'
                            : AppImages.imagesWedding0,
                        fit: BoxFit.cover,
                        alignment: Alignment(0, -0.58),
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
                        Color(
                          0xFF2C262C,
                        ).withValues(alpha: 0),
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
                      color: const Color(0xFFF38B4A),
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
                    padding: EdgeInsets.only(
                      right: 12.r,
                      left: 10.r,
                    ),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
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
                                ),
                              ),
                              Text(
                                offer.details,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.r,
                                  // fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.24.w,
                                  // height: 1.31,
                                ),
                              ),
                            ],
                          ),
                        ),
                        13.horizontalSpaceRadius,
                        CustomButton(
                          height: 40.h,
                          width: 75.w,
                          bordereColor: Color(0xFF2C262C),
                          fontSize: 14.r,
                          text: "تفاصيل",
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
              .toList(),
          options: CarouselOptions(
            height: 135.h,
            viewportFraction: 0.84,
            initialPage: 0,
            reverse: false,
            autoPlay: false,
            autoPlayInterval: const Duration(seconds: 7),
            autoPlayAnimationDuration: const Duration(
              milliseconds: 800,
            ),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.2,
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }
}
