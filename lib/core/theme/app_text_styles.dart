import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';
import 'font_weight_manager.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get font22BlackBoldHeader => TextStyle(
    fontSize: 22.r,
    fontWeight: FontWeightManager.bold,
    color: AppColors.black,
    fontFamily: 'Almarai',
  );

  static TextStyle get font18BlackExtraBoldHeader => TextStyle(
    fontSize: 18.r,
    fontWeight: FontWeightManager.extraBold,
    color: AppColors.black,
    fontFamily: 'Almarai',
  );

  static TextStyle get font14GreyRegularSubheader => TextStyle(
    fontSize: 14.r,
    fontWeight: FontWeightManager.regular,
    color: AppColors.grey,
    fontFamily: 'Almarai',
  );

  static TextStyle get font14BlacksoftRegular => TextStyle(
    color: AppColors.blacksoft,
    fontSize: 14.r,
    fontFamily: 'Almarai',
    fontWeight: FontWeightManager.regular,
    height: 1.50,
  );

  static TextStyle get font14BlackRegular => TextStyle(
    color: Colors.black,
    fontSize: 14.r,
    fontFamily: 'Almarai',
    fontWeight: FontWeight.w400,
    letterSpacing: -0.24,
  );

  static TextStyle get font14BlacksoftRegularHint => TextStyle(
    color: AppColors.blacksoftHint,
    fontSize: 14.r,
    fontFamily: 'Almarai',
    fontWeight: FontWeightManager.regular,
    height: 1.50,
  );

  static TextStyle get font14BrownBold => TextStyle(
    fontSize: 14.r,
    fontWeight: FontWeightManager.bold,
    color: AppColors.grey5,
    fontFamily: 'Almarai',
  );
  //Textfield header and style
  static TextStyle get font16BlackRegularHeader => TextStyle(
    fontSize: 16.r,
    fontWeight: FontWeightManager.regular,
    color: AppColors.black,
    fontFamily: 'Almarai',
  );

  static TextStyle get font16BlackBold => TextStyle(
    fontSize: 16.r,
    fontWeight: FontWeightManager.bold,
    color: AppColors.black,
    fontFamily: 'Almarai',
  );

  static TextStyle get font16GreyRegularHint => TextStyle(
    fontSize: 16.r,
    fontWeight: FontWeightManager.regular,
    color: AppColors.grey,
    fontFamily: 'Almarai',
  );

  static TextStyle get font16GreyBold => TextStyle(
    fontSize: 16.r,
    fontWeight: FontWeightManager.bold,
    color: AppColors.grey,
    fontFamily: 'Almarai',
  );

  static TextStyle get font16WhiteBoldButton => TextStyle(
    fontSize: 16.r,
    fontWeight: FontWeightManager.bold,
    color: AppColors.whiteColor,
    fontFamily: 'Almarai',
  );

  static TextStyle get font12greyRegular => TextStyle(
    color: AppColors.grey,
    fontSize: 12.r,
    fontFamily: 'Almarai',
    fontWeight: FontWeight.w400,
  );
  static TextStyle get font13greyRegular => TextStyle(
    color: AppColors.grey,
    fontSize: 13.r,
    fontFamily: 'Almarai',
    fontWeight: FontWeight.w400,
  );
}
