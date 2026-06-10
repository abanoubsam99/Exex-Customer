import 'package:evex_user/data/repos/contact_us_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  final ContactUsRepo _repo;

  ContactUsCubit(this._repo) : super(const ContactUsState());

  /// Loads contact info + branches in parallel.
  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    final contactInfoFuture = _repo.getContactInfo();
    final branchesFuture = _repo.getBranches();
    final contactInfo = await contactInfoFuture;
    final branches = await branchesFuture;
    emit(state.copyWith(
      isLoading: false,
      contactInfo: contactInfo,
      branches: branches ?? const [],
    ));
  }
}
