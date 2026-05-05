import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/widgets/custom_back_button.dart';
import '../../../app/widgets/custom_button.dart';
import '../../../app/widgets/section_seperator.dart';
import '../widgets/change_occasion.dart';
import '../widgets/notes_section.dart';
import '../widgets/service_cost_details_section.dart';
import '../widgets/vendor_policies_section.dart' show VendorPoliciesSection;

class CompleteBookingScreen extends StatelessWidget {
  const CompleteBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
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
                        child: ChangeOccasion(),
                      ),

                      22.verticalSpace,
                      SectionSeperator(),
                      22.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: ServiceCostDetailsSection(),
                      ),
                      22.verticalSpace,
                      SectionSeperator(),
                      22.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: VendorPoliciesSection(),
                      ),
                      22.verticalSpace,
                      SectionSeperator(),
                      22.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: NotesSection(),
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
                        onTap: () {},
                        // onTap: () => controller.prepareFinalAdditions(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
