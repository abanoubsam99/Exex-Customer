import 'package:evex_user/features/my_bookings/ui/widgets/my_booking_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBookingsTabView extends StatelessWidget {
  const MyBookingsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        _buildTabContent('Tab 1 Content'),
        _buildTabContent('Tab 2 Content'),
        _buildTabContent('Tab 3 Content'),
      ],
    );
  }
}

Widget _buildTabContent(String content) {
  return RefreshIndicator(
    onRefresh: () async {
      // Your refresh logic here
      await Future.delayed(Duration(seconds: 2));
      // Fetch new data, update state, etc.
    },
    child: ListView.separated(
      separatorBuilder: (context, index) => 24.verticalSpace,
      clipBehavior: Clip.none,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      itemCount: 5,
      itemBuilder: (context, index) {
        return MyBookingItem();
      },
    ),
  );
}
