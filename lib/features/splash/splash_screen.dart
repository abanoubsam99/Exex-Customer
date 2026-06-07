import 'dart:async';

import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/routing/app_router.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  void _startDelay() {
    Timer(const Duration(seconds: 3), () {
      SharedPreferences sharedPreferences = Get.find();
      bool isonboardingCompleted =
          sharedPreferences.getBool('onboardingCompleted') ?? false;

      if (!isonboardingCompleted) {
        Get.offAllNamed(Routes.onboardingScreen);
      } else {
        Get.offAllNamed(AppRouter.getInitialRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(1.5, -1),
            end: Alignment(-1, 0.2),
            colors: [Color(0xffF9C5A4).withValues(alpha: 0), Colors.white],
          ),
        ),
        alignment: Alignment(0, -0.3),
        child: Image.asset(AppImages.imagesEvexFinalLogo, width: 0.9.sw),
      ),
    );
  }
}
