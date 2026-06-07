import 'dart:io';

import 'package:dio/dio.dart';
import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/location/data/repo/location_repo.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/features/profile/data/repos/profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _profileRepo;
  final LocationRepo _locationRepo;

  ProfileCubit(this._profileRepo, this._locationRepo)
      : super(const ProfileState());

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final editProfileFormKey = GlobalKey<FormState>();
  final changePasswordFormKey = GlobalKey<FormState>();

  File? selectedImage;

  Future<void> getProfile() async {
    emit(state.copyWith(isLoading: true));
    final result = await _profileRepo.getProfile();
    result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error.message));
        ToastManager.showError(error.message);
      },
      (profile) => emit(state.copyWith(isLoading: false, profile: profile)),
    );
  }

  Future<void> prepareEditProfile() async {
    emit(state.copyWith(isLoading: true));
    final result = await _locationRepo.getGovernorates();
    result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error.message));
        ToastManager.showError(error.message);
      },
      (govs) {
        emit(
          state.copyWith(
            isLoading: false,
            governorates: govs,
            selectedGovernorate: state.profile?.governorate,
            selectedCity: state.profile?.city,
          ),
        );
        _loadProfileToControllers();
        if (state.profile?.governorate != null) {
          loadCities(state.profile!.governorate!);
        }
      },
    );
  }

  Future<void> loadCities(String govName) async {
    final gov = state.governorates.where((g) => g.governorateNameAr == govName);
    if (gov.isEmpty) return;
    final result = await _locationRepo.getCities(gov.first.id);
    result.fold(
      (error) => ToastManager.showError(error.message),
      (cities) => emit(state.copyWith(cities: cities)),
    );
  }

  void selectGovernorate(String? gov) {
    emit(state.copyWith(selectedGovernorate: gov, selectedCity: null, cities: []));
    if (gov != null) loadCities(gov);
  }

  void selectCity(String? city) {
    emit(state.copyWith(selectedCity: city));
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage = File(picked.path);
      emit(state.copyWith());
    }
  }

  Future<void> updateClient() async {
    emit(state.copyWith(isLoading: true));
    final formData = FormData.fromMap({
      'Name': nameController.text.trim(),
      'Governorate': state.selectedGovernorate,
      'City': state.selectedCity,
      if (selectedImage != null)
        'image': await MultipartFile.fromFile(
          selectedImage!.path,
          filename: selectedImage!.uri.pathSegments.last,
        ),
    });
    final result = await _profileRepo.updateClient(formData: formData);
    result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error.message));
        ToastManager.showError(error.message);
      },
      (_) {
        emit(state.copyWith(isLoading: false, updateSuccess: true));
        ToastManager.showSuccess('تم التعديل بنجاح');
      },
    );
  }

  Future<void> deleteAccount(String email) async {
    emit(state.copyWith(isLoading: true));
    final result = await _profileRepo.deleteAccount(email);
    result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error.message));
        ToastManager.showError(error.message);
      },
      (message) {
        emit(state.copyWith(isLoading: false));
        ToastManager.showSuccess(message);
        NavigationHelper.pushNamedAndRemoveUntil(Routes.loginScreen);
      },
    );
  }

  void _loadProfileToControllers() {
    nameController.text = state.profile?.userName ?? '';
    emailController.text = state.profile?.email ?? '';
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
