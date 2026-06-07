import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/custom_circle.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/gradient_text.dart';
import 'package:evex_user/core/ui/widgets/section_seperator.dart';
import 'package:evex_user/features/booking_services/booking_service_details/logic/port_services_controller.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/additions_section.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/buffets_section.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/change_occasion.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/other_services_section.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/reviews_section.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/service_top_part.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/services_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BookingServiceDetailsScreen extends GetView<PortServicesController> {
  const BookingServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomSheet: Container(
      //   width: 1.sw,
      //   height: 154.h,
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     boxShadow: [
      //       BoxShadow(
      //         color: Color(0x19000000),
      //         blurRadius: 48,
      //         offset: Offset(0, -7),
      //         spreadRadius: -6,
      //       ),
      //     ],
      //   ),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       CustomButton(
      //         text: "add",
      //         onTap: () => controller.prepareFinalAdditions(),
      //       ),
      //     ],
      //   ),
      // ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ServiceTopPart(),
                  16.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        Text(
                          'قاعه الؤلؤه تمتاز بالمساحه الواسعه وقد تسع الى +500 فرد وخدمه المتواصله . . .',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: const Color(0xFF787878),
                            fontSize: 13.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.54,
                            letterSpacing: -0.24,
                          ),
                        ),
                        20.verticalSpace,
                        ChangeOccasion(),
                        24.verticalSpace,
                        ServicesSection(),
                      ],
                    ),
                  ),
                  22.verticalSpace,
                  SectionSeperator(),
                  22.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: AdditionsSection(),
                  ),
                  22.verticalSpace,
                  SectionSeperator(),
                  22.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: BuffetsSection(),
                  ),
                  22.verticalSpace,
                  SectionSeperator(),
                  22.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: ReviewsSection(),
                  ),
                  22.verticalSpace,
                  SectionSeperator(),
                  22.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: OtherServicesSection(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 1.sw,
            height: 154.h,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 48,
                  offset: Offset(0, -7),
                  spreadRadius: -6,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'إجمالي التكلفة',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFF6F767E),
                          fontSize: 18.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w800,
                          height: 1.50,
                        ),
                      ),
                      Spacer(),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '9999.99',
                              style: TextStyle(
                                color: const Color(0xFFF38B4A),
                                fontSize: 20.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w800,
                                height: 1.50,
                              ),
                            ),
                            TextSpan(
                              text: ' ',
                              style: TextStyle(
                                color: const Color(0xFF6F767E),
                                fontSize: 20.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            TextSpan(
                              text: 'جنيه',
                              style: TextStyle(
                                color: const Color(0xFFA5B7C6),
                                fontSize: 14.r,
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
                  16.verticalSpace,
                  CustomButton(
                    height: 52.h,
                    text: "إضافة لحجوزاتي",
                    onTap: () => controller.prepareFinalAdditions(),
                  ),
                ],
              ),
            ),
          ),
        ],
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

// class CustomTextFieldWithLE extends StatefulWidget {
//   const CustomTextFieldWithLE({super.key});

//   @override
//   State<CustomTextFieldWithLE> createState() => _CustomTextFieldWithLEState();
// }

// class _CustomTextFieldWithLEState extends State<CustomTextFieldWithLE> {
//   final TextEditingController _controller = TextEditingController();
//   double _textWidth = 0;

//   @override
//   void initState() {
//     super.initState();
//     _controller.addListener(_updateTextWidth);
//   }

//   void _updateTextWidth() {
//     final textPainter = TextPainter(
//       text: TextSpan(
//         text: _controller.text,
//         style: const TextStyle(fontSize: 16),
//       ),
//       maxLines: 1,
//       textDirection: TextDirection.ltr,
//     )..layout();

//     setState(() {
//       _textWidth = textPainter.width;
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         TextField(
//           onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
//           controller: _controller,
//           style: TextStyle(
//             color: const Color(0xFFF38B4A),
//             fontSize: 16.r,
//             fontFamily: 'Almarai',
//             fontWeight: FontWeight.w700,
//             letterSpacing: -0.24,
//           ),

//           decoration: const InputDecoration(border: InputBorder.none),
//           keyboardType: TextInputType.number,
//           textDirection: TextDirection.ltr,
//         ),
//         Positioned(
//           left: _textWidth + 3.w,
//           top: 0,
//           bottom: 0,
//           child: Center(
//             child: Text(
//               'LE',
//               textAlign: TextAlign.right,
//               style: TextStyle(
//                 color: const Color(0xFFA5B7C6),
//                 fontSize: 12.r,
//                 fontFamily: 'Almarai',
//                 fontWeight: FontWeight.w400,
//                 letterSpacing: -0.24,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
