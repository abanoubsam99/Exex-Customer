import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/cubits/confirm_booking/confirm_booking_state.dart';
import 'package:evex_user/data/models/reservation_models.dart';
import 'package:evex_user/data/repos/confirm_booking_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'complete_booking_state.dart';

class CompleteBookingCubit extends Cubit<CompleteBookingState> {
  final ConfirmBookingRepo _repo;
  final CompleteBookingArgs args;

  CompleteBookingCubit(this._repo, {required this.args})
      : super(const CompleteBookingState()) {
    getPortPolicy();
  }

  final notesController = TextEditingController();

  /// سياسات التاجر للبوابة المختارة في الشاشة السابقة.
  Future<void> getPortPolicy() async {
    final portId = args.port?.id;
    if (portId == null) return;
    emit(state.copyWith(isLoadingPolicy: true));
    final policy = await _repo.getPortPolicy(portId);
    emit(state.copyWith(isLoadingPolicy: false, policy: policy));
  }

  void toggleTerms(bool value) => emit(state.copyWith(termsAccepted: value));

  /// "إضافة لحجوزاتي": بينشئ طلب الحجز (AddClientReservation) وبعدين يروح
  /// لشاشة تأكيد الحجز ومعاه رقم الطلب + المقدم.
  Future<void> submit() async {
    if (!state.termsAccepted) {
      ToastManager.showError('برجاء الموافقة على الشروط والسياسات أولاً');
      return;
    }
    emit(state.copyWith(isSubmitting: true));
    final note = notesController.text.trim();
    final result = await _repo.addClientReservation(
      AddReservationRequest(
        portId: args.port?.id,
        serviceId: args.service?.id,
        additions: args.additions,
        note: note.isEmpty ? null : note,
        totalCost: args.totalCost,
      ),
    );
    emit(state.copyWith(isSubmitting: false));
    if (result != null && (result.reservationRequestId ?? 0) > 0) {
      NavigationHelper.pushNamed(
        Routes.confirmBookingScreen,
        arguments: ConfirmBookingArgs(
          reservationRequestId: result.reservationRequestId!,
          depositAmount: result.depositAmount ?? 0,
          totalAmount: args.totalCost,
        ),
      );
    } else {
      emit(state.copyWith(errorMessage: 'تعذّر إضافة الحجز، حاول مرة أخرى'));
    }
  }

  @override
  Future<void> close() {
    notesController.dispose();
    return super.close();
  }
}
