import 'dart:io';

import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/repos/order_details_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

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

  /// Downloads the reservation PDF (DownloadInfo) and opens it in the device
  /// viewer.
  Future<void> downloadPdf() async {
    final id = _reservationId;
    if (id == null) return;
    ToastManager.showSuccess('جاري تحميل الملف...');
    final bytes = await _repo.downloadInfo(id);
    if (bytes == null) {
      ToastManager.showError('تعذّر تحميل الملف');
      return;
    }
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/reservation_$id.pdf');
      await file.writeAsBytes(bytes);
      await OpenFilex.open(file.path);
    } catch (_) {
      ToastManager.showError('تعذّر فتح الملف');
    }
  }

  /// Submits a review (stars + comment) for this reservation (POST /api/Reviews).
  /// Returns true on success so the UI can close the sheet.
  Future<bool> submitReview({required int stars, required String comment}) async {
    final order = state.order;
    final reservationId = order?.reservationId ?? _reservationId;
    final portId = order?.portId;
    if (reservationId == null || portId == null) {
      ToastManager.showError('تعذّر إضافة التقييم، بيانات الحجز غير مكتملة');
      return false;
    }
    if (stars <= 0) {
      ToastManager.showError('برجاء اختيار عدد النجوم');
      return false;
    }
    emit(state.copyWith(isSubmittingReview: true));
    final ok = await _repo.addReview(
      reservationId: reservationId,
      portId: portId,
      stars: stars,
      comment: comment.trim(),
    );
    emit(state.copyWith(isSubmittingReview: false));
    if (ok) {
      ToastManager.showSuccess('تم إضافة التقييم بنجاح');
    } else {
      ToastManager.showError('تعذّر إضافة التقييم، حاول مرة أخرى');
    }
    return ok;
  }

  /// Cancels the reservation (the UI shows a confirmation first).
  Future<void> cancelReservation() async {
    final id = _reservationId;
    if (id == null) return;
    emit(state.copyWith(isLoading: true));
    final ok = await _repo.cancelReservation(id);
    emit(state.copyWith(isLoading: false));
    if (ok) {
      ToastManager.showSuccess('تم إلغاء الحجز');
      NavigationHelper.pop();
    } else {
      ToastManager.showError('تعذّر إلغاء الحجز');
    }
  }

  @override
  Future<void> close() {
    notesController.dispose();
    return super.close();
  }
}
