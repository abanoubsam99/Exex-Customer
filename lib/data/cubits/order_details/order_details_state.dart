import 'package:evex_user/data/models/order_details_model.dart';

class OrderDetailsState {
  final bool isLoading;
  final OrderDetailsModel? order;
  final String? errorMessage;

  const OrderDetailsState({
    this.isLoading = false,
    this.order,
    this.errorMessage,
  });

  OrderDetailsState copyWith({
    bool? isLoading,
    OrderDetailsModel? order,
    String? errorMessage,
  }) {
    return OrderDetailsState(
      isLoading: isLoading ?? this.isLoading,
      order: order ?? this.order,
      errorMessage: errorMessage,
    );
  }
}
