import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/helpers/occasion_validation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
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
      : super(CompleteBookingState(
          selectedOccasionId: args.occasionId,
          // Editing an existing reservation → the policy was already accepted
          // when it was first booked, so the checkbox starts ticked.
          termsAccepted: args.isEditMode,
        )) {
    // In edit mode, pre-fill the notes field with the reservation's own note.
    if (args.editBill != null) {
      notesController.text = args.editBill!.userNotes;
    }
    getPortPolicy();
    getOccasions();
    getNetCost();
  }

  final notesController = TextEditingController();

  /// Vendor policy for the port chosen on the previous screen.
  Future<void> getPortPolicy() async {
    final portId = args.port?.id ?? args.portId;
    if (portId == null) return;
    emit(state.copyWith(isLoadingPolicy: true));
    final policy = await _repo.getPortPolicy(portId);
    emit(state.copyWith(isLoadingPolicy: false, policy: policy));
  }

  /// نوع المناسبة options for the edit sheet (same list as service-details).
  Future<void> getOccasions() async {
    final occasions = await _repo.getOccasions();
    if (occasions != null) emit(state.copyWith(occasions: occasions));
  }

  /// Cost breakdown for the "تفاصيل تكلفة الخدمة" section (عمولة evex، رسوم
  /// إدارية، ضريبة، مقدم الحجز، الإجمالي) — computed by CalculateNetCost from the
  /// port + the chosen service/additions/buffet prices, so nothing there is
  /// hardcoded. The endpoint keys the fee/tax config off the *port* id.
  Future<void> getNetCost() async {
    final portId = args.port?.id ?? args.portId;
    if (portId == null) return;
    // The endpoint expects the service's raw price (before any discount) — it
    // applies its own fee/tax/discount rules on top. Which raw price depends on
    // the booking date: `priceInPeriod1`/`priceInPeriod2` when it falls inside a
    // special-price period, otherwise the plain `price`. The discounted figure
    // stays in [totalCost].
    final bookingDate = _homeCubit.state.bookingDate ??
        args.occasionDate ??
        args.port?.checkReservationResponse?.date;
    final netCost = await _repo.calculateNetCost(
      id: portId,
      servicePrice: args.service?.rawPriceFor(bookingDate),
      totalCost: args.totalCost,
      additionalCost: args.additionalCost,
      buffetCost: args.buffetCost,
    );
    if (netCost != null) emit(state.copyWith(netCost: netCost));
  }

  /// Updates the chosen occasion type when changed from the edit sheet.
  void selectOccasion(int id) => emit(state.copyWith(selectedOccasionId: id));

  void toggleTerms(bool value) => emit(state.copyWith(termsAccepted: value));

  /// "إضافة لحجوزاتي" → creates the reservation request (AddClientReservation),
  /// then navigates to the confirm screen with the request id + deposit.
  /// In edit mode ("تعديل الحجز") it updates the existing reservation instead.
  Future<void> submit() async {
    if (args.isEditMode) {
      await _submitEdit();
      return;
    }
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
    final pickedDate = _homeCubit.state.bookingDate ??
        args.occasionDate ??
        port?.checkReservationResponse?.date;
    // The toast names only what's actually still missing (type, date, or both).
    final missing = OccasionValidationHelper.missingOccasionMessage(
      date: pickedDate,
      occasionId: state.selectedOccasionId,
    );
    if (missing != null) {
      ToastManager.showError(missing);
      return;
    }
    final occasionDate = _formatDate(pickedDate);
    // Prefer the event location the user picked (edit sheet); fall back to the
    // port's own location.
    final governorate = _homeCubit.state.eventGovernorate ?? port?.governorate;
    final city = _homeCubit.state.eventCity ?? port?.city;
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
        // No full [Item] when opened from a special offer / deep link — fall
        // back to the id carried in the args.
        portId: port?.id ?? args.portId,
        serviceId: args.service?.id,
        occasionId: state.selectedOccasionId,
        governorate: governorate,
        city: city,
        occasionDate: occasionDate,
        userNotes: note.isEmpty ? null : note,
        totalCost: args.totalCost,
        additions: args.additions,
      ),
    );
    emit(state.copyWith(isSubmitting: false));
    if (result != null && (result.reservationRequestId ?? 0) > 0) {
      ToastManager.showSuccess('تمت الإضافة الى قائمة الطلبات الحالية');
      // Go to "حجوزاتي" (tab 1) — not the confirm screen. The fresh MainScreen
      // rebuilds MyBookings, so it loads the latest requests (auto-refresh).
      NavigationHelper.pushNamedAndRemoveUntil(
        Routes.mainScreen,
        arguments: 1,
      );
    } else {
      emit(state.copyWith(errorMessage: 'تعذّر إضافة الحجز، حاول مرة أخرى'));
    }
  }

  /// "تعديل الحجز" → applies the final occasion/date/notes onto the echoed bill
  /// (service + additions were already applied on the previous screen) and
  /// updates the reservation in place, then returns to "حجوزاتي".
  Future<void> _submitEdit() async {
    final bill = args.editBill;
    final editArgs = args.editArgs;
    if (bill == null || editArgs == null) {
      ToastManager.showError('تعذّر تحميل بيانات الحجز، حاول مرة أخرى');
      return;
    }
    if (!state.termsAccepted) {
      ToastManager.showError('برجاء الموافقة على الشروط والسياسات أولاً');
      return;
    }
    if ((state.selectedOccasionId ?? 0) <= 0) {
      ToastManager.showError('حدد نوع وتاريخ المناسبة لاستكمال الحجز');
      return;
    }

    final date = _homeCubit.state.bookingDate ?? args.occasionDate;
    if (date != null) {
      // The bill keeps its M/d/yyyy format.
      bill.occasionDate = '${date.month}/${date.day}/${date.year}';
    }
    // Carry through any event-location change made from the edit sheet.
    final gov = _homeCubit.state.eventGovernorate;
    final city = _homeCubit.state.eventCity;
    if ((gov ?? '').isNotEmpty) bill.governorate = gov;
    if ((city ?? '').isNotEmpty) bill.city = city;
    bill.occasionId = state.selectedOccasionId!;
    bill.userNotes = notesController.text.trim();

    emit(state.copyWith(isSubmitting: true));
    final ok = editArgs.isConfirmed
        ? await _repo.updateReservationByClient(editArgs.reservationId, bill)
        : await _repo.updateReservationRequest(editArgs.reservationId, bill);
    emit(state.copyWith(isSubmitting: false));
    if (ok) {
      ToastManager.showSuccess('تم تعديل الحجز بنجاح');
      // Back to "حجوزاتي" (tab 1) so the updated reservation is reloaded.
      NavigationHelper.pushNamedAndRemoveUntil(
        Routes.mainScreen,
        arguments: 1,
      );
    } else {
      ToastManager.showError('تعذّر تعديل الحجز، حاول مرة أخرى');
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
