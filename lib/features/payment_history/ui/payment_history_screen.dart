import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/data/cubits/payment_history/payment_history_state.dart';
import 'package:evex_user/features/payment_history/ui/widgets/transactions_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            initialIndex: 0,
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
                        color: AppColors.black,
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
                    color: AppColors.boarderColor,
                  ),
                  child: TabBar(
                    padding: EdgeInsets.all(4.r),
                    labelPadding: EdgeInsets.zero,
                    labelColor: AppColors.secondaryColor,
                    labelStyle: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                    ),
                    unselectedLabelStyle: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w400,
                    ),
                    indicatorColor: Colors.transparent,
                    dividerColor: Colors.transparent,
                    unselectedLabelColor: AppColors.grey,
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
                                color: AppColors.red3,
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
                                color: AppColors.greenSoft,
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
                      TransactionsTab(filter: PaymentFilter.all),
                      TransactionsTab(filter: PaymentFilter.payments),
                      TransactionsTab(filter: PaymentFilter.refunds),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
