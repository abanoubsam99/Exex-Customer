import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';
import 'package:evex_user/data/repos/location_repo.dart';
import 'package:evex_user/data/repos/new_suggestion_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'new_suggestion_state.dart';

class NewSuggestionCubit extends Cubit<NewSuggestionState> {
  final NewSuggestionRepo _repo;
  final LocationRepo _locationRepo;

  NewSuggestionCubit(this._repo, this._locationRepo)
      : super(const NewSuggestionState());

  static const List<String> serviceTypes = [
    'قاعات',
    'فوتوغرافى',
    'ميك اب',
    'اتيليه',
    'خدمات ترفيهيه',
    'ديكورات & هاند ميد',
    'العنايه بالجمال',
  ];

  static const List<String> occasionTypes = [
    'فرح',
    'خطوبة',
    'عيد ميلاد',
    'حفل تخرج',
    'مناسبة أخرى',
  ];

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final countryController = TextEditingController(text: '+20');
  final addressController = TextEditingController();
  final pageLinkController = TextEditingController();
  final occasionDateController = TextEditingController();

  Future<void> loadGovernorates() async {
    emit(state.copyWith(isLoading: true));
    final result = await _locationRepo.getGovernorates();
    emit(state.copyWith(isLoading: false, governorates: result ?? const []));
  }

  void selectServiceType(String? type) =>
      emit(state.copyWith(selectedServiceType: type));

  void selectOccasionType(String? type) =>
      emit(state.copyWith(selectedOccasionType: type));

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
    if (phoneController.text.trim().isEmpty) {
      ToastManager.showError('الرجاء ادخال رقم الهاتف');
      return;
    }

    emit(state.copyWith(isLoading: true));
    final ok = await _repo.submitSuggestion(
      vendorName: nameController.text.trim(),
      serviceType: serviceTypes.indexOf(state.selectedServiceType!) + 1,
      vendorGovernorate: state.selectedMerchantGov?.governorateNameAr ?? '',
      vendorCity: state.selectedMerchantCity?.cityNameAr ?? '',
      phoneNumber:
          '${countryController.text.trim()}${phoneController.text.trim()}',
      address: addressController.text.trim(),
      link: pageLinkController.text.trim(),
      occasionType: state.selectedOccasionType ?? '',
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
