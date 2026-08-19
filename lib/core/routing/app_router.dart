import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/apple_auth_service.dart';
import 'package:evex_user/core/services/google_auth_service.dart';
import 'package:evex_user/core/services/local_auth_service.dart';
import 'package:evex_user/core/services/location_service.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/data/cubits/onboarding/onboarding_location_cubit.dart';
import 'package:evex_user/data/cubits/ports_filter/ports_filter_cubit.dart';
import 'package:evex_user/data/repos/add_client_repo.dart';
import 'package:evex_user/data/repos/add_phone_repo.dart';
import 'package:evex_user/data/repos/booking_services_ports_repo.dart';
import 'package:evex_user/data/repos/forget_password_repo.dart';
import 'package:evex_user/data/repos/location_repo.dart';
import 'package:evex_user/data/cubits/contact_us/contact_us_cubit.dart';
import 'package:evex_user/data/models/payment_gateway_result.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:evex_user/data/models/special_offer.dart';
import 'package:evex_user/data/repos/confirm_booking_repo.dart';
import 'package:evex_user/data/repos/my_bookings_repo.dart';
import 'package:evex_user/data/repos/contact_us_repo.dart';
import 'package:evex_user/data/repos/favorites_repo.dart';
import 'package:evex_user/data/repos/home_repo.dart';
import 'package:evex_user/data/repos/login_repo.dart';
import 'package:evex_user/data/repos/new_suggestion_repo.dart';
import 'package:evex_user/data/repos/notifications_repo.dart';
import 'package:evex_user/data/repos/order_details_repo.dart';
import 'package:evex_user/data/repos/payment_history_repo.dart';
import 'package:evex_user/data/repos/port_services_repo.dart';
import 'package:evex_user/data/repos/wallet_repo.dart';
import 'package:evex_user/data/repos/post_repo.dart';
import 'package:evex_user/data/repos/profile_repo.dart';
import 'package:evex_user/data/repos/register_repo.dart';
import 'package:evex_user/data/repos/request_to_join_repo.dart';
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
import 'package:evex_user/features/contact_us/ui/contact_us_screen.dart';
import 'package:evex_user/features/confirm_booking/ui/confirm_booking_screen.dart';
// صفحة "تعديل الحجز" المنفصلة معطّلة — التعديل بقى عبر صفحة تفاصيل البوابة.
// import 'package:evex_user/features/edit_reservation/ui/edit_reservation_screen.dart';
import 'package:evex_user/features/favorites/ui/favorites_screen.dart';
import 'package:evex_user/features/direct_services/ui/contact_info_screen.dart';
import 'package:evex_user/features/direct_services/ui/direct_service_details_screen.dart';
import 'package:evex_user/features/direct_services/ui/direct_services_list_screen.dart';
import 'package:evex_user/features/main/ui/main_screen.dart';
import 'package:evex_user/features/notifications/ui/notification_screen.dart';
import 'package:evex_user/features/order_details/ui/order_details_screen.dart';
import 'package:evex_user/features/onboarding/ui/onboarding_screen.dart';
import 'package:evex_user/features/payment_history/ui/payment_history_screen.dart';
import 'package:evex_user/features/payment_webview/ui/payment_webview_screen.dart';
import 'package:evex_user/features/posts/ui/posts_screen.dart';
import 'package:evex_user/features/profile/view/screens/change_password_screen.dart';
import 'package:evex_user/features/profile/view/screens/edit_profile_screen.dart';
import 'package:evex_user/features/profile/view/screens/profile_screen.dart';
import 'package:evex_user/features/request_to_join/ui/request_to_join_screen.dart';
import 'package:evex_user/features/splash/splash_screen.dart';
import 'package:evex_user/features/new_suggestion_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/cubits/auth/add_client/add_client_cubit.dart';
import '../../data/cubits/auth/add_phone/add_phone_cubit.dart';
import '../../data/cubits/auth/forget_password/forget_password_cubit.dart';
import '../../data/cubits/auth/login/login_cubit.dart';
import '../../data/cubits/auth/register/register_cubit.dart';
import '../../data/cubits/booking_services/booking_service_details/booking_service_details_cubit.dart';
import '../../data/cubits/booking_services/instant_booking/instant_booking_cubit.dart';
import '../../data/cubits/complete_booking/complete_booking_cubit.dart';
import '../../data/cubits/complete_booking/complete_booking_state.dart';
import '../../data/cubits/confirm_booking/confirm_booking_cubit.dart';
import '../../data/cubits/confirm_booking/confirm_booking_state.dart';
// EditReservationCubit معطّل مع الـ route بتاعه (التعديل بقى عبر تفاصيل البوابة).
// import '../../data/cubits/edit_reservation/edit_reservation_cubit.dart';
// edit_reservation_state.dart لسه مطلوب لأنه بيعرّف EditReservationArgs المستخدم
// في bookingServiceDetailsScreen.
import '../../data/cubits/contact_info/contact_info_cubit.dart';
import '../../data/cubits/edit_reservation/edit_reservation_state.dart';
import '../../data/cubits/favorites/favorites_cubit.dart';
import '../../data/cubits/direct_services/direct_service_details_cubit.dart';
import '../../data/cubits/direct_services/direct_services_list_cubit.dart';
import '../../data/cubits/home/home_cubit.dart';
import '../../data/cubits/new_suggestion/new_suggestion_cubit.dart';
import '../../data/cubits/notifications/notifications_cubit.dart';
import '../../data/cubits/order_details/order_details_cubit.dart';
import '../../data/cubits/payment_history/payment_history_cubit.dart';
import '../../data/cubits/posts/post_cubit.dart';
import '../../data/cubits/profile/profile_cubit.dart';
import '../../data/cubits/request_to_join/request_to_join_cubit.dart';

class AppRouter {
  /// Decides where to land on startup based on the cached user.
  /// Where the splash sends the user on launch (onboarding is handled earlier
  /// in the splash). Only three outcomes:
  ///   • signed-in before (or browsing as guest) → home
  ///   • otherwise                               → login
  /// The intermediate auth states (add phone / OTP / complete profile) are part
  /// of the sign-in flow itself and are no longer used as launch destinations.
  static String getInitialRoute(UserService userService) {
    if (userService.currentUser != null || userService.isGuest) {
      return Routes.mainScreen;
    }
    return Routes.loginScreen;
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return _page(const SplashScreen(), settings);

      case Routes.onboardingScreen:
        return _page(
          BlocProvider(
            create: (context) => OnboardingLocationCubit(
              context.read<LocationRepo>(),
              context.read<LocationService>(),
            ),
            child: const OnboardingScreen(),
          ),
          settings,
        );

      case Routes.loginScreen:
        return _page(
          BlocProvider(
            create: (context) => LoginCubit(
              context.read<LoginRepo>(),
              context.read<UserService>(),
              context.read<LocalAuthService>(),
              GoogleAuthService(),
              AppleAuthService(),
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
              context.read<LocationService>(),
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
              context.read<UserService>(),
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
              context.read<UserService>(),
            )..prepareEditProfile(),
            child: const EditProfileScreen(),
          ),
          settings,
        );

      case Routes.changePassword:
        return _page(
          BlocProvider(
            create: (context) => ProfileCubit(
              context.read<ProfileRepo>(),
              context.read<LocationRepo>(),
              context.read<UserService>(),
            ),
            child: const ChangePasswordScreen(),
          ),
          settings,
        );

      case Routes.instantBookingServicesScreen:
        return _page(
          BlocProvider(
            // PortsFilterCubit is now app-wide (see BlocProviders.providers) so
            // the "تصفيه" draft + date survive leaving and re-entering this
            // screen; the cubit below reads it to re-apply the filter on entry.
            create: (context) => InstantBookingCubit(
              context.read<BookingServicesPortsRepo>(),
              context.read<HomeRepo>(),
              context.read<HomeCubit>(),
              context.read<LocationService>(),
              context.read<PortsFilterCubit>(),
            )..loadPorts(),
            child: const InstantBookingServicesScreen(),
          ),
          settings,
        );

      case Routes.bookingServiceDetailsScreen:
        final bookingArg = settings.arguments;
        return _page(
          BlocProvider(
            create: (context) => BookingServiceDetailsCubit(
              context.read<PortServicesRepo>(),
              context.read<FavoritesRepo>(),
              context.read<HomeCubit>(),
              context.read<ConfirmBookingRepo>(),
              context.read<BookingServicesPortsRepo>(),
              context.read<MyBookingsRepo>(),
              context.read<UserService>(),
              context.read<LocationService>(),
              port: bookingArg is Item ? bookingArg : null,
              // Opened from a special offer (SpecialOffer) or a shared deep
              // link (int) — only the portId is available in both cases.
              portId: bookingArg is SpecialOffer
                  ? bookingArg.portId
                  : bookingArg is int
                      ? bookingArg
                      : null,
              // A special offer points at a specific service — auto-select it
              // on open (its free gift additions follow via serviceDetails).
              autoSelectServiceId:
                  bookingArg is SpecialOffer ? bookingArg.id : null,
              // Opened from "حجوزاتي" to edit an existing reservation: the same
              // module pre-fills the selections and confirms an update instead.
              editArgs:
                  bookingArg is EditReservationArgs ? bookingArg : null,
            ),
            child: const BookingServiceDetailsScreen(),
          ),
          settings,
        );

      case Routes.completeBookingScreen:
        return _page(
          BlocProvider(
            create: (context) => CompleteBookingCubit(
              context.read<ConfirmBookingRepo>(),
              context.read<HomeCubit>(),
              args: settings.arguments is CompleteBookingArgs
                  ? settings.arguments as CompleteBookingArgs
                  : const CompleteBookingArgs(),
            ),
            child: const CompleteBookingScreen(),
          ),
          settings,
        );

      case Routes.paymentHistoryScreen:
        return _page(
          BlocProvider(
            create: (context) =>
                PaymentHistoryCubit(context.read<PaymentHistoryRepo>())
                  ..loadAll(),
            child: const PaymentHistoryScreen(),
          ),
          settings,
        );

      case Routes.newSuggestionScreen:
        return _page(
          BlocProvider(
            create: (context) => NewSuggestionCubit(
              context.read<NewSuggestionRepo>(),
              context.read<LocationRepo>(),
              context.read<ConfirmBookingRepo>(),
              context.read<HomeRepo>(),
            )..loadGovernorates(),
            child: const NewSuggestionScreen(),
          ),
          settings,
        );

      case Routes.notificationsScreen:
        return _page(
          BlocProvider(
            create: (context) =>
                NotificationsCubit(context.read<NotificationsRepo>())
                  ..getNotifications(),
            child: const NotificationScreen(),
          ),
          settings,
        );

      case Routes.requestToJoinScreen:
        return _page(
          BlocProvider(
            create: (context) => RequestToJoinCubit(
              context.read<RequestToJoinRepo>(),
              context.read<LocationRepo>(),
              context.read<HomeRepo>(),
            )..loadGovernorates(),
            child: const RequestToJoinScreen(),
          ),
          settings,
        );

      case Routes.contactUsScreen:
        return _page(
          BlocProvider(
            create: (context) =>
                ContactUsCubit(context.read<ContactUsRepo>())..init(),
            child: const ContactUsScreen(),
          ),
          settings,
        );

      case Routes.orderDetailsScreen:
        return _page(
          BlocProvider(
            create: (context) =>
                OrderDetailsCubit(context.read<OrderDetailsRepo>())
                  ..getOrderDetails(
                    id: settings.arguments is int
                        ? settings.arguments as int
                        : null,
                  ),
            child: const OrderDetailsScreen(),
          ),
          settings,
        );

      case Routes.confirmBookingScreen:
        return _page(
          BlocProvider(
            create: (context) => ConfirmBookingCubit(
              context.read<ConfirmBookingRepo>(),
              context.read<UserService>(),
            )..init(
                    args: settings.arguments is ConfirmBookingArgs
                        ? settings.arguments as ConfirmBookingArgs
                        : null,
                  ),
            child: const ConfirmBookingScreen(),
          ),
          settings,
        );

      case Routes.paymentWebViewScreen:
        return _page(
          PaymentWebViewScreen(
            result: settings.arguments is PaymentGatewayResult
                ? settings.arguments as PaymentGatewayResult
                : null,
          ),
          settings,
        );

      case Routes.favoritesScreen:
        return _page(
          BlocProvider(
            create: (context) =>
                FavoritesCubit(context.read<FavoritesRepo>())..loadFavorites(),
            child: const FavoritesScreen(),
          ),
          settings,
        );

      // ── صفحة "تعديل الحجز" المنفصلة معطّلة ──
      // التعديل بقى بيتم عبر صفحة تفاصيل البوابة (BookingServiceDetailsScreen)
      // مع autofill للاختيارات السابقة، فالـ route ده مش مستخدم.
      // case Routes.editReservationScreen:
      //   return _page(
      //     BlocProvider(
      //       create: (context) => EditReservationCubit(
      //         context.read<ConfirmBookingRepo>(),
      //         context.read<LocationRepo>(),
      //         context.read<PortServicesRepo>(),
      //         args: settings.arguments is EditReservationArgs
      //             ? settings.arguments as EditReservationArgs
      //             : const EditReservationArgs(reservationId: 0),
      //       ),
      //       child: const EditReservationScreen(),
      //     ),
      //     settings,
      //   );

      case Routes.directServicesListScreen:
        return _page(
          BlocProvider(
            create: (context) => DirectServicesListCubit(
              context.read<BookingServicesPortsRepo>(),
              context.read<HomeRepo>(),
              context.read<HomeCubit>(),
              context.read<LocationService>(),
            )..loadPorts(),
            child: const DirectServicesListScreen(),
          ),
          settings,
        );

      case Routes.directServiceDetailsScreen:
        return _page(
          BlocProvider(
            create: (context) => DirectServiceDetailsCubit(
              context.read<PortServicesRepo>(),
              context.read<WalletRepo>(),
              context.read<FavoritesRepo>(),
              context.read<BookingServicesPortsRepo>(),
              context.read<LocationService>(),
              port: settings.arguments is Item
                  ? settings.arguments as Item
                  : null,
              // Opened from a special offer (SpecialOffer) — only the portId is
              // available, so the cubit loads the full port by id.
              portId: settings.arguments is SpecialOffer
                  ? (settings.arguments as SpecialOffer).portId
                  : null,
            ),
            child: const DirectServiceDetailsScreen(),
          ),
          settings,
        );

      case Routes.contactInfoScreen:
        final contactArgs = settings.arguments;
        final port = contactArgs is ContactInfoArgs
            ? contactArgs.port
            : contactArgs is Item
                ? contactArgs
                : null;
        final isBookingService = contactArgs is ContactInfoArgs
            ? contactArgs.isBookingService
            : false;
        return _page(
          BlocProvider(
            create: (context) => ContactInfoCubit(
              context.read<PortServicesRepo>(),
              portId: port?.id ?? 0,
              isBookingService: isBookingService,
              // Direct services read the numbers off the port itself;
              // GetPortContactInfo is reserved for booking services.
              portPhones: [
                if (port?.phoneNumber1 != null) port!.phoneNumber1!,
                if (port?.phoneNumber2 != null) port!.phoneNumber2!,
              ].map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
            ),
            child: ContactInfoScreen(
              port: port,
              isBookingService: isBookingService,
            ),
          ),
          settings,
        );

      // Deep-link paths like `/port/<id>` are handled solely by app_links
      // (DeepLinkService) — the router must NOT also open them, otherwise the
      // screen opens twice. Anything unknown here is a genuine bad route.
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
