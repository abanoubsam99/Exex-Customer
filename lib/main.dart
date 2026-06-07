import 'package:easy_localization/easy_localization.dart';
import 'package:evex_user/app/bloc_providers.dart';
import 'package:evex_user/app/helpers/cache_helper.dart';
import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/app_router.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/local_auth_service.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/theme/app_theme.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // ── Core services (constructed once, injected explicitly) ──
  final prefs = await SharedPreferences.getInstance();
  final cacheHelper = CacheHelper(prefs);
  DioHelper.init(cacheHelper);
  final userService = UserService(cacheHelper);
  await userService.init();
  final localAuthService = LocalAuthService();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: MyApp(
        cacheHelper: cacheHelper,
        userService: userService,
        localAuthService: localAuthService,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.cacheHelper,
    required this.userService,
    required this.localAuthService,
  });

  final CacheHelper cacheHelper;
  final UserService userService;
  final LocalAuthService localAuthService;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: BlocProviders.repositories(
        cacheHelper: cacheHelper,
        userService: userService,
        localAuthService: localAuthService,
      ),
      child: MultiBlocProvider(
        providers: BlocProviders.providers,
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          ensureScreenSize: true,
          builder: (_, __) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: NavigationHelper.navigatorKey,
              scaffoldMessengerKey: ToastManager.messengerKey,
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              title: 'Evex',
              theme: theme,
              initialRoute: Routes.splashScreen,
              onGenerateRoute: AppRouter.onGenerateRoute,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(0.974),
                ),
                child: child!,
              ),
            );
          },
        ),
      ),
    );
  }
}
