import 'package:evex_user/data/repos/port_services_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'contact_info_state.dart';

class ContactInfoCubit extends Cubit<ContactInfoState> {
  final PortServicesRepo _repo;
  final int portId;

  /// True when opened from an instant-booking (حجز فوري) service. Only there
  /// are the merchant's numbers gated behind GetPortContactInfo — the endpoint
  /// releases them after the booking is completed.
  final bool isBookingService;

  /// The numbers carried by the port itself (phoneNumber1 / phoneNumber2).
  /// Direct-payment services show these straight away — no API call.
  final List<String> portPhones;

  ContactInfoCubit(
    this._repo, {
    required this.portId,
    this.isBookingService = false,
    this.portPhones = const [],
  }) : super(const ContactInfoState()) {
    if (!isBookingService) {
      // Direct services: the numbers are public and already part of the port
      // data, so GetPortContactInfo must not be called here.
      emit(state.copyWith(isLoading: false, phones: portPhones));
      return;
    }
    if (portId > 0) {
      _loadPhones();
    } else {
      emit(state.copyWith(isLoading: false, hasError: true));
    }
  }

  Future<void> _loadPhones() async {
    emit(state.copyWith(isLoading: true, hasError: false));
    final phones = await _repo.getPortContactInfo(portId);
    if (phones != null) {
      emit(state.copyWith(isLoading: false, phones: phones));
    } else {
      emit(state.copyWith(isLoading: false, hasError: true));
    }
  }
}
