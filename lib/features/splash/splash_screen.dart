import 'dart:async';

import 'package:evex_user/app/helpers/cache_helper.dart';
import 'package:evex_user/core/routing/app_router.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final cacheHelper = context.read<CacheHelper>();
    final userService = context.read<UserService>();
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      final isOnboardingCompleted =
          cacheHelper.getData('onboardingCompleted') as bool? ?? false;

      if (!isOnboardingCompleted) {
        NavigationHelper.pushNamedAndRemoveUntil(Routes.onboardingScreen);
      } else {
        NavigationHelper.pushNamedAndRemoveUntil(
          AppRouter.getInitialRoute(userService),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(1.5, -1),
            end: const Alignment(-1, 0.2),
            colors: [Color(0xffF9C5A4).withValues(alpha: 0), Colors.white],
          ),
        ),
        alignment: const Alignment(0, -0.3),
        child: Image.asset(AppImages.imagesEvexFinalLogo, width: 0.9.sw),
      ),
    );
  }
}
