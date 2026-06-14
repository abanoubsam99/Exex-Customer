import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/repos/order_details_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final OrderDetailsRepo _repo;

  OrderDetailsCubit(this._repo) : super(const OrderDetailsState());

  final notesController = TextEditingController();
  int? _reservationId;
  String _loadedNote = '';

  Future<void> getOrderDetails({int? id}) async {
    _reservationId = id;
    emit(state.copyWith(isLoading: true));
    final result = await _repo.getOrderDetails(id: id);
    if (result != null) {
      emit(state.copyWith(isLoading: false, order: result));
      if (id != null) {
        final note = await _repo.getReservationUserNote(id);
        if (note != null) {
          _loadedNote = note;
          notesController.text = note;
        }
      }
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
    }
  }

  /// Saves the client note (EditReservationUserNote) — only when it changed.
  Future<void> saveUserNote() async {
    final id = _reservationId;
    if (id == null) return;
    final note = notesController.text.trim();
    if (note == _loadedNote.trim()) return;
    final ok = await _repo.editReservationUserNote(id, note);
    if (ok) {
      _loadedNote = note;
      ToastManager.showSuccess('تم حفظ الملاحظة');
    } else {
      ToastManager.showError('تعذّر حفظ الملاحظة');
    }
  }

  @override
  Future<void> close() {
    notesController.dispose();
    return super.close();
  }
}
