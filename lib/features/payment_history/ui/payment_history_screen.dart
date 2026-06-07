import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/features/payment_history/ui/widgets/all_transactions_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: DefaultTabController(
            length: 3,
            initialIndex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomBackButtonWidget(),
                    12.horizontalSpace,
                    Text(
                      'سجل المدفوعات',
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
                24.verticalSpace,
                Container(
                  height: 38.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.r),
                    color: const Color(0xFFF2F4F7),
                  ),
                  child: TabBar(
                    onTap: (v) {
                      // controller.index.value = v;
                      // if (v == 0) {
                      //   controller.getInstantPays();
                      // }
                      // if (v == 1) {
                      //   controller.getResPaysData();
                      // }
                      // if (v == 2) {
                      //   controller.getTransfers(
                      //     request: GetAllFinanceilasRequestModel(
                      //       companyId: UserService.to.currentUser!.value!.modelId!,
                      //       type: 'transfer',
                      //       index: 0,
                      //       from: controller.startDateController.text,
                      //       to: controller.endDateController.text,
                      //     ),
                      //   );
                      // }
                    },
                    padding: EdgeInsets.all(4.r),
                    labelPadding: EdgeInsets.zero,
                    labelColor: AppColors.secondaryColor,
                    labelStyle: TextStyle(
                      color: const Color(0xFFF38B4A),
                      fontSize: 16.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                    ),
                    unselectedLabelStyle: TextStyle(
                      color: const Color(0xFF6F767E),
                      fontSize: 14.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w400,
                    ),
                    indicatorColor: Colors.transparent,
                    dividerColor: Colors.transparent,
                    unselectedLabelColor: const Color(0xff6F767E),
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: Colors.white,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Text('الكل'),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Text('المدفوعات'),
                          Positioned(
                            bottom: -3.5.r,
                            right: -6.5.r,
                            child: Container(
                              width: 7.r,
                              height: 7.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFEF6164),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Text('الاستردادات'),
                          Positioned(
                            bottom: -3.5.r,
                            right: -6.5.r,
                            child: Container(
                              width: 7.r,
                              height: 7.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF79E2B2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      AllTransactionsTab(),
                      // SizedBox(),
                      SizedBox(),
                      SizedBox(),
                      // TabBarInstantPay(),
                      // TabBarReceivingAndDisbursing(),
                      // TabBarTransfers(),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                //   child: Obx(
                //     () => CustomButton(
                //       text: controller.index.value == 0
                //           ? "اضافه دفع مباشر"
                //           : controller.index.value == 1
                //               ? 'اضافه استلام/صرف'
                //               : 'اضافه تحويل',
                //       onTap: () {
                //         controller.index.value == 0
                //             ? Get.toNamed(Routes.addInstantPay)
                //             : controller.index.value == 1
                //                 ? Get.toNamed(Routes.addResPay)
                //                 : Get.toNamed(Routes.addTransfer);
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
