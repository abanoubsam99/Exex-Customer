import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/helpers/date_format_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/data/cubits/my_bookings/my_bookings_cubit.dart';
import 'package:evex_user/data/cubits/my_bookings/my_bookings_state.dart';
import 'package:evex_user/features/my_bookings/ui/widgets/my_booking_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _green = Color(0xFF4CD195);
const _red = Color(0xFFFE7062);

class MyBookingsTabView extends StatelessWidget {
  const MyBookingsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MyBookingsCubit>();
    return BlocBuilder<MyBookingsCubit, MyBookingsState>(
      builder: (context, state) {
        return TabBarView(
          children: [
            _RequestsTab(state: state, onRefresh: cubit.loadRequests),
            _ReservationsTab(state: state, onRefresh: cubit.loadReservations),
            // الحجوزات الملغاه — لسه مفيش API مخصص ليها.
            const _EmptyTab(message: 'لا توجد حجوزات ملغاه'),
          ],
        );
      },
    );
  }
}

// ── الطلبات الحالية ──
class _RequestsTab extends StatelessWidget {
  final MyBookingsState state;
  final Future<void> Function() onRefresh;
  const _RequestsTab({required this.state, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingRequests && state.requests.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: state.requests.isEmpty
          ? _emptyList('لا توجد طلبات حالية')
          : ListView.separated(
              separatorBuilder: (_, __) => 24.verticalSpace,
              clipBehavior: Clip.none,
              padding: EdgeInsets.symmetric(vertical: 20.h),
              itemCount: state.requests.length,
              itemBuilder: (context, index) {
                final r = state.requests[index];
                final available =
                    (r.reservationStatus ?? '').contains('متاح');
                return MyBookingItem(
                  portName: r.portName ?? '',
                  statusText: r.reservationStatus ?? '',
                  statusColor: available ? _green : _red,
                  serviceName: r.serviceName ?? '',
                  serviceDetails: r.serviceDetails ?? '',
                  location: _location(r.governorate, r.city),
                  dateText: DateFormatHelper.arabicDate(r.occasionDate),
                  deposit: r.deposit ?? 0,
                  finalCost: r.finalCost ?? r.apparentPrice ?? 0,
                  apparentPrice: r.apparentPrice ?? 0,
                  onTap: r.id == null ? null : () => _openDetails(r.id!),
                );
              },
            ),
    );
  }
}

// ── الحجوزات المؤكدة ──
class _ReservationsTab extends StatelessWidget {
  final MyBookingsState state;
  final Future<void> Function() onRefresh;
  const _ReservationsTab({required this.state, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingReservations && state.reservations.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: state.reservations.isEmpty
          ? _emptyList('لا توجد حجوزات مؤكدة')
          : ListView.separated(
              separatorBuilder: (_, __) => 24.verticalSpace,
              clipBehavior: Clip.none,
              padding: EdgeInsets.symmetric(vertical: 20.h),
              itemCount: state.reservations.length,
              itemBuilder: (context, index) {
                final r = state.reservations[index];
                final confirmed =
                    (r.reservationStatus ?? '') == 'Confirmed';
                return MyBookingItem(
                  portName: r.portName ?? '',
                  statusText: confirmed
                      ? 'حجز مؤكد'
                      : (r.reservationStatus ?? ''),
                  statusColor: _green,
                  serviceName: r.serviceName ?? '',
                  serviceDetails: '',
                  location: _location(r.governorate, r.city),
                  dateText: DateFormatHelper.arabicDate(r.occasionDate),
                  deposit: r.deposit ?? 0,
                  finalCost: r.finalCost ?? r.apparentPrice ?? 0,
                  apparentPrice: r.apparentPrice ?? 0,
                  onTap: r.id == null ? null : () => _openDetails(r.id!),
                );
              },
            ),
    );
  }
}

// ── تاب فاضي (الحجوزات الملغاه) ──
class _EmptyTab extends StatelessWidget {
  final String message;
  const _EmptyTab({required this.message});

  @override
  Widget build(BuildContext context) => _emptyList(message);
}

void _openDetails(int id) {
  NavigationHelper.pushNamed(Routes.orderDetailsScreen, arguments: id);
}

String _location(String? governorate, String? city) {
  return [governorate, city]
      .where((e) => e != null && e.trim().isNotEmpty)
      .join('، ');
}

/// قائمة فاضية بس قابلة للسحب (عشان الـ RefreshIndicator يشتغل).
Widget _emptyList(String message) {
  return ListView(
    padding: EdgeInsets.symmetric(vertical: 80.h),
    children: [
      Center(
        child: Text(
          message,
          style: TextStyle(
            color: const Color(0xFF6F767E),
            fontSize: 14.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ],
  );
}
