import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import 'app_colors.dart';

final ThemeData theme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.whiteColor,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),

  /// text themeing
  fontFamily: 'Almarai',
  textTheme: const TextTheme(
    bodyLarge: TextStyle(letterSpacing: -0.24),
    bodyMedium: TextStyle(letterSpacing: -0.24),
    bodySmall: TextStyle(letterSpacing: -0.24),
    titleLarge: TextStyle(letterSpacing: -0.24),
    titleMedium: TextStyle(letterSpacing: -0.24),
    titleSmall: TextStyle(letterSpacing: -0.24),
    displayLarge: TextStyle(letterSpacing: -0.24),
    displayMedium: TextStyle(letterSpacing: -0.24),
    displaySmall: TextStyle(letterSpacing: -0.24),
    labelLarge: TextStyle(letterSpacing: -0.24),
    labelMedium: TextStyle(letterSpacing: -0.24),
    labelSmall: TextStyle(letterSpacing: -0.24),
    headlineLarge: TextStyle(letterSpacing: -0.24),
    headlineMedium: TextStyle(letterSpacing: -0.24),
    headlineSmall: TextStyle(letterSpacing: -0.24),
  ),

  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColors.primaryColor,
  ),

  /// appBar themeing
  appBarTheme: AppBarTheme(
    surfaceTintColor: Colors.transparent,
    toolbarHeight: 50.h,
  ),

  /// bottomNavigationBar themeing
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
  ),

  /// dialog themeing
  dialogTheme: const DialogThemeData(backgroundColor: AppColors.whiteColor),

  /// datePicker themeing
  datePickerTheme: const DatePickerThemeData(backgroundColor: Colors.white),
);
