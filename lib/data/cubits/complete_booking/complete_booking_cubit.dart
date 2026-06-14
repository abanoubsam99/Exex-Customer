import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/cubits/confirm_booking/confirm_booking_state.dart';
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/data/models/reservation_models.dart';
import 'package:evex_user/data/repos/confirm_booking_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'complete_booking_state.dart';

class CompleteBookingCubit extends Cubit<CompleteBookingState> {
  final ConfirmBookingRepo _repo;
  final HomeCubit _homeCubit;
  final CompleteBookingArgs args;

  CompleteBookingCubit(this._repo, this._homeCubit, {required this.args})
      : super(const CompleteBookingState()) {
    getPortPolicy();
  }

  final notesController = TextEditingController();

  /// Vendor policy for the port chosen on the previous screen.
  Future<void> getPortPolicy() async {
    final portId = args.port?.id;
    if (portId == null) return;
    emit(state.copyWith(isLoadingPolicy: true));
    final policy = await _repo.getPortPolicy(portId);
    emit(state.copyWith(isLoadingPolicy: false, policy: policy));
  }

  void toggleTerms(bool value) => emit(state.copyWith(termsAccepted: value));

  /// "إضافة لحجوزاتي" → creates the reservation request (AddClientReservation),
  /// then navigates to the confirm screen with the request id + deposit.
  Future<void> submit() async {
    if (!state.termsAccepted) {
      ToastManager.showError('برجاء الموافقة على الشروط والسياسات أولاً');
      return;
    }
    if (args.totalCost <= 0) {
      ToastManager.showError('السعر يجب أن يكون أكبر من صفر');
      return;
    }
    final port = args.port;
    // Prefer the date the user picked in the filter; fall back to the date the
    // port's availability was checked against.
    final occasionDate = _formatDate(
      _homeCubit.state.bookingDate ??
          args.occasionDate ??
          port?.checkReservationResponse?.date,
    );
    final governorate = port?.governorate;
    final city = port?.city;
    // Backend requires governorate, city and occasionDate.
    if (occasionDate == null ||
        (governorate ?? '').isEmpty ||
        (city ?? '').isEmpty) {
      ToastManager.showError(
        'بيانات المناسبة غير مكتملة (التاريخ/المحافظة/المدينة)',
      );
      return;
    }
    // If we already know the date is unavailable, don't attempt (avoids 409).
    final availability = _homeCubit.state.availability;
    if (availability != null && availability.allowedToReservation == false) {
      ToastManager.showError(
        availability.verificationResultMessage ??
            'الميعاد غير متاح للحجز الفوري',
      );
      return;
    }

    emit(state.copyWith(isSubmitting: true));
    final note = notesController.text.trim();
    final result = await _repo.addClientReservation(
      AddReservationRequest(
        portId: port?.id,
        serviceId: args.service?.id,
        governorate: governorate,
        city: city,
        occasionDate: occasionDate,
        userNotes: note.isEmpty ? null : note,
        additions: args.additions,
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

  /// Formats a [DateTime] as yyyy-MM-dd (the API's expected occasion date).
  static String? _formatDate(DateTime? date) {
    if (date == null || date.year <= 1) return null;
    String two(int n) => n.toString().padLeft(2, '0');
    return '${date.year}-${two(date.month)}-${two(date.day)}';
  }

  @override
  Future<void> close() {
    notesController.dispose();
    return super.close();
  }
}
