import 'package:evex_user/core/constants/layout_constants.dart';
import 'package:evex_user/core/ui/widgets/section_seperator.dart';
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/features/home/ui/widgets/home_header.dart';
import 'package:evex_user/features/home/ui/widgets/join_us_section.dart';
import 'package:evex_user/features/home/ui/widgets/new_suggestion_section.dart';
// import 'package:evex_user/features/home/ui/widgets/other_services_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/Instant_booking_services_section.dart';
import 'widgets/instant_payment_services.dart';
import 'widgets/special_offers_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch fresh home data each time a new MainScreen mounts (app start or
    // re-login) so a previous account's data never lingers.
    context.read<HomeCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () => context.read<HomeCubit>().init(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const HomeHeader(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      const InstantBookingServicesSection(),
                      16.verticalSpace,
                      const InstantPaymentServices(),
                      // const OtherServicesSection(),
                      // 16.verticalSpace,
                    ],
                  ),
                ),
                // Figma divider between الخدمات المباشرة and عروض مميزه.
                26.verticalSpace,
                const SectionSeperator(),
                16.verticalSpace,
                const SpecialOffersSection(),
                26.verticalSpace,
                const SectionSeperator(),
                16.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      const JoinUsSection(),
                      16.verticalSpace,
                      const NewSuggestionSection(),
                    ],
                  ),
                ),
                // Clear the floating nav bar at the end of the scroll.
                SizedBox(height: navBarBottomReserve(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
