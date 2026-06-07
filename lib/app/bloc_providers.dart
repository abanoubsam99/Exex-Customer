import 'package:evex_user/app/helpers/cache_helper.dart';
import 'package:evex_user/core/services/local_auth_service.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/data/repos/add_client_repo.dart';
import 'package:evex_user/data/repos/add_phone_repo.dart';
import 'package:evex_user/data/repos/booking_services_ports_repo.dart';
import 'package:evex_user/data/repos/forget_password_repo.dart';
import 'package:evex_user/data/repos/home_repo.dart';
import 'package:evex_user/data/repos/location_repo.dart';
import 'package:evex_user/data/repos/login_repo.dart';
import 'package:evex_user/data/repos/port_services_repo.dart';
import 'package:evex_user/data/repos/post_repo.dart';
import 'package:evex_user/data/repos/profile_repo.dart';
import 'package:evex_user/data/repos/register_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/cubits/home/home_cubit.dart';
import '../data/cubits/main/main_cubit.dart';

/// Central place for all app-wide providers.
///
/// * [repositories] — services + repositories, exposed via `RepositoryProvider`.
/// * [providers]    — app-wide cubits, exposed via `BlocProvider`.
class BlocProviders {
  /// Services and repositories. The core services are constructed once in
  /// `main.dart` and injected here so repositories can depend on them.
  static List<RepositoryProvider> repositories({
    required CacheHelper cacheHelper,
    required UserService userService,
    required LocalAuthService localAuthService,
  }) =>
      [
        // Services
        RepositoryProvider<CacheHelper>.value(value: cacheHelper),
        RepositoryProvider<UserService>.value(value: userService),
        RepositoryProvider<LocalAuthService>.value(value: localAuthService),
        // Repositories — all use DioHelper directly, no data sources
        RepositoryProvider<LoginRepo>(create: (_) => LoginRepo(cacheHelper)),
        RepositoryProvider<RegisterRepo>(create: (_) => RegisterRepo()),
        RepositoryProvider<AddPhoneRepo>(
          create: (_) => AddPhoneRepo(userService),
        ),
        RepositoryProvider<AddClientRepo>(create: (_) => AddClientRepo()),
        RepositoryProvider<ForgetPasswordRepo>(
          create: (_) => ForgetPasswordRepo(),
        ),
        RepositoryProvider<HomeRepo>(create: (_) => HomeRepo()),
        RepositoryProvider<PostRepo>(create: (_) => PostRepo()),
        RepositoryProvider<ProfileRepo>(create: (_) => ProfileRepo()),
        RepositoryProvider<LocationRepo>(create: (_) => LocationRepo()),
        RepositoryProvider<PortServicesRepo>(
          create: (_) => PortServicesRepo(),
        ),
        RepositoryProvider<BookingServicesPortsRepo>(
          create: (_) => BookingServicesPortsRepo(),
        ),
      ];

  /// App-wide cubits, available to the whole widget tree.
  /// Dependencies are read from the [RepositoryProvider]s above.
  static List<BlocProvider> get providers => [
        BlocProvider<MainCubit>(create: (_) => MainCubit()),
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(context.read<HomeRepo>())..init(),
        ),
      ];
}
