import 'package:evex_user/core/ui/helpers/custom_loader.dart';
import 'package:evex_user/data/cubits/payment_history/payment_history_cubit.dart';
import 'package:evex_user/data/cubits/payment_history/payment_history_state.dart';
import 'package:evex_user/features/payment_history/ui/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// One tab of the payment history — filters operations by [filter].
class TransactionsTab extends StatelessWidget {
  final PaymentFilter filter;
  const TransactionsTab({super.key, this.filter = PaymentFilter.all});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentHistoryCubit, PaymentHistoryState>(
      builder: (context, state) {
        // Full-screen loader only on the first load; refresh keeps the list.
        if (state.isLoading && state.transactions.isEmpty) {
          return const CustomLoader();
        }

        final items = state.filtered(filter);

        if (items.isEmpty) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<PaymentHistoryCubit>().loadTransactions(),
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
            onRefresh: () =>
                context.read<PaymentHistoryCubit>().loadTransactions(),
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (context, index) =>
                  const Divider(color: Color(0xFFD9D9D9)),
              itemBuilder: (context, index) {
                return TransactionItem(transaction: items[index]);
              },
            ),
          ),
        );
      },
    );
  }
}
