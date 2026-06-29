import 'package:evex_user/core/helpers/extensions.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/data/cubits/onboarding/onboarding_location_cubit.dart';
import 'package:evex_user/data/cubits/onboarding/onboarding_location_state.dart';
import 'package:evex_user/features/onboarding/ui/widgets/onboard_first_page.dart';
import 'package:evex_user/features/onboarding/ui/widgets/onboard_second_page.dart';
import 'package:evex_user/features/onboarding/ui/widgets/onboard_third_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/app/helpers/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  /// The "التالى" button is gated per page: the governorate page needs a
  /// governorate picked, the city page needs a city picked. The first
  /// (country) page defaults to Egypt, so it's always enabled.
  bool _isNextEnabled(OnboardingLocationState state) {
    switch (_currentPage) {
      case 1:
        return state.selectedGovernorate != null;
      case 2:
        return state.selectedCity != null;
      default:
        return true;
    }
  }

  Future<void> _onNextPressed() async {
    if (_pageController.page!.toInt() < 2) {
      _pageController.animateToPage(
        _pageController.page!.toInt() + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }
    // Last page: persist the chosen location and finish onboarding. The button
    // is only enabled once a city is selected, so the pair is always complete.
    final locationCubit = context.read<OnboardingLocationCubit>();
    final cache = context.read<CacheHelper>();
    await locationCubit.persist();
    cache.saveData(key: 'onboardingCompleted', value: true);
    NavigationHelper.pushNamedAndRemoveUntil(Routes.loginScreen);
  }

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
            // Add the bottom system inset (Android nav buttons / iOS home
            // indicator) so the row clears it instead of hiding behind it.
            bottom: 20.r + context.bottomSafeInset,
            left: 0.r,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BlocBuilder<OnboardingLocationCubit, OnboardingLocationState>(
                  builder: (context, state) {
                    final enabled = _isNextEnabled(state);
                    return SizedBox(
                      height: 46.h,
                      width: 97.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.blacksoft,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AppColors.bgLightGrey,
                          disabledForegroundColor:
                              Colors.black.withValues(alpha: 0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.r),
                              bottomLeft: Radius.circular(16.r),
                            ),
                          ),
                        ),
                        // Disabled until the current page's dropdown is chosen,
                        // so the user can't skip the governorate/city step.
                        onPressed: enabled ? _onNextPressed : null,
                        child: Text(
                          'التالى',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.24,
                          ),
                        ),
                      ),
                    );
                  },
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
                      activeDotColor: AppColors.primaryColor,
                      dotColor: AppColors.dividerGrey,
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
                        backgroundColor: AppColors.bgLightGrey,
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
