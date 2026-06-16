import 'package:evex_user/data/models/order_details_model.dart';

class OrderDetailsState {
  final bool isLoading;
  final OrderDetailsModel? order;
  final String? errorMessage;
  final bool isSubmittingReview;

  const OrderDetailsState({
    this.isLoading = false,
    this.order,
    this.errorMessage,
    this.isSubmittingReview = false,
  });

  OrderDetailsState copyWith({
    bool? isLoading,
    OrderDetailsModel? order,
    String? errorMessage,
    bool? isSubmittingReview,
  }) {
    return OrderDetailsState(
      isLoading: isLoading ?? this.isLoading,
      order: order ?? this.order,
      errorMessage: errorMessage,
      isSubmittingReview: isSubmittingReview ?? this.isSubmittingReview,
    );
  }
}
