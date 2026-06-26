import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';
import 'package:evex_user/data/models/occasion.dart';
import 'package:evex_user/data/repos/confirm_booking_repo.dart';
import 'package:evex_user/data/repos/home_repo.dart';
import 'package:evex_user/data/repos/location_repo.dart';
import 'package:evex_user/data/repos/new_suggestion_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'new_suggestion_state.dart';

class NewSuggestionCubit extends Cubit<NewSuggestionState> {
  final NewSuggestionRepo _repo;
  final LocationRepo _locationRepo;
  final ConfirmBookingRepo _confirmRepo;
  final HomeRepo _homeRepo;

  NewSuggestionCubit(
      this._repo, this._locationRepo, this._confirmRepo, this._homeRepo)
      : super(const NewSuggestionState());

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final countryController = TextEditingController(text: '+20');
  final addressController = TextEditingController();
  final pageLinkController = TextEditingController();
  final occasionDateController = TextEditingController();

  Future<void> loadGovernorates() async {
    emit(state.copyWith(isLoading: true));
    final govFuture = _locationRepo.getGovernorates();
    final occFuture = _confirmRepo.getOccasions();
    final homeFuture = _homeRepo.getHomeUserAppInfo();
    final govResult = await govFuture;
    final occResult = await occFuture;
    final homeResult = await homeFuture;
    final serviceTypes = homeResult != null
        ? homeResult
            .expand((cat) => cat.portTypeDtos)
            .map((t) => t.nameAr)
            .whereType<String>()
            .where((n) => n.trim().isNotEmpty)
            .toSet()
            .toList()
        : <String>[];
    emit(state.copyWith(
      isLoading: false,
      governorates: govResult ?? const [],
      occasions: occResult ?? const [],
      serviceTypes: serviceTypes,
    ));
  }

  void selectServiceType(String? type) =>
      emit(state.copyWith(selectedServiceType: type));

  void selectOccasion(Occasion? occasion) =>
      emit(state.copyWith(selectedOccasion: occasion));

  // ── موقع التاجر ──
  void selectMerchantGov(Governate? gov) {
    emit(state.copyWith(
        selectedMerchantGov: gov,
        clearMerchantCity: true,
        merchantCities: const []));
    if (gov != null) _loadMerchantCities(gov.id);
  }

  void selectMerchantCity(City? city) =>
      emit(state.copyWith(selectedMerchantCity: city));

  Future<void> _loadMerchantCities(int govId) async {
    final result = await _locationRepo.getCities(govId);
    emit(state.copyWith(merchantCities: result ?? const []));
  }

  // ── موقع المناسبة ──
  void selectEventGov(Governate? gov) {
    emit(state.copyWith(
        selectedEventGov: gov,
        clearEventCity: true,
        eventCities: const []));
    if (gov != null) _loadEventCities(gov.id);
  }

  void selectEventCity(City? city) =>
      emit(state.copyWith(selectedEventCity: city));

  Future<void> _loadEventCities(int govId) async {
    final result = await _locationRepo.getCities(govId);
    emit(state.copyWith(eventCities: result ?? const []));
  }

  Future<void> submit() async {
    if (nameController.text.trim().isEmpty) {
      ToastManager.showError('الرجاء ادخال اسم التاجر');
      return;
    }
    if (state.selectedServiceType == null) {
      ToastManager.showError('الرجاء اختيار نوع الخدمة');
      return;
    }
    if (state.selectedMerchantGov == null) {
      ToastManager.showError('الرجاء اختيار المحافظة');
      return;
    }
    if (state.selectedMerchantCity == null) {
      ToastManager.showError('الرجاء اختيار المدينة');
      return;
    }
    if (phoneController.text.trim().isEmpty) {
      ToastManager.showError('الرجاء ادخال رقم الهاتف');
      return;
    }

    emit(state.copyWith(isLoading: true));
    final ok = await _repo.submitSuggestion(
      vendorName: nameController.text.trim(),
      serviceType: state.serviceTypes.indexOf(state.selectedServiceType!) + 1,
      vendorGovernorate: state.selectedMerchantGov?.governorateNameAr ?? '',
      vendorCity: state.selectedMerchantCity?.cityNameAr ?? '',
      phoneNumber:
          '${countryController.text.trim()}${phoneController.text.trim()}',
      address: addressController.text.trim(),
      link: pageLinkController.text.trim(),
      occasionType: state.selectedOccasion?.name ?? '',
      occasionGovernorate: state.selectedEventGov?.governorateNameAr ?? '',
      occasionDate: occasionDateController.text.trim(),
    );

    if (ok) {
      emit(state.copyWith(isLoading: false, success: true));
      ToastManager.showSuccess('تم إرسال اقتراحك بنجاح');
      NavigationHelper.pop();
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
      ToastManager.showError('تعذّر إرسال الاقتراح، حاول مرة أخرى');
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    countryController.dispose();
    addressController.dispose();
    pageLinkController.dispose();
    occasionDateController.dispose();
    return super.close();
  }
}
