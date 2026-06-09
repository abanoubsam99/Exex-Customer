import 'dart:io';

import 'package:dio/dio.dart';
import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/repos/location_repo.dart';
import 'package:evex_user/data/repos/profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _profileRepo;
  final LocationRepo _locationRepo;
  final UserService _userService;

  ProfileCubit(this._profileRepo, this._locationRepo, this._userService)
      : super(const ProfileState());

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final editProfileFormKey = GlobalKey<FormState>();
  final changePasswordFormKey = GlobalKey<FormState>();

  /// أنواع النوع (Gender) المعروضة في الـ dropdown.
  static const List<String> genderOptions = ['ذكر', 'أنثى'];

  void selectGender(String? gender) =>
      emit(state.copyWith(selectedGender: gender));

  File? selectedImage;

  Future<void> getProfile() async {
    emit(state.copyWith(isLoading: true));
    final profile = await _profileRepo.getProfile();
    if (profile != null) {
      emit(state.copyWith(isLoading: false, profile: profile));
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
    }
  }

  Future<void> prepareEditProfile() async {
    // Seed instantly from the cached user so fields aren't empty while the
    // API request is still in flight. Gov/city are only selected after the
    // governorates list loads (to keep the dropdown values valid).
    final cached = _userService.currentUser?.userViewModel;
    if (state.profile == null && cached != null) {
      emit(state.copyWith(
        profile: cached,
        selectedGender: _normalizeGender(cached.gender),
      ));
      _loadProfileToControllers();
    }

    emit(state.copyWith(isLoading: true));
    final profile = await _profileRepo.getProfile() ?? state.profile;
    final govs = await _locationRepo.getGovernorates();
    if (profile != null && govs != null) {
      emit(state.copyWith(
        isLoading: false,
        profile: profile,
        governorates: govs,
        selectedGovernorate: profile.governorate,
        selectedCity: profile.city,
        selectedGender: _normalizeGender(profile.gender),
      ));
      _loadProfileToControllers();
      if (profile.governorate != null) {
        loadCities(profile.governorate!);
      }
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
    }
  }

  Future<void> loadCities(String govName) async {
    final gov = state.governorates.where((g) => g.governorateNameAr == govName);
    if (gov.isEmpty) return;
    final cities = await _locationRepo.getCities(gov.first.id);
    if (cities != null) {
      emit(state.copyWith(cities: cities));
    }
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
    MultipartFile? image;
    if (selectedImage != null) {
      image = await MultipartFile.fromFile(
        selectedImage!.path,
        filename: selectedImage!.uri.pathSegments.last,
      );
    }
    final result = await _profileRepo.updateClient(
      id: state.profile?.clientId,
      name: nameController.text.trim(),
      governorate: state.selectedGovernorate,
      city: state.selectedCity,
      address: addressController.text.trim(),
      gender: state.selectedGender,
      dateOfBirth: _dateToIso(dateOfBirthController.text.trim()),
      image: image,
    );
    if (result != null) {
      emit(state.copyWith(isLoading: false, updateSuccess: true));
      ToastManager.showSuccess('تم التعديل بنجاح');
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
    }
  }

  Future<void> changePassword() async {
    emit(state.copyWith(isLoading: true));
    final ok = await _profileRepo.changePassword(
      currentPassword: currentPasswordController.text.trim(),
      newPassword: newPasswordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );
    if (ok) {
      emit(state.copyWith(isLoading: false));
      ToastManager.showSuccess('تم تغيير كلمة المرور بنجاح');
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      NavigationHelper.pop();
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
      ToastManager.showError('تعذّر تغيير كلمة المرور، حاول مرة أخرى');
    }
  }

  Future<void> deleteAccount(String email) async {
    emit(state.copyWith(isLoading: true));
    final message = await _profileRepo.deleteAccount(email);
    if (message != null) {
      emit(state.copyWith(isLoading: false));
      ToastManager.showSuccess(message);
      NavigationHelper.pushNamedAndRemoveUntil(Routes.loginScreen);
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
    }
  }

  void _loadProfileToControllers() {
    nameController.text = state.profile?.userName ?? '';
    emailController.text = state.profile?.email ?? '';
    addressController.text = state.profile?.address ?? '';
    dateOfBirthController.text = _isoToDate(state.profile?.dateOfBirth);
  }

  /// بيوحّد قيمة النوع الجاية من الـ API مع خيارات الـ dropdown (ذكر/أنثى).
  String? _normalizeGender(String? g) {
    if (g == null || g.trim().isEmpty) return null;
    final raw = g.trim();
    final v = raw.toLowerCase();
    if (v == 'male' || v == 'm' || raw == 'ذكر') return 'ذكر';
    if (v == 'female' || v == 'f' || raw == 'أنثى' || raw == 'انثى') {
      return 'أنثى';
    }
    return genderOptions.contains(raw) ? raw : null;
  }

  /// بيحوّل تاريخ الميلاد (ISO من الـ API) لصيغة yyyy-MM-dd لعرضه في الحقل.
  String _isoToDate(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final d = DateTime.parse(iso);
      final m = d.month.toString().padLeft(2, '0');
      final day = d.day.toString().padLeft(2, '0');
      return '${d.year}-$m-$day';
    } catch (_) {
      return '';
    }
  }

  /// بيحوّل تاريخ الميلاد (yyyy-MM-dd من الـ date picker) لـ ISO 8601.
  /// بيرجّع null لو الحقل فاضي عشان مايتبعتش للـ API.
  String? _dateToIso(String date) {
    if (date.isEmpty) return null;
    try {
      return DateTime.parse(date).toUtc().toIso8601String();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    dateOfBirthController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
