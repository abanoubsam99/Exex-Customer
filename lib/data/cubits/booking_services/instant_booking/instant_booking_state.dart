import 'package:evex_user/data/models/ports_respond_model.dart';

class InstantBookingState {
  final bool isLoading;
  final PortsRespondModel? portsModel;
  final String? errorMessage;

  const InstantBookingState({
    this.isLoading = false,
    this.portsModel,
    this.errorMessage,
  });

  InstantBookingState copyWith({
    bool? isLoading,
    PortsRespondModel? portsModel,
    String? errorMessage,
  }) {
    return InstantBookingState(
      isLoading: isLoading ?? this.isLoading,
      portsModel: portsModel ?? this.portsModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
