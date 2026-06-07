import 'package:evex_user/core/ui/helpers/custom_loader.dart';
import 'package:evex_user/core/ui/widgets/retry_widget.dart';
import 'package:evex_user/data/cubits/payment_history/payment_history_cubit.dart';
import 'package:evex_user/data/cubits/payment_history/payment_history_state.dart';
import 'package:evex_user/features/payment_history/ui/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllTransactionsTab extends StatelessWidget {
  const AllTransactionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentHistoryCubit, PaymentHistoryState>(
      builder: (context, state) {
        if (state.isLoading) return const CustomLoader();

        if (state.transactions.isEmpty) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<PaymentHistoryCubit>().loadTransactions();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Center(child: Text('لا يوجد سجلات'))],
                    ),
                  ),
                ),
              );
            },
          );
        }

        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<PaymentHistoryCubit>().loadTransactions();
            },
            child: ListView.separated(
              itemCount: state.transactions.length,
              separatorBuilder: (context, index) =>
                  const Divider(color: Color(0xFFD9D9D9)),
              itemBuilder: (context, index) {
                return TransactionItem(
                    transaction: state.transactions[index]);
              },
            ),
          ),
        );
      },
    );
  }
}
