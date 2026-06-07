import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/routing/app_router.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/widgets/custom_dropdown_form_field.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/features/onboarding/ui/widgets/onboard_first_page.dart';
import 'package:evex_user/features/onboarding/ui/widgets/onboard_second_page.dart';
import 'package:evex_user/features/onboarding/ui/widgets/onboard_third_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            reverse: true,
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (page) => setState(() => _currentPage = page),
            children: [
              OnboardFirstPage(),
              OnboardSecondPage(),
              OnboardThirdPage(),
            ],
          ),
          Positioned(
            bottom: 63.r,
            left: 0.r,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 46.h,
                  width: 97.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFF2C262C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          bottomLeft: Radius.circular(16.r),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (_pageController.page!.toInt() < 2) {
                        _pageController.animateToPage(
                          _pageController.page!.toInt() + 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        // navigate to next screen after onboarding
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setBool('onboardingCompleted', true);
                        });
                        Get.offAllNamed(Routes.loginScreen);
                      }
                    },
                    child: Text(
                      'التالى',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 11.h),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    textDirection: TextDirection.ltr,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      dotHeight: 8.r,
                      dotWidth: 8.r,
                      expansionFactor: 2,
                      activeDotColor: const Color(0xFFF38B4A),
                      dotColor: const Color(0xFFD9D9D9),
                    ),
                  ),
                ),
                // AnimatedBuilder(
                //   animation: _pageController,
                //   builder: (context, child) {
                //     double page =
                //         _pageController.hasClients
                //             ? (_pageController.page ??
                //                 _pageController.initialPage.toDouble())
                //             : _pageController.initialPage.toDouble();

                //     return Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: List.generate(3, (index) {
                //         bool isActive = index == page.round();
                //         bool isPrevious = index < page;

                //         return AnimatedContainer(
                //           duration: Duration(milliseconds: 300),
                //           margin: EdgeInsets.symmetric(horizontal: 4),
                //           height: 8.r,
                //           width: isActive ? 18.r : 8.r, // expand active dot
                //           decoration: BoxDecoration(
                //             color:
                //                 isPrevious || isActive
                //                     ? Colors.orange
                //                     : Colors.grey,
                //             borderRadius: BorderRadius.circular(6),
                //           ),
                //         );
                //       }),
                //     );
                //   },
                // ),
                SizedBox(
                  height: 46.h,
                  width: 97.w,
                  child: Visibility(
                    visible: _currentPage > 0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFFF8F8F8),
                        foregroundColor: Colors.black.withValues(alpha: 0.85),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16.r),
                            bottomRight: Radius.circular(16.r),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (_pageController.page!.toInt() > 0) {
                          _pageController.animateToPage(
                            _pageController.page!.toInt() - 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        'رجوع',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.85),
                          fontSize: 16.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.24,
                        ),
                      ),
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
