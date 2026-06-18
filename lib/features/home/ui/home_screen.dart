// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/custom_circle.dart';
import 'package:evex_user/core/ui/helpers/auth_guard.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/section_seperator.dart';
import 'package:evex_user/core/ui/widgets/text_field_builder_widget.dart';
import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/features/home/ui/widgets/join_us_section.dart';
import 'package:evex_user/features/home/ui/widgets/new_suggestion_section.dart';
import 'package:evex_user/features/home/ui/widgets/other_services_section.dart';
import 'package:evex_user/features/home/ui/widgets/user_data_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:upgrader/upgrader.dart';

import 'widgets/Instant_booking_services_section.dart';
import 'widgets/instant_payment_services.dart';
import 'widgets/special_offers_section.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch fresh home data each time a new MainScreen mounts (app start or
    // re-login) so a previous account's data never lingers.
    context.read<HomeCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: Scaffold(
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () => context.read<HomeCubit>().init(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
            children: [
              SizedBox(
                height: 340.h,
                child: Stack(
                  children: [
                    Container(
                      width: 1.sw,
                      height: 229.h,
                      color: Colors.white,
                      child: Stack(
                        children: [
                          Positioned(
                            top: -52.r,
                            left: -46.r,
                            child: CustomCircle(
                              radius: 107.r,
                              color: AppColors.greenSoft,
                            ),
                          ),
                          Positioned(
                            top: -91.h,
                            left: 146.w,
                            child: CustomCircle(
                              radius: 163.r,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          Positioned(
                            top: 67.h,
                            left: 321.w,
                            child: CustomCircle(
                              radius: 107.r,
                              color: AppColors.amber,
                            ),
                          ),
                          BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 141,
                              sigmaY: 141,
                              tileMode: TileMode.clamp,
                            ),
                            child: Container(
                              width: 1.sw,
                              height: 229.h,
                              decoration: BoxDecoration(
                                color: AppColors.bgLightGrey.withOpacity(0.5),
                              ),
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 24.w),
                                child: Column(
                                  children: [
                                    40.verticalSpace,
                                    const UserDataSection(),
                                    14.verticalSpace,
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFieldBuilder(
                                            bgColor: Colors.white,
                                            fillColor: Colors.white,
                                            hintText: "بحث ...",
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            if (!AuthGuard.requireLogin(
                                                context)) {
                                              return;
                                            }
                                            NavigationHelper.pushNamed(
                                              Routes.paymentHistoryScreen,
                                            );
                                          },
                                          icon: CustomImageHandler(
                                            AppImages.iconsReceipt,
                                            width: 22.r,
                                            height: 22.r,
                                            color: Colors.black,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            if (!AuthGuard.requireLogin(
                                                context)) {
                                              return;
                                            }
                                            NavigationHelper.pushNamed(
                                              Routes.notificationsScreen,
                                            );
                                          },
                                          icon: CustomImageHandler(
                                            AppImages.iconsNotification,
                                            width: 22.r,
                                            height: 22.r,
                                          ),
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Positioned.fill(
                      top: 160.h,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30.r),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            children: [
                              20.verticalSpace,
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  CarouselSlider(
                                    items: [
                                      Stack(
                                        children: [
                                          Container(
                                            width: 1.sw,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16.r),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16.r),
                                              child: Transform.scale(
                                                scale: 1.1,
                                                child: Image.asset(
                                                  AppImages.imagesWedding0,
                                                  fit: BoxFit.cover,
                                                  alignment: const Alignment(
                                                    0,
                                                    -0.58,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                stops: const [
                                                  0.39,
                                                  0.75,
                                                  1.0,
                                                ],
                                                colors: [
                                                  Colors.black.withValues(
                                                    alpha: 0.65,
                                                  ),
                                                  Colors.black.withValues(
                                                    alpha: 0.3705,
                                                  ),
                                                  Colors.black.withValues(
                                                    alpha: 0,
                                                  ),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.r),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16.r,
                                              vertical: 8.h,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'عايز تشكل فرحك على مزاجك ؟',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.r,
                                                    fontFamily: 'Almarai',
                                                    fontWeight: FontWeight.w800,
                                                    letterSpacing: -0.24,
                                                  ),
                                                ),
                                                Text(
                                                  'اوعى تترد انك تدينا اقترحاتك وتحدد اللى انت عايزه وتختار براحتك وادينا كل اقترحاتك',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color: const Color(
                                                      0xFFD9D9D9,
                                                    ),
                                                    fontSize: 14.r,
                                                    fontFamily: 'Almarai',
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: -0.24,
                                                  ),
                                                ),
                                                16.verticalSpace,
                                                CustomButton(
                                                  backgroundColor: const Color(
                                                    0xFFF38B4A,
                                                  ),
                                                  fontSize: 14.r,
                                                  borderRadius: 9.r,
                                                  height: 30.h,
                                                  width: 112.w,
                                                  text: "اقتراح جديد",
                                                  onTap: () {
                                                    if (!AuthGuard.requireLogin(
                                                        context)) {
                                                      return;
                                                    }
                                                    NavigationHelper.pushNamed(
                                                      Routes.newSuggestionScreen,
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 200,
                                        width: 1.sw,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
                                          child: Image.asset(
                                            AppImages.imagesWedding2,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 200,
                                        width: 1.sw,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
                                          child: Image.asset(
                                            AppImages.imagesWedding3,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 200,
                                        width: 1.sw,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
                                          child: Image.asset(
                                            AppImages.imagesWedding4,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ],
                                    options: CarouselOptions(
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          activeIndex = index;
                                        });
                                      },
                                      height: 140.h,
                                      viewportFraction: 1,
                                      initialPage: 0,
                                      enableInfiniteScroll: true,
                                      reverse: false,
                                      autoPlay: false,
                                      autoPlayInterval:
                                          const Duration(seconds: 7),
                                      autoPlayAnimationDuration:
                                          const Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: true,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8.0.h),
                                    child: AnimatedSmoothIndicator(
                                      activeIndex: activeIndex,
                                      textDirection: TextDirection.rtl,
                                      count: 4,
                                      effect: JumpingDotEffect(
                                        dotHeight: 8.r,
                                        dotWidth: 8.r,
                                        activeDotColor:
                                            AppColors.primaryColor,
                                        dotColor: AppColors.dividerGrey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              16.verticalSpace,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    const InstantBookingServicesSection(),
                    16.verticalSpace,
                    const InstantPaymentServices(),
                    16.verticalSpace,
                    // const OtherServicesSection(),
                    // 16.verticalSpace,
                  ],
                ),
              ),
              const SpecialOffersSection(),
              26.verticalSpace,
              const SectionSeperator(),
              16.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    const JoinUsSection(),
                    16.verticalSpace,
                    const NewSuggestionSection(),
                  ],
                ),
              ),
              40.verticalSpace,
            ],
          ),
        ),
        ),
      ),
      ),
    );
  }
}
