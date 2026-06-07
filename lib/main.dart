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
import 'package:evex_user/features/auth/add_client/data/datasources/add_client_remote_datasource.dart';
import 'package:evex_user/features/auth/add_client/data/repo/add_client_repo.dart';
import 'package:evex_user/features/auth/add_phone/data/data_sources/add_phone_data_source.dart';
import 'package:evex_user/features/auth/add_phone/data/repo/add_phone_repo.dart';
import 'package:evex_user/features/auth/login/data/data_sources/login_remote_data_source.dart';
import 'package:evex_user/features/auth/login/data/repos/login_repo.dart';
import 'package:evex_user/features/auth/register/data/data_sources/register_remote_data_source.dart';
import 'package:evex_user/features/auth/register/data/repos/register_repo.dart';
import 'package:evex_user/features/auth/reset_password/data/data_sources/forget_password_data_source.dart';
import 'package:evex_user/features/auth/reset_password/data/repo/forget_password_repo.dart';
import 'package:evex_user/features/booking_services/booking_service_details/data/datasources/port_services_remote_data_source.dart';
import 'package:evex_user/features/booking_services/booking_service_details/data/repos/port_services_repo.dart';
import 'package:evex_user/features/booking_services/instant_booking_services/data/datasources/booking_servicies_ports_remote_data_source.dart';
import 'package:evex_user/features/booking_services/instant_booking_services/data/repos/booking_services_ports_repo.dart';
import 'package:evex_user/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:evex_user/features/home/data/repos/home_repo.dart';
import 'package:evex_user/features/posts/data/data_sources/post_remote_data_source.dart';
import 'package:evex_user/features/posts/data/repos/post_repo.dart';
import 'package:evex_user/features/profile/data/repos/profile_repo.dart';
import 'package:evex_user/features/profile/data_sources/profile_remote_data_source.dart';
import 'package:evex_user/core/location/data/datasource/location_remote_datasource.dart';
import 'package:evex_user/core/location/data/repo/location_repo.dart';
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
    final dio = DioHelper.dio;
    return MultiRepositoryProvider(
      providers: [
        // Services
        RepositoryProvider<CacheHelper>.value(value: cacheHelper),
        RepositoryProvider<UserService>.value(value: userService),
        RepositoryProvider<LocalAuthService>.value(value: localAuthService),
        // Repositories (each owns its Retrofit data source)
        RepositoryProvider<LoginRepo>(
          create: (_) => LoginRepo(LoginRemoteDataSource(dio), cacheHelper),
        ),
        RepositoryProvider<RegisterRepo>(
          create: (_) => RegisterRepo(RegisterRemoteDataSource(dio)),
        ),
        RepositoryProvider<AddPhoneRepo>(
          create: (_) =>
              AddPhoneRepo(AddPhoneRemoteDataSource(dio), userService),
        ),
        RepositoryProvider<AddClientRepo>(
          create: (_) => AddClientRepo(AddClientRemoteDataSource(dio)),
        ),
        RepositoryProvider<ForgetPasswordRepo>(
          create: (_) =>
              ForgetPasswordRepo(ForgetPasswordRemoteDataSource(dio)),
        ),
        RepositoryProvider<HomeRepo>(
          create: (_) => HomeRepo(HomeRemoteDataSource(dio)),
        ),
        RepositoryProvider<PostRepo>(
          create: (_) => PostRepo(PostRemoteDataSource(dio)),
        ),
        RepositoryProvider<ProfileRepo>(
          create: (_) => ProfileRepo(ProfileRemoteDataSource(dio)),
        ),
        RepositoryProvider<LocationRepo>(
          create: (_) => LocationRepo(LocationRemoteDataSource(dio)),
        ),
        RepositoryProvider<PortServicesRepo>(
          create: (_) => PortServicesRepo(PortServicesRemoteDataSource(dio)),
        ),
        RepositoryProvider<BookingServicesPortsRepo>(
          create: (_) => BookingServicesPortsRepo(
            BookingServiciesPortsRemoteDataSource(dio),
          ),
        ),
      ],
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
              // easy_localization drives locale, delegates & supported locales
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
