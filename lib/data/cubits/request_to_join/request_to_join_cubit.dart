import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';
import 'package:evex_user/data/repos/home_repo.dart';
import 'package:evex_user/data/repos/location_repo.dart';
import 'package:evex_user/data/repos/request_to_join_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'request_to_join_state.dart';

class RequestToJoinCubit extends Cubit<RequestToJoinState> {
  final RequestToJoinRepo _repo;
  final LocationRepo _locationRepo;
  final HomeRepo _homeRepo;

  RequestToJoinCubit(this._repo, this._locationRepo, this._homeRepo)
      : super(const RequestToJoinState());

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final countryController = TextEditingController(text: '+20');
  final emailController = TextEditingController();
  final pageLinkController = TextEditingController();
  final otherInfoController = TextEditingController();

  Future<void> loadGovernorates() async {
    emit(state.copyWith(isLoading: true));
    final govFuture = _locationRepo.getGovernorates();
    final homeFuture = _homeRepo.getHomeUserAppInfo();
    final govResult = await govFuture;
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
      serviceTypes: serviceTypes,
    ));
  }

  void selectServiceType(String? type) {
    emit(state.copyWith(selectedServiceType: type));
  }

  void selectGovernorate(Governate? gov) {
    emit(state.copyWith(
        selectedGovernorate: gov, clearCity: true, cities: const []));
    if (gov != null) _loadCities(gov.id);
  }

  void selectCity(City? city) {
    emit(state.copyWith(selectedCity: city));
  }

  Future<void> _loadCities(int govId) async {
    emit(state.copyWith(isLoading: true));
    final result = await _locationRepo.getCities(govId);
    emit(state.copyWith(isLoading: false, cities: result ?? const []));
  }

  Future<void> submit() async {
    if (nameController.text.trim().isEmpty) {
      ToastManager.showError('الرجاء ادخال الاسم');
      return;
    }
    if (state.selectedServiceType == null) {
      ToastManager.showError('الرجاء اختيار نوع الخدمة');
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
    if (phoneController.text.trim().isEmpty) {
      ToastManager.showError('الرجاء ادخال رقم الهاتف');
      return;
    }
    if (emailController.text.trim().isEmpty) {
      ToastManager.showError('الرجاء ادخال البريد الالكترونى');
      return;
    }

    emit(state.copyWith(isLoading: true));
    final ok = await _repo.submitJoinRequest(
      name: nameController.text.trim(),
      serviceType: state.selectedServiceType!,
      governorate: state.selectedGovernorate!.governorateNameAr,
      city: state.selectedCity!.cityNameAr,
      address: addressController.text.trim(),
      countryCode: countryController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      pageLink: pageLinkController.text.trim(),
      otherInfo: otherInfoController.text.trim(),
    );

    if (ok) {
      emit(state.copyWith(isLoading: false, success: true));
      ToastManager.showSuccess('تم إرسال طلبك بنجاح');
      NavigationHelper.pop();
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
      ToastManager.showError('تعذّر إرسال الطلب، حاول مرة أخرى');
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    countryController.dispose();
    emailController.dispose();
    pageLinkController.dispose();
    otherInfoController.dispose();
    return super.close();
  }
}
