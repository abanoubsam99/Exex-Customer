import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
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

  AddClientCubit(this._addClientRepo, this._locationRepo, this._userService)
      : super(const AddClientState());

  final nameController = TextEditingController();

  Future<void> loadGovernorates() async {
    emit(state.copyWith(isLoading: true));
    final result = await _locationRepo.getGovernorates();
    if (result != null) {
      emit(state.copyWith(isLoading: false, governorates: result));
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
      ToastManager.showError('حدث خطأ في تحميل المحافظات');
    }
  }

  void selectGovernorate(Governate? gov) {
    emit(state.copyWith(selectedGovernorate: gov, clearCity: true, cities: []));
    if (gov != null) _loadCities(gov.id);
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
      ToastManager.showError('حدث خطأ في تحميل المدن');
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
      governorate: state.selectedGovernorate!.governorateNameAr,
      city: state.selectedCity!.cityNameAr,
    );
    if (response != null) {
      final user = _userService.currentUser;
      if (user != null) {
        user.modelId = response.modelId;
        await _userService.saveUser(user);
      }
      emit(state.copyWith(isLoading: false, success: true));
      ToastManager.showSuccess(response.message);
      NavigationHelper.pushNamedAndRemoveUntil(Routes.mainScreen);
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
      ToastManager.showError('حدث خطأ، يرجى المحاولة مرة أخرى');
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    return super.close();
  }
}
