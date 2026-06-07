import 'package:evex_user/core/models/user_model.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/features/auth/add_client/logic/add_client_binding.dart';
import 'package:evex_user/features/auth/add_phone/logic/binding/add_phone_binding.dart';
import 'package:evex_user/features/auth/add_phone/logic/binding/add_phone_otp_binding.dart';
import 'package:evex_user/features/auth/add_phone/view/screen/add_phone_otp_screen.dart';
import 'package:evex_user/features/auth/add_phone/view/screen/add_phone_screen.dart';
import 'package:evex_user/features/auth/add_client/ui/add_client_screen.dart';
import 'package:evex_user/features/auth/login/logic/login_binding.dart';
import 'package:evex_user/features/auth/login/ui/login_screen.dart';
import 'package:evex_user/features/auth/register/logic/register_binding.dart';
import 'package:evex_user/features/auth/register/ui/register_screen.dart';
import 'package:evex_user/features/auth/reset_password/logic/binding/forget_password_binding.dart';
import 'package:evex_user/features/auth/reset_password/logic/binding/forget_password_otp_binding.dart';
import 'package:evex_user/features/auth/reset_password/view/screen/forget_password_otp_screen.dart';
import 'package:evex_user/features/auth/reset_password/view/screen/forget_password_screen.dart';
import 'package:evex_user/features/auth/reset_password/view/screen/reset_password_screen.dart';
import 'package:evex_user/features/booking_services/booking_service_details/logic/port_services_binding.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/booking_service_details_screen.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/complete_booking_screen.dart';
import 'package:evex_user/features/booking_services/instant_booking_services/logic/booking_services_ports_binding.dart';
import 'package:evex_user/features/booking_services/instant_booking_services/ui/instant_booking_services_screen.dart';
import 'package:evex_user/features/main/logic/main_binding.dart';
import 'package:evex_user/features/main/ui/main_screen.dart';
import 'package:evex_user/features/onboarding/ui/onboarding_screen.dart';
import 'package:evex_user/features/payment_history/logic/transactions_history_binding.dart';
import 'package:evex_user/features/payment_history/ui/payment_history_screen.dart';
import 'package:evex_user/features/posts/logic/post_binding.dart';
import 'package:evex_user/features/posts/ui/posts_screen.dart';
import 'package:evex_user/features/profile/logic/profile_binding.dart';
import 'package:evex_user/features/profile/view/screens/edit_profile_screen.dart';
import 'package:evex_user/features/profile/view/screens/profile_screen.dart';
import 'package:evex_user/features/splash/splash_screen.dart';
import 'package:evex_user/new_suggestion_screen.dart';
import 'package:get/get.dart';

import '../../features/home/ui/home_screen.dart';

class AppRouter {
  static String getInitialRoute() {
    UserModel? user = UserService.to.currentUser.value;
    if (user == null) {
      return Routes.loginScreen;
    } else if (user.userViewModel?.phoneNumber == null) {
      return Routes.addPhoneScreen;
    } else if ((user.modelId == 0 || user.modelId == null)) {
      return Routes.addClientScreen;
    } else {
      return Routes.mainScreen;
    }
  }

  static appPages() => [

    GetPage(name: Routes.onboardingScreen, page: () => const OnboardingScreen()),
    GetPage(name: Routes.splashScreen, page: () => const SplashScreen()),

    GetPage(
      name: Routes.onboardingScreen,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: Routes.registerScreen,
      binding: RegisterBinding(),
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: Routes.loginScreen,
      binding: LoginBinding(),
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: Routes.addPhoneScreen,
      binding: AddPhoneBinding(),
      page: () => const AddPhoneScreen(),
    ),
    GetPage(
      name: Routes.addPhoneOptScreen,
      binding: AddPhoneOtpBinding(),
      page: () => const AddPhoneOtpScreen(),
    ),
    GetPage(
      name: Routes.addClientScreen,
      binding: AddClientBinding(),
      page: () => const AddClientScreen(),
    ),
    GetPage(
      name: Routes.forgetPasswordScreen,
      binding: ForgetPasswordBinding(),
      page: () => const ForgetPasswordScreen(),
    ),
    GetPage(
      name: Routes.forgetPasswordOtpScreen,
      binding: ForgetPasswordOtpBinding(),
      page: () => const ForgetPasswordOtpScreen(),
    ),
    GetPage(
      name: Routes.resetPasswordScreen,
      page: () => const ResetPasswordScreen(),
    ),
    GetPage(
      name: Routes.postsScreen,
      binding: PostBinding(),
      page: () => const PostsScreen(),
    ),
    GetPage(
      name: Routes.newSuggestionScreen,
      page: () => const NewSuggestionScreen(),
    ),
    GetPage(
      name: Routes.mainScreen,
      binding: MainBinding(),
      page: () => const MainScreen(),
    ),
    GetPage(name: Routes.homeScreen, page: () => const HomeScreen()),
    GetPage(
      name: Routes.profileScreen,
      binding: ProfileBinding(),
      page: () => const ProfileScreen(),
    ),
      GetPage(
          name: Routes.editProfile,
          binding: ProfileBinding(),
          page: () => const EditProfileScreen()),
    GetPage(
      name: Routes.instantBookingServicesScreen,
      binding: BookingServicesPortsBinding(),
      page: () => const InstantBookingServicesScreen(),
    ),
    GetPage(
      name: Routes.bookingServiceDetailsScreen,
      binding: InstanceBookingBinding(),
      page: () => const BookingServiceDetailsScreen(),
    ),
    GetPage(
      name: Routes.completeBookingScreen,
      page: () => const CompleteBookingScreen(),
    ),

    GetPage(
      name: Routes.paymentHistoryScreen,
      binding: TransactionsHistoryBinding(),
      page: () => const PaymentHistoryScreen(),
    ),
  ];
}
