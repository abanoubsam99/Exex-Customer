import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/section_seperator.dart';
import 'package:evex_user/data/cubits/complete_booking/complete_booking_cubit.dart';
import 'package:evex_user/data/cubits/complete_booking/complete_booking_state.dart';
import 'package:evex_user/data/models/occasion.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/change_occasion.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/notes_section.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/service_cost_details_section.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/vendor_policies_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                          color: const Color(0xFF121212),
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
                          ),
                        ),
                        16.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: _OccasionPicker(
                            occasions: state.occasions,
                            selectedId: state.selectedOccasionId,
                            onSelected: cubit.selectOccasion,
                          ),
                        ),
                        22.verticalSpace,
                        SectionSeperator(),
                        22.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: ServiceCostDetailsSection(
                            policy: state.policy,
                            totalCost: args.totalCost,
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
                        color: Color(0x19000000),
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
                                    text: args.totalCost.toStringAsFixed(2),
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

/// "نوع المناسبة" picker — required so AddClientReservation gets a valid
/// occasionId (the backend rejects the booking otherwise).
class _OccasionPicker extends StatelessWidget {
  final List<Occasion> occasions;
  final int? selectedId;
  final ValueChanged<int> onSelected;
  const _OccasionPicker({
    required this.occasions,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع المناسبة',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: const Color(0xFF2C262C),
            fontSize: 15.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
          ),
        ),
        8.verticalSpace,
        Container(
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              value: selectedId,
              borderRadius: BorderRadius.circular(14.r),
              hint: Text(
                'حدد نوع المناسبة',
                style: TextStyle(
                  color: const Color(0xFF99A2AC),
                  fontSize: 14.r,
                  fontFamily: 'Almarai',
                ),
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF99A2AC)),
              items: occasions
                  .where((o) => o.id != null)
                  .map((o) => DropdownMenuItem<int>(
                        value: o.id,
                        child: Text(
                          o.name ?? '',
                          style: TextStyle(
                            color: const Color(0xFF2C262C),
                            fontSize: 14.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) onSelected(v);
              },
            ),
          ),
        ),
      ],
    );
  }
}
