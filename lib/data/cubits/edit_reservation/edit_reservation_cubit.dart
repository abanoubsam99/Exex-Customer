import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/repos/confirm_booking_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'edit_reservation_state.dart';

class EditReservationCubit extends Cubit<EditReservationState> {
  final ConfirmBookingRepo _repo;
  final EditReservationArgs args;

  EditReservationCubit(this._repo, {required this.args})
      : super(const EditReservationState()) {
    _load();
  }

  final notesController = TextEditingController();

  /// Loads the current reservation (the bill) so we can echo the full body
  /// back on save. serviceId/occasionId come from the list item (not the bill).
  Future<void> _load() async {
    emit(state.copyWith(isLoading: true));
    final model = await _repo.getReservationBill(
      args.reservationId,
      serviceId: args.serviceId,
      occasionId: args.occasionId,
    );
    if (model != null) {
      notesController.text = model.userNotes;
      emit(state.copyWith(
        isLoading: false,
        model: model,
        occasionDate: _parse(model.occasionDate) ?? args.occasionDate,
      ));
    } else {
      // Couldn't load the bill — fall back to whatever the list item passed.
      notesController.text = args.userNotes ?? '';
      emit(state.copyWith(isLoading: false, occasionDate: args.occasionDate));
    }
  }

  void setDate(DateTime date) => emit(state.copyWith(occasionDate: date));

  Future<void> save() async {
    final model = state.model;
    if (model == null) {
      ToastManager.showError('تعذّر تحميل بيانات الحجز، حاول مرة أخرى');
      return;
    }
    final date = state.occasionDate;
    if (date == null) {
      ToastManager.showError('برجاء تحديد تاريخ المناسبة');
      return;
    }
    // Apply the client's edits onto the echoed reservation body.
    model.occasionDate = _formatDate(date);
    model.userNotes = notesController.text.trim();

    emit(state.copyWith(isSaving: true));
    final ok = args.isConfirmed
        ? await _repo.updateReservationByClient(args.reservationId, model)
        : await _repo.updateReservationRequest(args.reservationId, model);
    emit(state.copyWith(isSaving: false));
    if (ok) {
      ToastManager.showSuccess('تم تعديل الحجز بنجاح');
      NavigationHelper.pop();
    } else {
      ToastManager.showError('تعذّر تعديل الحجز، حاول مرة أخرى');
    }
  }

  /// Formats as M/d/yyyy to match the bill's occasionDate format.
  static String _formatDate(DateTime d) => '${d.month}/${d.day}/${d.year}';

  /// Parses the bill's M/d/yyyy occasion date (falls back to ISO parsing).
  static DateTime? _parse(String? s) {
    if (s == null || s.trim().isEmpty) return null;
    final parts = s.split('/');
    if (parts.length == 3) {
      final m = int.tryParse(parts[0]);
      final d = int.tryParse(parts[1]);
      final y = int.tryParse(parts[2]);
      if (m != null && d != null && y != null) return DateTime(y, m, d);
    }
    return DateTime.tryParse(s);
  }

  @override
  Future<void> close() {
    notesController.dispose();
    return super.close();
  }
}
