import 'package:evex_user/data/models/transaction_model.dart';

/// فلتر تابات سجل المدفوعات.
enum PaymentFilter { all, payments, refunds }

extension PaymentFilterX on PaymentFilter {
  /// قيمة operationType اللي بتتبعت للـ API لكل تاب:
  /// '' = الكل، Paying = المدفوعات، Refund = الاستردادات.
  String get operationType {
    switch (this) {
      case PaymentFilter.all:
        return '';
      case PaymentFilter.payments:
        return 'Paying';
      case PaymentFilter.refunds:
        return 'Refund';
    }
  }
}

/// State بتاع تاب واحد: الليستة + حالة الـ pagination الخاصة بيه.
class PaymentTabData {
  /// تحميل أول صفحة (full-screen loader).
  final bool isLoading;

  /// تحميل صفحة إضافية (load more في آخر الليستة).
  final bool isLoadingMore;

  /// لسه فيه صفحات بعد كده؟
  final bool hasMore;

  /// رقم الصفحة الجاية اللي هتتجاب من السيرفر.
  final int nextIndex;

  final List<TransactionModel> items;
  final String? error;

  const PaymentTabData({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.nextIndex = 0,
    this.items = const [],
    this.error,
  });

  PaymentTabData copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? nextIndex,
    List<TransactionModel>? items,
    String? error,
  }) {
    return PaymentTabData(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      nextIndex: nextIndex ?? this.nextIndex,
      items: items ?? this.items,
      error: error,
    );
  }
}

class PaymentHistoryState {
  /// State منفصل لكل تاب (الكل / المدفوعات / الاستردادات).
  final Map<PaymentFilter, PaymentTabData> tabs;

  const PaymentHistoryState({this.tabs = const {}});

  PaymentTabData tab(PaymentFilter filter) =>
      tabs[filter] ?? const PaymentTabData();

  PaymentHistoryState copyWithTab(PaymentFilter filter, PaymentTabData data) {
    return PaymentHistoryState(tabs: {...tabs, filter: data});
  }
}
