import 'package:evex_user/features/home/ui/home_screen.dart';
import 'package:evex_user/features/more/ui/more_screen.dart';
import 'package:evex_user/features/my_bookings/ui/my_bookings_screen.dart';
import 'package:evex_user/features/wallet/ui/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  late PageController pageController;

  RxInt currentPage = 0.obs;

  List<Widget> pages = [
    const HomeScreen(),
    const MyBookingsScreen(),
    const WalletScreen(),
    const MoreScreen(),
    // const HomeTab(),
    // const CartTab(),
    // const StatisticsTab(),
    // const ProfileTab(),
  ];

  void goToTab(int page) {
    currentPage.value = page;
    pageController.jumpToPage(page);
  }

  void animateToTab(int page) {
    currentPage.value = page;
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    super.onInit();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
