import 'package:evex_user/core/ui/helpers/custom_loader.dart';
import 'package:evex_user/data/cubits/payment_history/payment_history_cubit.dart';
import 'package:evex_user/data/cubits/payment_history/payment_history_state.dart';
import 'package:evex_user/features/payment_history/ui/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evex_user/core/theme/app_colors.dart';

/// One tab of the payment history — server-filtered + paginated by [filter].
class TransactionsTab extends StatelessWidget {
  final PaymentFilter filter;
  const TransactionsTab({super.key, this.filter = PaymentFilter.all});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentHistoryCubit, PaymentHistoryState>(
      builder: (context, state) {
        final cubit = context.read<PaymentHistoryCubit>();
        final tab = state.tab(filter);
        final items = tab.items;

        // Full-screen loader only on the first load; refresh keeps the list.
        if (tab.isLoading && items.isEmpty) {
          return const CustomLoader();
        }

        if (items.isEmpty) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return RefreshIndicator(
                onRefresh: () => cubit.loadFirstPage(filter),
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
            onRefresh: () => cubit.loadFirstPage(filter),
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                // Near the bottom → fetch the next page.
                if (notification.metrics.pixels >=
                        notification.metrics.maxScrollExtent - 200 &&
                    tab.hasMore &&
                    !tab.isLoadingMore) {
                  cubit.loadMore(filter);
                }
                return false;
              },
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: items.length + (tab.hasMore ? 1 : 0),
                separatorBuilder: (context, index) =>
                    const Divider(color: AppColors.dividerGrey),
                itemBuilder: (context, index) {
                  // Trailing slot is the load-more spinner.
                  if (index >= items.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  }
                  return TransactionItem(transaction: items[index]);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
