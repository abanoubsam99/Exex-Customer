import 'package:evex_user/data/repos/port_services_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'contact_info_state.dart';

class ContactInfoCubit extends Cubit<ContactInfoState> {
  final PortServicesRepo _repo;
  final int portId;

  ContactInfoCubit(this._repo, {required this.portId}) : super(const ContactInfoState()) {
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
