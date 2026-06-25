import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/helpers/auth_guard.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/section_seperator.dart';
import 'package:evex_user/data/cubits/booking_services/booking_service_details/booking_service_details_cubit.dart';
import 'package:evex_user/data/cubits/booking_services/booking_service_details/booking_service_details_state.dart';
import 'package:evex_user/data/cubits/complete_booking/complete_booking_state.dart';
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/additions_section.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/buffets_section.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/change_occasion.dart';
// OccasionPicker moved into the edit sheet (تعديل تاريخ ومكان المناسبة).
// import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/occasion_picker.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/other_services_section.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/reviews_section.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/service_top_part.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/services_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class BookingServiceDetailsScreen extends StatelessWidget {
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
      //         color: AppColors.shadow,
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
                        BlocBuilder<BookingServiceDetailsCubit,
                            BookingServiceDetailsState>(
                          buildWhen: (p, c) => p.port != c.port,
                          builder: (context, state) {
                            final desc =
                                state.port?.portDescription?.toString().trim();
                            return Text(
                              (desc != null && desc.isNotEmpty)
                                  ? desc
                                  : 'لا يوجد وصف متاح لهذه الخدمة',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: AppColors.grey2,
                                fontSize: 13.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w400,
                                height: 1.54,
                                letterSpacing: -0.24,
                              ),
                            );
                          },
                        ),
                        20.verticalSpace,
                        // نوع المناسبة is picked inside this card's edit sheet
                        // ("تعديل تاريخ ومكان المناسبة"), so it stays in sync
                        // with the cubit's occasions/selectedOccasionId.
                        BlocBuilder<BookingServiceDetailsCubit,
                            BookingServiceDetailsState>(
                          buildWhen: (p, c) =>
                              p.port != c.port ||
                              p.occasions != c.occasions ||
                              p.selectedOccasionId != c.selectedOccasionId ||
                              p.isEditMode != c.isEditMode ||
                              p.editOriginalDate != c.editOriginalDate ||
                              p.editOriginalGovernorate !=
                                  c.editOriginalGovernorate ||
                              p.editOriginalCity != c.editOriginalCity,
                          builder: (context, state) => ChangeOccasion(
                            port: state.port,
                            occasionDate:
                                context.read<HomeCubit>().state.bookingDate,
                            occasions: state.occasions,
                            selectedOccasionId: state.selectedOccasionId,
                            // Edit mode: keeping the original date + place means
                            // the only conflict is the user's own reservation,
                            // so the slot is shown as available (instant).
                            isEditMode: state.isEditMode,
                            editOriginalDate: state.editOriginalDate,
                            editOriginalGovernorate:
                                state.editOriginalGovernorate,
                            editOriginalCity: state.editOriginalCity,
                            onOccasionSelected: (id) {
                              if (id != null) {
                                context
                                    .read<BookingServiceDetailsCubit>()
                                    .selectOccasion(id);
                              }
                            },
                          ),
                        ),
                        24.verticalSpace,
                        // نوع المناسبة moved into the edit sheet (per design) —
                        // no longer a standalone field on this screen.
                        // BlocBuilder<BookingServiceDetailsCubit,
                        //     BookingServiceDetailsState>(
                        //   buildWhen: (p, c) =>
                        //       p.occasions != c.occasions ||
                        //       p.selectedOccasionId != c.selectedOccasionId,
                        //   builder: (context, state) => OccasionPicker(
                        //     occasions: state.occasions,
                        //     selectedId: state.selectedOccasionId,
                        //     onSelected: context
                        //         .read<BookingServiceDetailsCubit>()
                        //         .selectOccasion,
                        //   ),
                        // ),
                        // 24.verticalSpace,
                        ServicesSection(),
                      ],
                    ),
                  ),
                  // Each optional section is hidden (together with its leading
                  // separator) when it has no data, so we never show an empty
                  // header like "الإضافات" / "البوفيه".
                  BlocBuilder<BookingServiceDetailsCubit,
                      BookingServiceDetailsState>(
                    builder: (context, state) {
                      Widget sectionBlock(Widget child) => Column(
                            children: [
                              22.verticalSpace,
                              const SectionSeperator(),
                              22.verticalSpace,
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 24.w),
                                child: child,
                              ),
                            ],
                          );
                      return Column(
                        children: [
                          // if (state.additions.isNotEmpty)
                            sectionBlock(const AdditionsSection()),
                          // البوفيه يظهر فقط في بورت القاعات (portCategoryNameEn == "Halls").
                          if (state.port?.portTypeDto?.portCategoryNameEn ==
                              'Halls')
                            sectionBlock(const BuffetsSection()),
                          // if (state.reviews.isNotEmpty)
                            sectionBlock(const ReviewsSection()),
                          // Only when the vendor has other ports to show.
                          // if (state.otherPorts.isNotEmpty)
                            sectionBlock(const OtherServicesSection()),
                          45.verticalSpace,

                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          Container(
            width: 1.sw,
            height: 130.h,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 48,
                  offset: Offset(0, -7),
                  spreadRadius: -6,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'إجمالي التكلفة',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 18.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w800,
                          height: 1.50,
                        ),
                      ),
                      Spacer(),
                      BlocBuilder<BookingServiceDetailsCubit,
                          BookingServiceDetailsState>(
                        buildWhen: (p, c) => p.totalCost != c.totalCost,
                        builder: (context, state) => Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: state.totalCost
                                    .toStringAsFixed(2),
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 20.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w800,
                                  height: 1.50,
                                ),
                              ),
                              TextSpan(
                                text: ' ',
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 20.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                              ),
                              TextSpan(
                                text: 'جنيه',
                                style: TextStyle(
                                  color: AppColors.unitGrey,
                                  fontSize: 14.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  8.verticalSpace,
                  BlocBuilder<BookingServiceDetailsCubit,
                      BookingServiceDetailsState>(
                    buildWhen: (p, c) =>
                        p.isEditMode != c.isEditMode || p.isSaving != c.isSaving,
                    builder: (context, state) => CustomButton(
                      height: 52.h,
                      isLoading: state.isSaving,
                      // Same module for add + edit; only the button differs.
                      text: state.isEditMode ? 'تأكيد التعديل' : 'إضافة لحجوزاتي',
                      onTap: () {
                        // Account action — guests must sign in first.
                        if (!AuthGuard.requireLogin(context)) return;
                        final cubit =
                            context.read<BookingServiceDetailsCubit>();
                        final st = cubit.state;
                        if (st.totalCost <= 0) {
                          ToastManager.showError('من فضلك اختر خدمة أولاً');
                          return;
                        }
                        // نوع المناسبة مطلوب لاستكمال الحجز.
                        if ((st.selectedOccasionId ?? 0) <= 0) {
                          ToastManager.showError(
                              'حدد نوع المناسبة لإستكمال الحجز');
                          return;
                        }
                        // Edit → update the reservation in place (no new booking).
                        if (st.isEditMode) {
                          cubit.submitEdit();
                          return;
                        }
                        NavigationHelper.pushNamed(
                          Routes.completeBookingScreen,
                          arguments: CompleteBookingArgs(
                            port: st.port,
                            service: st.selectedService,
                            additions: cubit.prepareFinalAdditions(),
                            totalCost: st.totalCost,
                            occasionId: st.selectedOccasionId,
                            occasionDate:
                                context.read<HomeCubit>().state.bookingDate,
                          ),
                        );
                      },
                    ),
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
    paint0Fill.color = AppColors.lightOrangeColor.withOpacity(1.0);
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
//             color: AppColors.primaryColor,
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
//                 color: AppColors.unitGrey,
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
