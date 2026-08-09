import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/section_seperator.dart';
import 'package:evex_user/data/cubits/complete_booking/complete_booking_cubit.dart';
import 'package:evex_user/data/cubits/complete_booking/complete_booking_state.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/change_occasion.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/notes_section.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/service_cost_details_section.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/vendor_policies_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class CompleteBookingScreen extends StatelessWidget {
  const CompleteBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CompleteBookingCubit>();
    final args = cubit.args;
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CompleteBookingCubit, CompleteBookingState>(
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                  child: Row(
                    children: [
                      const CustomBackButtonWidget(),
                      12.horizontalSpace,
                      Text(
                        'استكمال الحجز',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 18.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.24,
                        ),
                      ),
                    ],
                  ),
                ),
                24.verticalSpace,
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: ChangeOccasion(
                            port: args.port,
                            occasionDate: args.occasionDate,
                            occasions: state.occasions,
                            selectedOccasionId: state.selectedOccasionId,
                            // Edit mode: the user's own unchanged slot is shown
                            // as available (same as the service-details screen).
                            isEditMode: args.isEditMode,
                            editOriginalDate: args.editOriginalDate,
                            editOriginalGovernorate: args.editOriginalGovernorate,
                            editOriginalCity: args.editOriginalCity,
                            onOccasionSelected: (id) {
                              if (id != null) cubit.selectOccasion(id);
                            },
                          ),
                        ),
                        16.verticalSpace,
                        SectionSeperator(),
                        22.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: ServiceCostDetailsSection(
                            policy: state.policy,
                            totalCost: args.totalCost,
                            netCost: state.netCost,
                          ),
                        ),
                        22.verticalSpace,
                        SectionSeperator(),
                        22.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: VendorPoliciesSection(
                            policy: state.policy,
                            accepted: state.termsAccepted,
                            onTermsChanged: cubit.toggleTerms,
                          ),
                        ),
                        22.verticalSpace,
                        SectionSeperator(),
                        22.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: NotesSection(controller: cubit.notesController),
                        ),
                        34.verticalSpace,
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
                        color: AppColors.shadow,
                        blurRadius: 48,
                        offset: Offset(0, -7),
                        spreadRadius: -6,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.h,
                    ),
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
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    // Same source as the top "إجمالى التكلفة"
                                    // (ServiceCostDetailsSection): the net cost
                                    // from CalculateNetCost, falling back to the
                                    // passed total until it arrives.
                                    text: (state.netCost?.netCost ??
                                            args.totalCost)
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
                          ],
                        ),
                        16.verticalSpace,
                        CustomButton(
                          height: 52.h,
                          text: args.isEditMode ? "تعديل الحجز" : "إضافة لحجوزاتي",
                          isLoading: state.isSubmitting,
                          onTap: cubit.submit,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

