import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/data/cubits/main/main_cubit.dart';
import 'package:evex_user/data/cubits/my_bookings/my_bookings_cubit.dart';
import 'package:evex_user/data/repos/my_bookings_repo.dart';
import 'package:evex_user/features/my_bookings/ui/widgets/discount_progress.dart';
import 'package:evex_user/features/my_bookings/ui/widgets/my_booking_tabs.dart';
import 'package:evex_user/features/my_bookings/ui/widgets/my_bookings_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MyBookingsCubit(context.read<MyBookingsRepo>())..load(),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                // Sticky Header using SliverAppBar (better approach)
                SliverAppBar(
                  pinned: true,
                  automaticallyImplyLeading: false,
                  toolbarHeight: 60.h, // Adjust to fit your content
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  titleSpacing: 24.w,
                  title: Row(
                    children: [
                      CustomBackButtonWidget(
                        onTap: () {
                          context.read<MainCubit>().goToTab(0);
                        },
                      ),
                      12.horizontalSpace,
                      Text(
                        'حجوزاتي',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFF121212),
                          fontSize: 18.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.24,
                        ),
                      ),
                    ],
                  ),
                ),
                // Scrollable Discount Banner
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        16.verticalSpace,
                        DiscountProgress(),
                        16.verticalSpace,
                      ],
                    ),
                  ),
                ),
                // Sticky TabBar
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyTabBarDelegate(
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: MyBookingTabs(),
                    ),
                  ),
                ),
              ];
            },
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w),
              child: Column(
                children: [
                  Expanded(child: MyBookingsTabView()),
                  16.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
        ),
      );
  }
}

// Simpler delegate
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyTabBarDelegate({required this.child});

  @override
  double get minExtent => 48.0;

  @override
  double get maxExtent => 48.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) => false;
}
