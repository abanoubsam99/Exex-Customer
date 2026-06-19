import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/models/addition_model.dart';
import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';
import 'package:evex_user/data/models/occasion.dart';
import 'package:evex_user/data/models/reservation_update_model.dart';
import 'package:evex_user/data/repos/confirm_booking_repo.dart';
import 'package:evex_user/data/repos/location_repo.dart';
import 'package:evex_user/data/repos/port_services_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'edit_reservation_state.dart';

class EditReservationCubit extends Cubit<EditReservationState> {
  final ConfirmBookingRepo _repo;
  final LocationRepo _locationRepo;
  final PortServicesRepo _portServicesRepo;
  final EditReservationArgs args;

  EditReservationCubit(
    this._repo,
    this._locationRepo,
    this._portServicesRepo, {
    required this.args,
  }) : super(const EditReservationState()) {
    _load();
  }

  final notesController = TextEditingController();

  /// Reservation-addition row ids keyed by additionId, so existing additions
  /// keep their id when we rebuild the body on save (new ones use 0).
  final Map<int, int> _existingRowIds = {};

  /// Loads the current reservation (the bill) so we can echo the full body
  /// back on save, then loads the editable lists (governorates/occasions/additions).
  Future<void> _load() async {
    emit(state.copyWith(isLoading: true));
    final model = await _repo.getReservationBill(
      args.reservationId,
      serviceId: args.serviceId,
      occasionId: args.occasionId,
    );
    if (model == null) {
      // Couldn't load the bill — fall back to whatever the list item passed.
      notesController.text = args.userNotes ?? '';
      emit(state.copyWith(isLoading: false, occasionDate: args.occasionDate));
      return;
    }

    notesController.text = model.userNotes;
    final counts = _seedAdditionCounts(model);
    final date = _parse(model.occasionDate) ?? args.occasionDate;
    emit(state.copyWith(
      isLoading: false,
      model: model,
      occasionDate: date,
      selectedOccasionId: model.occasionId > 0 ? model.occasionId : null,
      additionCounts: counts,
    ));
    if (date != null) _checkAvailability(date);
    _loadLists(model);
  }

  /// Checks whether the port is available on [date]
  /// (CheckReservationAvailabilityByClient) so the screen can show متاح / غير متاح.
  Future<void> _checkAvailability(DateTime date) async {
    final portId = state.model?.portId ?? args.portId ?? 0;
    if (portId == 0) return;
    emit(state.copyWith(isCheckingAvailability: true));
    final result = await _repo.checkAvailability(portId: portId, date: date);
    emit(state.copyWith(isCheckingAvailability: false, availability: result));
  }

  /// Seeds the chosen-addition counts (and remembers their row ids) from the bill.
  Map<int, int> _seedAdditionCounts(ReservationUpdateModel model) {
    final counts = <int, int>{};
    for (final a in model.additions) {
      final additionId = (a['additionId'] as num?)?.toInt() ?? 0;
      final number = (a['number'] as num?)?.toInt() ?? 0;
      final rowId = (a['id'] as num?)?.toInt() ?? 0;
      if (additionId > 0 && number > 0) {
        counts[additionId] = number;
        if (rowId > 0) _existingRowIds[additionId] = rowId;
      }
    }
    return counts;
  }

  /// Loads governorates, occasions and the port's additions, then prefills the
  /// governorate/city to match the names already on the reservation.
  Future<void> _loadLists(ReservationUpdateModel model) async {
    // Fire concurrently, then await each (keeps the result types clean).
    final govsF = _locationRepo.getGovernorates();
    final occasionsF = _repo.getOccasions();
    final additionsF = _portServicesRepo.getAdditions(model.portId);
    final List<Governate> govs = await govsF ?? const [];
    final List<Occasion> occasions = await occasionsF ?? const [];
    final List<AdditionModel> additions = await additionsF ?? const [];

    Governate? selectedGov;
    for (final g in govs) {
      if (g.governorateNameAr == model.governorate ||
          g.governorateNameEn == model.governorate) {
        selectedGov = g;
        break;
      }
    }

    emit(state.copyWith(
      governorates: govs,
      occasions: occasions,
      additions: additions,
      selectedGovernorate: selectedGov,
    ));

    if (selectedGov != null) {
      await _loadCities(selectedGov.id, prefillCityName: model.city);
    }
  }

  Future<void> _loadCities(int govId, {String? prefillCityName}) async {
    emit(state.copyWith(isLoadingCities: true));
    final cities = await _locationRepo.getCities(govId) ?? const [];
    City? selectedCity;
    if (prefillCityName != null) {
      for (final c in cities) {
        if (c.cityNameAr == prefillCityName || c.cityNameEn == prefillCityName) {
          selectedCity = c;
          break;
        }
      }
    }
    emit(state.copyWith(
      cities: cities,
      isLoadingCities: false,
      selectedCity: selectedCity,
    ));
  }

  void selectGovernorate(Governate? gov) {
    if (gov == null) return;
    emit(state.copyWith(
      selectedGovernorate: gov,
      selectedCity: null,
      cities: const [],
    ));
    _loadCities(gov.id);
  }

  void selectCity(City? city) => emit(state.copyWith(selectedCity: city));

  void selectOccasion(int id) => emit(state.copyWith(selectedOccasionId: id));

  void setAdditionCount(int additionId, int count) {
    final next = Map<int, int>.from(state.additionCounts);
    if (count <= 0) {
      next.remove(additionId);
    } else {
      next[additionId] = count;
    }
    emit(state.copyWith(additionCounts: next));
  }

  void setDate(DateTime date) {
    emit(state.copyWith(occasionDate: date));
    _checkAvailability(date);
  }

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
    if (state.selectedGovernorate != null) {
      model.governorate = state.selectedGovernorate!.governorateNameAr;
    }
    if (state.selectedCity != null) {
      model.city = state.selectedCity!.cityNameAr;
    }
    if ((state.selectedOccasionId ?? 0) > 0) {
      model.occasionId = state.selectedOccasionId!;
    }
    // Rebuild the desired additions; oldAdditions stays as loaded (diff source).
    model.additions = state.additionCounts.entries
        .where((e) => e.value > 0)
        .map((e) => {
              'id': _existingRowIds[e.key] ?? 0,
              'number': e.value,
              'additionId': e.key,
            })
        .toList();

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
