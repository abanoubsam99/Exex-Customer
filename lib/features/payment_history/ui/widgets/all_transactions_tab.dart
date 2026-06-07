import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/helpers/custom_loader.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/retry_widget.dart';
import 'package:evex_user/features/payment_history/data/models/transaction_model.dart';
import 'package:evex_user/features/payment_history/logic/payment_history_controller.dart';
import 'package:evex_user/features/payment_history/ui/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;

class AllTransactionsTab extends GetView<PaymentHistoryController> {
  const AllTransactionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.isLoading.value
              ? const CustomLoader()
              : controller.transactions.value == null
              ? RetryWidget(
                onRetry: () async {
                  // controller.getInstantPays();
                },
              )
              : (controller.transactions.value!).isEmpty
              ? LayoutBuilder(
                builder: (context, constraints) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      // controller.getInstantPays();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Center(child: Text('لا يوجد سجلات'))],
                        ),
                      ),
                    ),
                  );
                },
              )
              : Padding(
                padding: const EdgeInsets.only(top: 10),
                child: RefreshIndicator(
                  onRefresh: () async {
                    // controller.getInstantPays();
                  },
                  child: ListView.separated(
                    itemCount: controller.transactions.value?.length ?? 0,
                    separatorBuilder:
                        (context, index) =>
                            const Divider(color: Color(0xFFD9D9D9)),
                    itemBuilder: (context, index) {
                      final transaction = controller.transactions.value![index];
                      return TransactionItem(transaction: transaction);
                    },
                  ),
                ),
              ),
    );
  }
}

