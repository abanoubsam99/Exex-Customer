import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/cubits/booking_services/instant_booking/instant_booking_cubit.dart';
import 'package:evex_user/data/cubits/booking_services/instant_booking/instant_booking_state.dart';
import 'package:evex_user/data/models/hall.dart';
import 'package:evex_user/features/booking_services/instant_booking_services/ui/widgets/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../home/ui/widgets/booking_services_type.dart';
import 'widgets/custom_bottom_sheet.dart';

class InstantBookingServicesScreen extends StatelessWidget {
  const InstantBookingServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<InstantBookingCubit, InstantBookingState>(
                builder: (context, state) => state.isLoading
                    ? const CircularProgressIndicator()
                    : const SizedBox(),
              ),
              60.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CustomBackButtonWidget(),
                        12.horizontalSpace,
                        Text(
                          'خدمات الحجز الفوري',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: const Color(0xFF121212),
                            fontSize: 18.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.24,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'دلوقتي ولأول مرة في مصر, عرفنا تاريخ مناسبتك وهنعرفك فوراً الخدمات المتاحة للحجز',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: const Color(0xFF6F767E),
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                        height: 1.69,
                      ),
                    ),
                    16.verticalSpace,
                    Row(
                      children: [
                        Expanded(child: DatePicker(title: 'تاريخ المناسبة')),
                        12.horizontalSpace,
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => const CustomBottomSheet(),
                            );
                          },
                          child: Container(
                            // padding: const EdgeInsets.all(8),
                            height: 46.r,
                            width: 46.r,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: const Color(0xFFF38B4A),
                            ),
                            child: Center(
                              child: CustomImageHandler(
                                AppImages.iconsSliders,
                                height: 24.r,
                                width: 24.r,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    BookingServicesType(),
                    26.verticalSpace,
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  Container(
                    width: 315.w,
                    height: 144.h,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF38B4A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                  CustomPaint(
                    size: Size(
                      305.w,
                      144.h,
                    ), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                    painter: RPSCustomPainter(),
                  ),
                  ClipPath(
                    clipper: RPSClipper(),
                    child: CustomImageHandler(
                      AppImages.imagesWedding5,
                      fit: BoxFit.cover,
                      height: 159.h,
                      width: 292.w,
                    ),
                  ),
                  ClipPath(
                    clipper: RPSClipper(),
                    child: Container(
                      height: 159.h,
                      width: 292.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(-1.0, 1),
                          end: Alignment(1, 0.0),
                          stops: [0, 22.0],
                          colors: [
                            // Colors.red.withValues(alpha: 1.00),
                            // Colors.blue,
                            Colors.black.withValues(alpha: 0.00),
                            Colors.black.withValues(alpha: 0.44),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 4.w,
                    bottom: 10.h,
                    child: CustomImageHandler(
                      AppImages.iconsSpecialOffers,
                      fit: BoxFit.contain,
                      width: 78.r,
                    ),
                  ),
                  Positioned(
                    right: 11.w,
                    bottom: 24.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'قاعه البارون',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.24.w,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 4.r),
                                blurRadius: 24.r,
                                color: Color(0xFF000000).withOpacity(0.50),
                              ),
                            ],
                          ),
                        ),
                        2.verticalSpace,
                        SizedBox(
                          width: 225.w,
                          child: Text(
                            'الاكثر مبيعاً, استمتع بخصم يصل الى 50% على جميع قاعات البارون',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w400,
                              height: 1.30,
                              letterSpacing: -0.24.w,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 2.r),
                                  blurRadius: 20.r,
                                  color: Color(0xFF000000).withOpacity(1.00),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: halls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => NavigationHelper.pushNamed(
                        Routes.bookingServiceDetailsScreen,
                      ),
                      child: Directionality(
                      textDirection:
                          index % 2 == 1
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: CustomImageHandler(
                              halls[index].images.first,
                              fit: BoxFit.cover,
                              width: 113.w,
                              height: 137.h,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 89.h,
                              decoration: ShapeDecoration(
                                color: const Color(0x33D9D9D9),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      index % 2 == 1
                                          ? BorderRadius.only(
                                            topRight: Radius.circular(16.r),
                                            bottomRight: Radius.circular(16.r),
                                          )
                                          : BorderRadius.only(
                                            topLeft: Radius.circular(16.r),
                                            bottomLeft: Radius.circular(16.r),
                                          ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 4.h,
                                ),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'قاعه الؤلؤه',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: const Color(0xFF2C262C),
                                              fontSize: 15.r,
                                              fontFamily: 'Almarai',
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: -0.24,
                                            ),
                                          ),
                                          Spacer(),
                                          CustomImageHandler(
                                            AppImages.iconsStar,
                                            height: 24.r,
                                            width: 24.r,
                                          ),
                                          Text(
                                            '4.6',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: const Color(0xFF2C262C),
                                              fontSize: 12.r,
                                              fontFamily: 'Almarai',
                                              fontWeight: FontWeight.w400,
                                              height: 1.33,
                                              letterSpacing: -0.24,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'قاعه الؤلؤه تمتاز بالمساحه الواسعه وقد تسع الى +500 فرد وخدمه المتواصله . . .',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: const Color(0xFF787878),
                                          fontSize: 12.r,
                                          fontFamily: 'Almarai',
                                          fontWeight: FontWeight.w400,
                                          height: 1.33,
                                          letterSpacing: -0.24.w,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Spacer(),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'يبدأ بـ ',
                                                  style: TextStyle(
                                                    color: const Color(
                                                      0xFF2C262C,
                                                    ),
                                                    fontSize: 12.r,
                                                    fontFamily: 'Almarai',
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.25,
                                                    letterSpacing: -0.24,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '1100',
                                                  style: TextStyle(
                                                    color: const Color(
                                                      0xFFF38B4A,
                                                    ),
                                                    fontSize: 16.r,
                                                    fontFamily: 'Almarai',
                                                    fontWeight: FontWeight.w800,
                                                    height: 1.50,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: ' ',
                                                  style: TextStyle(
                                                    color: const Color(
                                                      0xFF2C262C,
                                                    ),
                                                    fontSize: 16.r,
                                                    fontFamily: 'Almarai',
                                                    fontWeight: FontWeight.w800,
                                                    height: 1.50,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: 'جنيه',
                                                  style: TextStyle(
                                                    color: const Color(
                                                      0xFF6F767E,
                                                    ),
                                                    fontSize: 11.r,
                                                    fontFamily: 'Almarai',
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.50,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => 8.verticalSpace,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.6487222, 0);
    path_0.cubicTo(
      size.width * 0.8379510,
      size.height * 0.08532639,
      size.width * 0.9908660,
      size.height * 0.2106528,
      size.width * 0.9966830,
      size.height * 0.3933681,
    );
    path_0.cubicTo(
      size.width * 1.007242,
      size.height * 0.7248403,
      size.width * 0.5231013,
      size.height * 0.9145139,
      size.width * 0.2233627,
      size.height,
    );
    path_0.lineTo(size.width * 0.05228758, size.height);
    path_0.cubicTo(
      size.width * 0.02341176,
      size.height,
      0,
      size.height * 0.9502500,
      0,
      size.height * 0.8888889,
    );
    path_0.lineTo(0, size.height * 0.1111111);
    path_0.cubicTo(
      0,
      size.height * 0.04975000,
      size.width * 0.02341176,
      0,
      size.width * 0.05228758,
      0,
    );
    path_0.lineTo(size.width * 0.6487222, 0);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Color(0xffFFB88C).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RPSClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double r = 16.r;

    Path path = Path();

    // ---- TOP ----
    path.moveTo(size.width * 0.6025797, 0);
    path.cubicTo(
      size.width * 0.8141356,
      size.height * 0.08167296,
      size.width * 0.9934949,
      size.height * 0.2064843,
      size.width * 0.9998271,
      size.height * 0.3954214,
    );

    // ---- RIGHT / BOTTOM ----
    path.cubicTo(
      size.width * 1.011668,
      size.height * 0.7487358,
      size.width * 0.4052847,
      size.height * 0.9336730,
      size.width * 0.1260508,
      size.height,
    );

    // ---- Bottom edge (before bottom-left corner) ----
    path.lineTo(r, size.height);

    // ---- Bottom-left rounded corner ----
    path.quadraticBezierTo(0, size.height, 0, size.height - r);

    // ---- Left edge ----
    path.lineTo(0, r);

    // ---- Top-left rounded corner ----
    path.quadraticBezierTo(0, 0, r, 0);

    // ---- Back to start ----
    path.lineTo(size.width * 0.6025797, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
