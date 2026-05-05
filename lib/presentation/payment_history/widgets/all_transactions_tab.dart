
import 'package:evexcustomer/presentation/payment_history/widgets/transaction_item.dart';
import 'package:flutter/material.dart';


import '../../../app/widgets/retry_widget.dart';
import '../../../app/widgets/shimmer_skelton.dart';

class AllTransactionsTab  extends StatelessWidget {
  const AllTransactionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return false==true
        ? const CustomLoader()
        : "" == null
        ? RetryWidget(
      onRetry: () async {
        // controller.getInstantPays();
      },
    )
        : ("").isEmpty
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
          itemCount: 5,
          separatorBuilder:
              (context, index) =>
          const Divider(color: Color(0xFFD9D9D9)),
          itemBuilder: (context, index) {
            // final transaction = controlleransactions.value![index];
            return TransactionItem();
          },
        ),
      ),
    );
  }
}

