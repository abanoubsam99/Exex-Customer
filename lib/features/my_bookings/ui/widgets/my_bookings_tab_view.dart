import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/layout_constants.dart';
import 'package:evex_user/core/helpers/date_format_helper.dart';
import 'package:evex_user/core/helpers/reservation_status_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/widgets/confirm_dialog.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/empty_list_widget.dart';
import 'package:evex_user/core/ui/widgets/load_more_listener.dart';
import 'package:evex_user/data/cubits/confirm_booking/confirm_booking_state.dart';
import 'package:evex_user/data/cubits/edit_reservation/edit_reservation_state.dart';
import 'package:evex_user/data/cubits/my_bookings/my_bookings_cubit.dart';
import 'package:evex_user/data/cubits/my_bookings/my_bookings_state.dart';
import 'package:evex_user/data/models/pending_deposit_model.dart';
import 'package:evex_user/features/my_bookings/ui/widgets/my_booking_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

import '../../../../core/ui/helpers/toast_manager.dart';

const _green = AppColors.green;
const _red = AppColors.coral;

class MyBookingsTabView extends StatelessWidget {
  const MyBookingsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MyBookingsCubit>();
    return BlocBuilder<MyBookingsCubit, MyBookingsState>(
      builder: (context, state) {
        return TabBarView(
          children: [
            _RequestsTab(
              state: state,
              onRefresh: cubit.loadRequests,
              onLoadMore: cubit.loadMoreRequests,
            ),
            _ReservationsTab(
              state: state,
              onRefresh: cubit.loadReservations,
              onLoadMore: cubit.loadMoreReservations,
            ),
            // Cancelled reservations — filtered from GetMyReservations by status.
            _CancelledTab(
              state: state,
              onRefresh: cubit.loadReservations,
              onLoadMore: cubit.loadMoreReservations,
            ),
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
  final VoidCallback onLoadMore;
  const _RequestsTab({
    required this.state,
    required this.onRefresh,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingRequests && state.requests.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    // When the "تأكيد الحجز" button is hidden, the list itself must clear the
    // floating nav bar so the last card isn't cut off.
    final hasButton = _confirmableIds(state).isNotEmpty;
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: state.requests.isEmpty
                ? _emptyList('لا توجد طلبات حالية')
                : LoadMoreListener(
                  onLoadMore: onLoadMore,
                  child: ListView.separated(
              separatorBuilder: (_, __) => 24.verticalSpace,
              clipBehavior: Clip.none,
              padding: EdgeInsets.fromLTRB(
                  0, 20.h, 0, hasButton ? 12.h : navBarBottomReserve(context)),
              itemCount:
                  state.requests.length + (state.requestsLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.requests.length) {
                  return const PaginationLoader();
                }
                final r = state.requests[index];
                final available =
                    (r.reservationStatus ?? '').contains('متاح');
                // A pending request opens the edit-reservation screen (both on
                // card tap and via the edit icon). The order-details/invoice
                // screen is reserved for confirmed/cancelled reservations only.
                final editArgs = r.id == null
                    ? null
                    : EditReservationArgs(
                        reservationId: r.id!,
                        isConfirmed: false,
                        portId: r.portId,
                        serviceId: r.serviceId,
                        occasionId: r.occasionId,
                        governorate: r.governorate,
                        city: r.city,
                        occasionDate: DateFormatHelper.parse(r.occasionDate),
                        userNotes: r.userNotes,
                      );
                return MyBookingItem(
                  portName: r.portName ?? '',
                  statusText:
                      ReservationStatusHelper.label(r.reservationStatus),
                  statusColor: available ? _green : _red,
                  serviceName: r.serviceName ?? '',
                  serviceDetails: r.serviceDetails ?? '',
                  location: _location(r.governorate, r.city),
                  dateText: DateFormatHelper.arabicDate(r.occasionDate),
                  deposit: r.deposit ?? 0,
                  finalCost: r.finalCost ?? r.apparentPrice ?? 0,
                  apparentPrice: r.apparentPrice ?? 0,
                  // Tapping a request → edit it (not the invoice screen).
                  onTap: editArgs == null ? null : () => _openEdit(editArgs),
                  // Trash icon → confirm, then delete the request.
                  onDelete: r.id == null
                      ? null
                      : () => _confirmDeleteRequest(context, r.id!),
                  onEdit: editArgs == null ? null : () => _openEdit(editArgs),
                );
              },
            ),
                ),
          ),
        ),
        _ConfirmRequestsButton(state: state),
      ],
    );
  }
}

/// Bottom "تأكيد الحجز" button for the current-requests tab: confirms all the
/// available requests at once via the confirm-booking screen. Hidden when there
/// are no available requests.
class _ConfirmRequestsButton extends StatelessWidget {
  final MyBookingsState state;

  const _ConfirmRequestsButton({required this.state});

  @override
  Widget build(BuildContext context) {
    final availableIds = _confirmableIds(state);

    final depositTotal = state.pendingDeposit?.totalDeposit ??
        state.requests
            .where((r) => (r.reservationStatus ?? '').contains('متاح'))
            .fold<num>(0, (sum, r) => sum + (r.deposit ?? 0));

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 85.r),
      child: CustomButton(
        text: 'تأكيد الحجز',
        height: 54.h,
        onTap: () {
          if (availableIds.isEmpty) {
            ToastManager.showError(' يلزم وجود خدمة واحدة على الأقل متاحة للحجز');
            return;
          }

          NavigationHelper.pushNamed(
            Routes.confirmBookingScreen,
            arguments: ConfirmBookingArgs(
              reservationRequestIds: availableIds,
              depositAmount: depositTotal,
            ),
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
  final VoidCallback onLoadMore;
  const _ReservationsTab({
    required this.state,
    required this.onRefresh,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingReservations && state.reservations.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: state.reservations.isEmpty
          ? _emptyList('لا توجد حجوزات مؤكدة')
          : LoadMoreListener(
            onLoadMore: onLoadMore,
            child: ListView.separated(
              separatorBuilder: (_, __) => 24.verticalSpace,
              clipBehavior: Clip.none,
              padding:
                  EdgeInsets.fromLTRB(0, 20.h, 0, navBarBottomReserve(context)),
              itemCount: state.reservations.length +
                  (state.reservationsLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.reservations.length) {
                  return const PaginationLoader();
                }
                final r = state.reservations[index];
                return MyBookingItem(
                  portName: r.portName ?? '',
                  statusText:
                      ReservationStatusHelper.label(r.reservationStatus),
                  statusColor: _green,
                  serviceName: r.serviceName ?? '',
                  serviceDetails: '',
                  location: _location(r.governorate, r.city),
                  dateText: DateFormatHelper.arabicDate(r.occasionDate),
                  deposit: r.deposit ?? 0,
                  finalCost: r.finalCost ?? r.apparentPrice ?? 0,
                  apparentPrice: r.apparentPrice ?? 0,
                  onTap: r.id == null ? null : () => _openDetails(r.id!),
                  // Confirmed cards: no edit/trash — just download (DownloadInfo).
                  onDownload: r.id == null
                      ? null
                      : () => context
                          .read<MyBookingsCubit>()
                          .downloadReservation(r.id!),
                );
              },
            ),
          ),
    );
  }
}

// ── الحجوزات الملغاه ──
class _CancelledTab extends StatelessWidget {
  final MyBookingsState state;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;
  const _CancelledTab({
    required this.state,
    required this.onRefresh,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingReservations && state.cancelled.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: state.cancelled.isEmpty
          ? _emptyList('لا توجد حجوزات ملغاه')
          : LoadMoreListener(
            onLoadMore: onLoadMore,
            child: ListView.separated(
              separatorBuilder: (_, __) => 24.verticalSpace,
              clipBehavior: Clip.none,
              padding:
                  EdgeInsets.fromLTRB(0, 20.h, 0, navBarBottomReserve(context)),
              itemCount:
                  state.cancelled.length + (state.reservationsLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.cancelled.length) {
                  return const PaginationLoader();
                }
                final r = state.cancelled[index];
                return MyBookingItem(
                  portName: r.portName ?? '',
                  statusText: ReservationStatusHelper.label('cancelled'),
                  statusColor: _red,
                  serviceName: r.serviceName ?? '',
                  serviceDetails: '',
                  location: _location(r.governorate, r.city),
                  dateText: DateFormatHelper.arabicDate(r.occasionDate),
                  deposit: r.deposit ?? 0,
                  finalCost: r.finalCost ?? r.apparentPrice ?? 0,
                  apparentPrice: r.apparentPrice ?? 0,
                  onTap: r.id == null ? null : () => _openDetails(r.id!),
                  // Cancelled cards: no edit/trash — just download (DownloadInfo).
                  onDownload: r.id == null
                      ? null
                      : () => context
                          .read<MyBookingsCubit>()
                          .downloadReservation(r.id!),
                );
              },
            ),
          ),
    );
  }
}

void _openDetails(int id) {
  NavigationHelper.pushNamed(Routes.orderDetailsScreen, arguments: id);
}

void _openEdit(EditReservationArgs args) {
  // Editing reuses the booking-details module (autofilled), not a separate
  // screen — the only difference there is a "تأكيد التعديل" button.
  NavigationHelper.pushNamed(
    Routes.bookingServiceDetailsScreen,
    arguments: args,
  );
}

/// Asks for confirmation, then deletes the pending request via the cubit.
Future<void> _confirmDeleteRequest(BuildContext context, int id) async {
  final cubit = context.read<MyBookingsCubit>();
  final confirmed = await ConfirmDialog.show(
    context,
    title: 'حذف الطلب',
    message: 'هل أنت متأكد أنك تريد حذف هذا الطلب؟',
    confirmText: 'حذف',
  );
  if (confirmed) cubit.cancelRequest(id);
}

/// Footer in the requests tab: total deposit for all pending requests +
/// the multi-booking discount + a "confirm all" action (CalculatePendingDeposit).
/// Currently commented out in _RequestsTab — restore by uncommenting there.
// ignore: unused_element
class _PendingDepositFooter extends StatelessWidget {
  final PendingDepositModel summary;
  const _PendingDepositFooter({required this.summary});

  String _n(num v) =>
      v == v.roundToDouble() ? v.round().toString() : v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final availableIds = summary.items
        .where((e) => e.isAvailable && e.id != null)
        .map((e) => e.id!)
        .toList();
    final hasDiscount = summary.additionalDiscountPercentage > 0;
    return Container(
      margin: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: AppColors.blackAlpha14,
            blurRadius: 18,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasDiscount) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.greenBg2,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'خصم ${_n(summary.additionalDiscountPercentage)}% عند حجز '
                '${summary.numberOfReservationsAdditionalDiscount} مناسبات'
                '${summary.additionalDiscountAmount > 0 ? ' (وفّرت ${_n(summary.additionalDiscountAmount)} جنيه)' : ''}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.green6,
                  fontSize: 12.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            12.verticalSpace,
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إجمالي المقدم',
                style: TextStyle(
                  color: AppColors.blacksoft,
                  fontSize: 14.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text.rich(
                textDirection: TextDirection.rtl,
                TextSpan(children: [
                  TextSpan(
                    text: '${_n(summary.totalDeposit)} ',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: 'جنيه',
                    style: TextStyle(
                      color: AppColors.unitGrey,
                      fontSize: 12.r,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ]),
              ),
            ],
          ),
          12.verticalSpace,
          if (availableIds.isEmpty)
            Text(
              'لا توجد حجوزات متاحة للتأكيد حالياً',
              style: TextStyle(
                color: _red,
                fontSize: 12.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
              ),
            )
          else
            CustomButton(
              text: 'تأكيد الحجوزات',
              height: 50.h,
              onTap: () => NavigationHelper.pushNamed(
                Routes.confirmBookingScreen,
                arguments: ConfirmBookingArgs(
                  reservationRequestIds: availableIds,
                  depositAmount: summary.totalDeposit,
                  totalAmount:
                      summary.items.fold<num>(0, (s, e) => s + e.netCost),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Ids of the current requests that can be confirmed now (status "متاح").
/// Empty → the "تأكيد الحجز" button is hidden.
List<int> _confirmableIds(MyBookingsState state) {
  final pd = state.pendingDeposit;
  if (pd != null) {
    return pd.items
        .where((e) => e.isAvailable && e.id != null)
        .map((e) => e.id!)
        .toList();
  }
  return state.requests
      .where((r) =>
          (r.reservationStatus ?? '').contains('متاح') && r.id != null)
      .map((r) => r.id!)
      .toList();
}

String _location(String? governorate, String? city) {
  return [governorate, city]
      .where((e) => e != null && e.trim().isNotEmpty)
      .join('، ');
}

/// Pull-to-refreshable empty placeholder (so RefreshIndicator keeps working).
Widget _emptyList(String message) {
  return EmptyListWidget(scrollable: true, message: message);
}
