import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/helpers/image_url_helper.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/shimmer_skelton.dart';
import 'package:evex_user/core/ui/widgets/speech_bubble_border.dart';
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/data/cubits/home/home_state.dart';
import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstantPaymentServices extends StatelessWidget {
  const InstantPaymentServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
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
              'الخدمات المباشرة',
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
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.isLoadingPorts) {
              return SizedBox(
                height: 70.h,
                child: ListView.builder(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ShimmerSkelton(width: 74.w, height: 68.h),
                  ),
                  itemCount: 2,
                ),
              );
            }
            return SizedBox(
              height: 100.h,
              child: ListView.separated(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemCount: state.paymentPorts.length,
                itemBuilder: (context, index) {
                  final port = state.paymentPorts[index];
                  final isSelected = state.selectedPaymentPort?.id == port.id;
                  return GestureDetector(
                    onTap: () {
                      // Direct-payment categories have no chips — go straight
                      // to the direct services list.
                      context.read<HomeCubit>().selectPaymentPort(port);
                      NavigationHelper.pushNamed(
                        Routes.directServicesListScreen,
                      );
                    },
                    child: Center(
                      child: Container(
                        width: 74.w,
                        height: 68.h,
                        decoration: isSelected
                            ? ShapeDecoration(
                                color: Colors.white,
                                shape: SpeechBubbleBorder(
                                  borderColor: const Color(0xffF38B4A),
                                  borderWidth: 2,
                                  tailPosition: 0.70,
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8.r,
                                    offset: Offset(0, 4.r),
                                  ),
                                ],
                              )
                            : ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color(0xFFF3F3F3),
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomImageHandler(
                              ImageUrlHelper.full(port.iconePath) ??
                                  AppImages.imagesNewLogo2,
                              fit: BoxFit.contain,
                              height: 40.r,
                              width: 40.r,
                              errorIcon: const Icon(Icons.image_not_supported),
                            ),
                            Text(
                              port.nameAr,
                              textAlign: TextAlign.center,
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
                  );
                },
                separatorBuilder: (context, index) => 10.horizontalSpace,
              ),
            );
          },
        ),
      ],
    );
  }
}
