import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/local_auth_service.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/data/repos/add_client_repo.dart';
import 'package:evex_user/data/repos/add_phone_repo.dart';
import 'package:evex_user/data/repos/booking_services_ports_repo.dart';
import 'package:evex_user/data/repos/forget_password_repo.dart';
import 'package:evex_user/data/repos/location_repo.dart';
import 'package:evex_user/data/repos/login_repo.dart';
import 'package:evex_user/data/repos/port_services_repo.dart';
import 'package:evex_user/data/repos/post_repo.dart';
import 'package:evex_user/data/repos/profile_repo.dart';
import 'package:evex_user/data/repos/register_repo.dart';
import 'package:evex_user/features/auth/add_client/ui/add_client_screen.dart';
import 'package:evex_user/features/auth/add_phone/view/screen/add_phone_otp_screen.dart';
import 'package:evex_user/features/auth/add_phone/view/screen/add_phone_screen.dart';
import 'package:evex_user/features/auth/login/ui/login_screen.dart';
import 'package:evex_user/features/auth/register/ui/register_screen.dart';
import 'package:evex_user/features/auth/reset_password/view/screen/forget_password_otp_screen.dart';
import 'package:evex_user/features/auth/reset_password/view/screen/forget_password_screen.dart';
import 'package:evex_user/features/auth/reset_password/view/screen/reset_password_screen.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/booking_service_details_screen.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/complete_booking_screen.dart';
import 'package:evex_user/features/booking_services/instant_booking_services/ui/instant_booking_services_screen.dart';
import 'package:evex_user/features/main/ui/main_screen.dart';
import 'package:evex_user/features/onboarding/ui/onboarding_screen.dart';
import 'package:evex_user/features/payment_history/ui/payment_history_screen.dart';
import 'package:evex_user/features/posts/ui/posts_screen.dart';
import 'package:evex_user/features/profile/view/screens/edit_profile_screen.dart';
import 'package:evex_user/features/profile/view/screens/profile_screen.dart';
import 'package:evex_user/features/splash/splash_screen.dart';
import 'package:evex_user/new_suggestion_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/cubits/auth/add_client/add_client_cubit.dart';
import '../../data/cubits/auth/add_phone/add_phone_cubit.dart';
import '../../data/cubits/auth/forget_password/forget_password_cubit.dart';
import '../../data/cubits/auth/login/login_cubit.dart';
import '../../data/cubits/auth/register/register_cubit.dart';
import '../../data/cubits/booking_services/booking_service_details/booking_service_details_cubit.dart';
import '../../data/cubits/booking_services/instant_booking/instant_booking_cubit.dart';
import '../../data/cubits/home/home_cubit.dart';
import '../../data/cubits/payment_history/payment_history_cubit.dart';
import '../../data/cubits/posts/post_cubit.dart';
import '../../data/cubits/profile/profile_cubit.dart';

class AppRouter {
  /// Decides where to land on startup based on the cached user.
  static String getInitialRoute(UserService userService) {
    final user = userService.currentUser;
    if (user == null) return Routes.loginScreen;
    if (user.userViewModel?.phoneNumber == null) return Routes.addPhoneScreen;
    if (user.modelId == null || user.modelId == 0) {
      return Routes.addClientScreen;
    }
    return Routes.mainScreen;
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return _page(const SplashScreen(), settings);

      case Routes.onboardingScreen:
        return _page(const OnboardingScreen(), settings);

      case Routes.loginScreen:
        return _page(
          BlocProvider(
            create: (context) => LoginCubit(
              context.read<LoginRepo>(),
              context.read<UserService>(),
              context.read<LocalAuthService>(),
            ),
            child: const LoginScreen(),
          ),
          settings,
        );

      case Routes.registerScreen:
        return _page(
          BlocProvider(
            create: (context) => RegisterCubit(context.read<RegisterRepo>()),
            child: const RegisterScreen(),
          ),
          settings,
        );

      case Routes.addPhoneScreen:
        return _page(
          BlocProvider(
            create: (context) => AddPhoneCubit(
              context.read<AddPhoneRepo>(),
              context.read<UserService>(),
            ),
            child: const AddPhoneScreen(),
          ),
          settings,
        );

      case Routes.addPhoneOptScreen:
        return _page(
          BlocProvider(
            create: (context) => AddPhoneCubit(
              context.read<AddPhoneRepo>(),
              context.read<UserService>(),
            ),
            child: const AddPhoneOtpScreen(),
          ),
          settings,
        );

      case Routes.addClientScreen:
        return _page(
          BlocProvider(
            create: (context) => AddClientCubit(
              context.read<AddClientRepo>(),
              context.read<LocationRepo>(),
              context.read<UserService>(),
            )..loadGovernorates(),
            child: const AddClientScreen(),
          ),
          settings,
        );

      case Routes.forgetPasswordScreen:
        return _page(
          BlocProvider(
            create: (context) =>
                ForgetPasswordCubit(context.read<ForgetPasswordRepo>()),
            child: const ForgetPasswordScreen(),
          ),
          settings,
        );

      case Routes.forgetPasswordOtpScreen:
        return _page(
          BlocProvider(
            create: (context) =>
                ForgetPasswordCubit(context.read<ForgetPasswordRepo>()),
            child: const ForgetPasswordOtpScreen(),
          ),
          settings,
        );

      case Routes.resetPasswordScreen:
        return _page(
          BlocProvider(
            create: (context) =>
                ForgetPasswordCubit(context.read<ForgetPasswordRepo>()),
            child: const ResetPasswordScreen(),
          ),
          settings,
        );

      case Routes.postsScreen:
        return _page(
          BlocProvider(
            create: (context) =>
                PostCubit(context.read<PostRepo>())..getPosts(),
            child: const PostsScreen(),
          ),
          settings,
        );

      case Routes.mainScreen:
        return _page(const MainScreen(), settings);

      case Routes.profileScreen:
        return _page(
          BlocProvider(
            create: (context) => ProfileCubit(
              context.read<ProfileRepo>(),
              context.read<LocationRepo>(),
            )..getProfile(),
            child: const ProfileScreen(),
          ),
          settings,
        );

      case Routes.editProfile:
        return _page(
          BlocProvider(
            create: (context) => ProfileCubit(
              context.read<ProfileRepo>(),
              context.read<LocationRepo>(),
            )..prepareEditProfile(),
            child: const EditProfileScreen(),
          ),
          settings,
        );

      case Routes.instantBookingServicesScreen:
        return _page(
          BlocProvider(
            create: (context) => InstantBookingCubit(
              context.read<BookingServicesPortsRepo>(),
              context.read<HomeCubit>(),
            )..loadPorts(),
            child: const InstantBookingServicesScreen(),
          ),
          settings,
        );

      case Routes.bookingServiceDetailsScreen:
        return _page(
          BlocProvider(
            create: (context) => BookingServiceDetailsCubit(
              context.read<PortServicesRepo>(),
              context.read<HomeCubit>(),
            ),
            child: const BookingServiceDetailsScreen(),
          ),
          settings,
        );

      case Routes.completeBookingScreen:
        return _page(const CompleteBookingScreen(), settings);

      case Routes.paymentHistoryScreen:
        return _page(
          BlocProvider(
            create: (_) => PaymentHistoryCubit()..loadTransactions(),
            child: const PaymentHistoryScreen(),
          ),
          settings,
        );

      case Routes.newSuggestionScreen:
        return _page(const NewSuggestionScreen(), settings);

      default:
        return _page(
          const Scaffold(body: Center(child: Text('Route not found'))),
          settings,
        );
    }
  }

  static PageRoute _page(Widget child, RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => child, settings: settings);
  }
}
