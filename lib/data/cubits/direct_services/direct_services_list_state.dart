import 'package:evex_user/data/models/ports_respond_model.dart';

class DirectServicesListState {
  final bool isLoading;
  final PortsRespondModel? portsModel;
  final String? errorMessage;

  const DirectServicesListState({
    this.isLoading = false,
    this.portsModel,
    this.errorMessage,
  });

  DirectServicesListState copyWith({
    bool? isLoading,
    PortsRespondModel? portsModel,
    String? errorMessage,
  }) {
    return DirectServicesListState(
      isLoading: isLoading ?? this.isLoading,
      portsModel: portsModel ?? this.portsModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
