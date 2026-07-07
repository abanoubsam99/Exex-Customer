import 'package:easy_localization/easy_localization.dart';
import 'package:evex_user/app/bloc_providers.dart';
import 'package:evex_user/app/helpers/cache_helper.dart';
import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/app_router.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/deep_link_service.dart';
import 'package:evex_user/core/services/local_auth_service.dart';
import 'package:evex_user/core/services/location_service.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/theme/app_theme.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';


/*
testab@gmail.com
123456
01227120517

menaatefdesigner2@gmail.com
1234

"email": testclient@gmail.com
"pass": test

menaatefdesigner5@gmail.com
1234

*/



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // ── Core services (constructed once, injected explicitly) ──
  final prefs = await SharedPreferences.getInstance();
  final cacheHelper = CacheHelper(prefs);
  DioHelper.init(cacheHelper);
  final userService = UserService(cacheHelper);
  await userService.init();
  final locationService = LocationService(cacheHelper, userService);
  final localAuthService = LocalAuthService();
  final deepLinkService = DeepLinkService(userService);
  // Start listening for the launch link + runtime links before the UI builds.
  await deepLinkService.init();

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
        locationService: locationService,
        localAuthService: localAuthService,
        deepLinkService: deepLinkService,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.cacheHelper,
    required this.userService,
    required this.locationService,
    required this.localAuthService,
    required this.deepLinkService,
  });

  final CacheHelper cacheHelper;
  final UserService userService;
  final LocationService locationService;
  final LocalAuthService localAuthService;
  final DeepLinkService deepLinkService;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: BlocProviders.repositories(
        cacheHelper: cacheHelper,
        userService: userService,
        locationService: locationService,
        localAuthService: localAuthService,
        deepLinkService: deepLinkService,
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
                  // Global text scale — bumped up so everything reads bigger
                  // and clearer across the app (was 0.974 = shrinking).
                  textScaler: const TextScaler.linear(1.1),
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
