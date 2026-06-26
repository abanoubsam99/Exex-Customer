import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/location_service.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';
import 'package:evex_user/data/repos/add_client_repo.dart';
import 'package:evex_user/data/repos/location_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_client_state.dart';

class AddClientCubit extends Cubit<AddClientState> {
  final AddClientRepo _addClientRepo;
  final LocationRepo _locationRepo;
  final UserService _userService;
  final LocationService _locationService;

  AddClientCubit(
    this._addClientRepo,
    this._locationRepo,
    this._userService,
    this._locationService,
  ) : super(const AddClientState());

  final nameController = TextEditingController();

  Future<void> loadGovernorates() async {
    emit(state.copyWith(isLoading: true));
    final result = await _locationRepo.getGovernorates();
    if (result == null) {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
      return;
    }
    emit(state.copyWith(isLoading: false, governorates: result));
    // Pre-fill with the location the user already picked during onboarding so
    // they don't have to choose the governorate/city again.
    await _preselectSavedLocation(result);
  }

  /// Selects the saved onboarding governorate + city (from [LocationService])
  /// by matching their ids against the freshly loaded lists. No-ops when no
  /// location was saved or the saved ids aren't found.
  Future<void> _preselectSavedLocation(List<Governate> governorates) async {
    final savedGovId = _locationService.govId;
    if (savedGovId == null) return;

    Governate? gov;
    for (final g in governorates) {
      if (g.id == savedGovId) {
        gov = g;
        break;
      }
    }
    if (gov == null) return;
    emit(state.copyWith(selectedGovernorate: gov));

    final cities = await _locationRepo.getCities(gov.id!);
    if (cities == null) return;
    emit(state.copyWith(cities: cities));

    final savedCityId = _locationService.cityId;
    if (savedCityId == null) return;
    for (final c in cities) {
      if (c.id == savedCityId) {
        emit(state.copyWith(selectedCity: c));
        break;
      }
    }
  }

  void selectGovernorate(Governate? gov) {
    emit(state.copyWith(selectedGovernorate: gov, clearCity: true, cities: []));
    if (gov != null) _loadCities(gov.id!);
  }

  void selectCity(City? city) {
    emit(state.copyWith(selectedCity: city));
  }

  Future<void> _loadCities(int govId) async {
    emit(state.copyWith(isLoading: true));
    final result = await _locationRepo.getCities(govId);
    if (result != null) {
      emit(state.copyWith(isLoading: false, cities: result));
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
    }
  }

  Future<void> addClient() async {
    if (nameController.text.trim().isEmpty) {
      ToastManager.showError('الرجاء ادخال اسم العميل');
      return;
    }
    if (state.selectedGovernorate == null) {
      ToastManager.showError('الرجاء اختيار المحافظة');
      return;
    }
    if (state.selectedCity == null) {
      ToastManager.showError('الرجاء اختيار المدينة');
      return;
    }

    emit(state.copyWith(isLoading: true));
    final response = await _addClientRepo.addClient(
      name: nameController.text.trim(),
      governorate: state.selectedGovernorate!.governorateNameAr ?? '',
      city: state.selectedCity!.cityNameAr ?? '',
    );
    if (response != null) {
      final user = _userService.currentUser;
      if (user != null) {
        user.modelId = response.modelId;
        // مهم: نخزّن clientId عشان نعرف إن الحساب اكتمل عند إعادة الفتح
        user.userViewModel?.clientId = response.modelId;
        user.userViewModel?.name = nameController.text.trim();
        await _userService.saveUser(user);
      }
      emit(state.copyWith(isLoading: false, success: true));
      ToastManager.showSuccess(response.message);
      NavigationHelper.pushNamedAndRemoveUntil(Routes.mainScreen);
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    return super.close();
  }
}
