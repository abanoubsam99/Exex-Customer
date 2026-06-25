// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/constants/layout_constants.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/custom_circle.dart';
import 'package:evex_user/core/ui/helpers/auth_guard.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/section_seperator.dart';
import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/data/cubits/home/home_state.dart';
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
                height: 368.h,
                child: Stack(
                  children: [
                    Container(
                      width: 1.sw,
                      height: 256.h,
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
                              height: 256.h,
                              decoration: BoxDecoration(
                                color: AppColors.bgLightGrey.withOpacity(0.5),
                              ),
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 24.w),
                                child: Column(
                                  children: [
                                    64.verticalSpace,
                                    const UserDataSection(),
                                    14.verticalSpace,
                                    Row(
                                      children: [
                                        const Expanded(child: _HomeSearchField()),
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
                                            // Opening the screen marks all as
                                            // read, so clear the badge now.
                                            context
                                                .read<HomeCubit>()
                                                .clearUnreadNotifications();
                                            NavigationHelper.pushNamed(
                                              Routes.notificationsScreen,
                                            );
                                          },
                                          icon: BlocBuilder<HomeCubit,
                                              HomeState>(
                                            buildWhen: (p, c) =>
                                                p.unreadNotifications !=
                                                c.unreadNotifications,
                                            builder: (context, state) =>
                                                _NotificationBell(
                                              count: state.unreadNotifications,
                                            ),
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
                      top: 188.h,
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
                                                child: const CustomImageHandler(
                                                  null,
                                                  fit: BoxFit.cover,
                                                  alignment: Alignment(
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
                                                Flexible(
                                                  child: Text(
                                                    'اوعى تترد انك تدينا اقترحاتك وتحدد اللى انت عايزه وتختار براحتك وادينا كل اقترحاتك',
                                                    textAlign: TextAlign.right,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: const Color(
                                                        0xFFD9D9D9,
                                                      ),
                                                      fontSize: 14.r,
                                                      fontFamily: 'Almarai',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: -0.24,
                                                    ),
                                                  ),
                                                ),
                                                8.verticalSpace,
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
                                          child: const CustomImageHandler(
                                            null,
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
                                          child: const CustomImageHandler(
                                            null,
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
                                          child: const CustomImageHandler(
                                            null,
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
                                      // Auto-rotate the banners without user input.
                                      autoPlay: true,
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
              // Clear the floating nav bar at the end of the scroll.
              SizedBox(height: kFloatingNavBarSpace.r),
            ],
          ),
        ),
        ),
      ),
      ),
    );
  }
}

/// Home search box — matches Figma exactly: 40h, white fill, 1px orange border,
/// 16r radius, "بحث ..." hint in #99A2AC (Almarai 14).
class _HomeSearchField extends StatelessWidget {
  const _HomeSearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primaryColor, width: 1),
      ),
      alignment: Alignment.center,
      child: TextField(
        textAlign: TextAlign.right,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          fontFamily: 'Almarai',
          fontSize: 14.r,
          color: AppColors.blacksoft,
        ),
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          hintText: 'بحث ...',
          hintStyle: TextStyle(
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w400,
            fontSize: 14.r,
            // Figma hint colour (#99A2AC).
            color: const Color(0xFF99A2AC),
          ),
        ),
      ),
    );
  }
}

/// The bell icon with a red unread-count badge on top (hidden when [count] 0).
class _NotificationBell extends StatelessWidget {
  final int count;
  const _NotificationBell({required this.count});

  @override
  Widget build(BuildContext context) {
    final bell = CustomImageHandler(
      AppImages.iconsNotification,
      width: 22.r,
      height: 22.r,
    );
    if (count <= 0) return bell;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        bell,
        Positioned(
          top: -6.r,
          right: -6.r,
          child: Container(
            constraints: BoxConstraints(minWidth: 16.r, minHeight: 16.r),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              count > 99 ? '99+' : '$count',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 9.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
