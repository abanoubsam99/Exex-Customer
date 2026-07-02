import 'dart:ui';

import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/constants/layout_constants.dart';
import 'package:evex_user/core/helpers/extensions.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/helpers/auth_guard.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/cubits/main/main_cubit.dart';
import 'package:evex_user/data/cubits/main/main_state.dart';
import 'package:evex_user/features/home/ui/home_screen.dart';
import 'package:evex_user/features/more/ui/more_screen.dart';
import 'package:evex_user/features/my_bookings/ui/my_bookings_screen.dart';
import 'package:evex_user/features/wallet/ui/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

/// How far the frosted blur layer extends beyond the nav bar pill on each side
/// so the blur is visible around the opaque white bar instead of being fully
/// covered by it.
const double _kNavBarBlurInflate = 8;

class _MainScreenState extends State<MainScreen> {
  static const List<Widget> _pages = [
    HomeScreen(),
    MyBookingsScreen(),
    WalletScreen(),
    MoreScreen(),
  ];

  /// Tabs that have been opened. Only these are actually built — so e.g. the
  /// wallet tab's API call doesn't fire until the user opens it (important for
  /// guests).
  final Set<int> _visited = {0};
  bool _handledArg = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_handledArg) return;
    _handledArg = true;
    // Open a specific tab when asked (e.g. after a booking → "حجوزاتي" / tab 1).
    // Runs before the first build, so the IndexedStack shows it immediately.
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is int && arg > 0) {
      context.read<MainCubit>().goToTab(arg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MainCubit>();
    // The floating nav bar is pushed up by the bottom system inset (Android
    // nav buttons / iOS home indicator) so it clears the system UI instead of
    // hiding behind it.
    final systemNavInset = context.bottomSafeInset;
    return Scaffold(
      body: Stack(
        children: [
          // Pages fill the full height; each scrollable page reserves
          // kFloatingNavBarSpace at its bottom so content clears the floating
          // bar without leaving a dead white band behind it.
          // IndexedStack (not PageView) so the shown page always matches the
          // selected tab — index-based, no controller-timing races on rebuild.
          BlocBuilder<MainCubit, MainState>(
            buildWhen: (p, c) => p.currentPage != c.currentPage,
            builder: (context, state) {
              _visited.add(state.currentPage);
              return IndexedStack(
                index: state.currentPage,
                children: List.generate(
                  _pages.length,
                  (i) =>
                      _visited.contains(i) ? _pages[i] : const SizedBox.shrink(),
                ),
              );
            },
          ),
          // Pill-shaped frosted layer sitting BEHIND the floating nav bar (a
          // separate layer, not part of the bar). It mirrors the bar's rounded
          // shape but is inflated a bit on every side so the blur peeks out
          // around the opaque white pill as a soft frosted halo — matching the
          // Figma "Background blur" on the nav bar rectangle.
          Positioned(
            bottom: systemNavInset + kNavBarMargin.r - _kNavBarBlurInflate*5,
            left:0,
            right: 0,
            height: kNavBarHeight.r + _kNavBarBlurInflate * 4,
            child: IgnorePointer(
              child: ClipRRect(
                // borderRadius: BorderRadius.circular(45 + _kNavBarBlurInflate),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: systemNavInset,
            left: 0,
            right: 0,
            child: Container(
              height: kNavBarHeight.r,
              margin: EdgeInsets.all(kNavBarMargin.r),
              padding: EdgeInsets.symmetric(horizontal: 35.r, vertical: 12.r),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45),
                ),
                shadows: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 22,
                    offset: Offset(0, 4),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: BlocBuilder<MainCubit, MainState>(
                builder: (context, state) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _NavItem(
                      icon: AppImages.iconsHouse,
                      label: 'الرئيسيه',
                      page: 0,
                      currentPage: state.currentPage,
                      onTap: () => cubit.goToTab(0),
                    ),
                    _NavItem(
                      // materialIcon: Icons.shopping_cart_outlined,
                      icon: AppImages.iconsCart,
                      label: 'حجوزاتى',
                      page: 1,
                      currentPage: state.currentPage,
                      onTap: () => _selectTab(context, cubit, 1),
                    ),
                    _NavItem(
                      icon: AppImages.iconsWallet,
                      label: 'المحفظه',
                      page: 2,
                      currentPage: state.currentPage,
                      onTap: () => _selectTab(context, cubit, 2),
                    ),
                    _NavItem(
                      icon: AppImages.iconsMenu,
                      label: 'المزيد',
                      page: 3,
                      currentPage: state.currentPage,
                      onTap: () => cubit.goToTab(3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Switches tabs, but gates the account-based tabs (bookings, wallet) so a
/// guest is prompted to sign in instead of opening them.
void _selectTab(BuildContext context, MainCubit cubit, int page) {
  if ((page == 1 || page == 2) && !AuthGuard.requireLogin(context)) return;
  cubit.goToTab(page);
}

class _NavItem extends StatelessWidget {
  /// Asset path for an SVG/PNG icon. Use either [icon] or [materialIcon].
  final String? icon;

  /// A built-in Material icon, rendered when [icon] is not provided.
  final IconData? materialIcon;
  final String label;
  final int page;
  final int currentPage;
  final VoidCallback onTap;

  const _NavItem({
    this.icon,
    this.materialIcon,
    required this.label,
    required this.page,
    required this.currentPage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentPage == page;
    final color = isActive ? AppColors.primaryColor : AppColors.grey;
    return ZoomTapAnimation(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            materialIcon != null
                ? Icon(materialIcon, color: color, size: 24.r)
                : CustomImageHandler(
                    icon!,
                    color: color,
                    height: 24.r,
                    width: 24.r,
                  ),
            4.verticalSpace,
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primaryColor : AppColors.grey,
                fontSize: 12.r,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
