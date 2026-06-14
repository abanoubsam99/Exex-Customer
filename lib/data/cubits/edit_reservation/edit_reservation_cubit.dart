import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/models/reservation_models.dart';
import 'package:evex_user/data/repos/confirm_booking_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'edit_reservation_state.dart';

class EditReservationCubit extends Cubit<EditReservationState> {
  final ConfirmBookingRepo _repo;
  final EditReservationArgs args;

  EditReservationCubit(this._repo, {required this.args})
      : super(EditReservationState(occasionDate: args.occasionDate)) {
    notesController.text = args.userNotes ?? '';
  }

  final notesController = TextEditingController();

  void setDate(DateTime date) => emit(state.copyWith(occasionDate: date));

  Future<void> save() async {
    final date = state.occasionDate;
    final gov = args.governorate;
    final city = args.city;
    if (date == null || (gov ?? '').isEmpty || (city ?? '').isEmpty) {
      ToastManager.showError(
        'بيانات المناسبة غير مكتملة (التاريخ/المحافظة/المدينة)',
      );
      return;
    }

    emit(state.copyWith(isSaving: true));
    final request = AddReservationRequest(
      portId: args.portId,
      serviceId: args.serviceId,
      occasionId: args.occasionId,
      governorate: gov,
      city: city,
      occasionDate: _formatDate(date),
      userNotes: notesController.text.trim(),
    );
    final ok = args.isConfirmed
        ? await _repo.updateReservationByClient(args.reservationId, request)
        : await _repo.updateReservationRequest(args.reservationId, request);
    emit(state.copyWith(isSaving: false));
    if (ok) {
      ToastManager.showSuccess('تم تعديل الحجز بنجاح');
      NavigationHelper.pop();
    } else {
      ToastManager.showError('تعذّر تعديل الحجز، حاول مرة أخرى');
    }
  }

  static String _formatDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  @override
  Future<void> close() {
    notesController.dispose();
    return super.close();
  }
}
