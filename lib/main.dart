import 'package:evex_user/core/constants/alice.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/di/dependency_injection.dart';
import 'core/localization/language_localization.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DependencyCreator.init();
  await Get.putAsync(() => UserService().init());

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      ensureScreenSize: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          translations: LanguageLocalization(),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            // MonthYearPickerLocalizations.delegate,
          ],
          locale: const Locale('ar'),
          title: 'Flutter Demo',
          navigatorKey: alice.getNavigatorKey(),
          theme: theme,
          getPages: AppRouter.appPages(),
          // initialRoute: Routes.postsScreen,
          // initialRoute: Routes.homeScreen,
          // initialRoute: Routes.instantBookingServicesScreen,
          // initialRoute: Routes.onboardingScreen,
          initialRoute: Routes.splashScreen,
          // initialRoute: Routes.mainScreen,
          // initialRoute: Routes.loginScreen,
          // initialRoute: Routes.addClientScreen,
          // initialRoute: Routes.forgetPasswordScreen,
          // initialRoute: Routes.registerScreen,
          // initialRoute: Routes.bookingServiceDetailsScreen,
          // initialRoute: Routes.completeBookingScreen,
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(0.974),
              ),
              child: widget!,
            );
          },
        );
      },
    );
  }
}
