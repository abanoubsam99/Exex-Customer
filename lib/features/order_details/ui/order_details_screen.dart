import 'dart:math';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/helpers/reservation_status_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/theme/app_text_styles.dart';
import 'package:evex_user/core/ui/widgets/confirm_dialog.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/cubits/edit_reservation/edit_reservation_state.dart';
import 'package:evex_user/data/cubits/order_details/order_details_cubit.dart';
import 'package:evex_user/data/cubits/order_details/order_details_state.dart';
import 'package:evex_user/data/models/order_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
          builder: (context, state) {
            if (state.isLoading || state.order == null) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.orangeColor),
              );
            }
            final order = state.order!;
            return Column(
              children: [
                // ── Header ──
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 8.h),
                  child: Row(
                    children: [
                      const CustomBackButtonWidget(),
                      12.horizontalSpace,
                      Text('تفاصيل الحجز',
                          style: AppTextStyles.font18BlackExtraBoldHeader),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _showOptionsSheet(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.fillGrey4,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Icon(Icons.more_horiz,
                              color: AppColors.titleGrey2, size: 24.r),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        12.verticalSpace,
                        _CustomerCard(order: order),
                        16.verticalSpace,
                        _BookingSummaryCard(order: order),
                        20.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.lineGrey),
                            borderRadius:BorderRadius.circular(16.r) ,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              _SectionHeader('الخدمات الأساسية'),
                              10.verticalSpace,
                              _AdditionsListCard(items: [order.basicService]),
                              20.verticalSpace,

                              if (order.additions.isNotEmpty) ...[
                                _SectionHeader('الإضافات'),
                                10.verticalSpace,
                                _AdditionsListCard(items: order.additions),
                                20.verticalSpace,
                              ],

                              if (order.buffet.isNotEmpty) ...[
                                _SectionHeader('البوفيه'),
                                10.verticalSpace,
                                _AdditionsListCard(items: order.buffet),
                                20.verticalSpace,
                              ],

                              _SectionHeader('تفاصيل التكلفة'),
                              10.verticalSpace,
                              _CostAndTotalCard(order: order),
                              20.verticalSpace,

                            ],),
                          ),
                        ),

                        20.verticalSpace,
                        _SectionHeader('إضافة ملاحظات'),
                        10.verticalSpace,
                        const _NotesField(),
                        20.verticalSpace,
                      ],
                    ),
                  ),
                ),
                // ── Bottom action buttons (hidden once the reservation is cancelled) ──
                if (!ReservationStatusHelper.isCancelled(order.status))
                  Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 12.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'الغاء الحجز',
                          isfilled: false,
                          height: 52.h,
                          onTap: () async {
                            final cubit = context.read<OrderDetailsCubit>();
                            final ok = await ConfirmDialog.show(
                              context,
                              title: 'إلغاء الحجز',
                              message: 'هل أنت متأكد أنك تريد إلغاء هذا الحجز؟',
                              confirmText: 'إلغاء الحجز',
                            );
                            if (ok) cubit.cancelReservation();
                          },
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: CustomButton(
                          text: 'تعديل الحجز',
                          height: 52.h,
                          onTap: () {
                            final id = order.reservationId;
                            if (id == null) return;
                            // Editing reuses the booking-details (port) module
                            // autofilled — it pre-fills the previous selections
                            // and the bottom button confirms an update instead
                            // of adding a new booking (no separate edit screen).
                            NavigationHelper.pushNamed(
                              Routes.bookingServiceDetailsScreen,
                              arguments: EditReservationArgs(
                                reservationId: id,
                                isConfirmed:
                                  ReservationStatusHelper.isConfirmed(
                                      order.status),
                                portId: order.portId,
                                portName: order.hallName,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
//  Customer card
// ─────────────────────────────────────────────────────────────────────────
class _CustomerCard extends StatelessWidget {
  final OrderDetailsModel order;
  const _CustomerCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final c = order.customer;
    return Container(
      width: double.infinity,
      height: 210.r,
      // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        // Soft diagonal mix: peach (top-right) → white → mint (bottom-left).
        image: DecorationImage(image: AssetImage(AppImages.imagesBgCardDetails),fit: BoxFit.fill),
        // gradient: const LinearGradient(
        //   begin: Alignment.topRight,
        //   end: Alignment.bottomLeft,
        //   colors: [AppColors.peachBg2, AppColors.whiteColor, AppColors.fillGrey3],
        //   stops: [0.0, 0.5, 1.0],
        // ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: AppColors.blacksoft,
                            fontSize: 18.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w800,
                          )),
                      // 4.verticalSpace,
                      Text(c.email,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: AppColors.titleGrey2,
                            fontSize: 13.r,
                            fontFamily: 'Almarai',
                          )),
                    ],
                  ),
                ),
                10.horizontalSpace,
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryAlpha1A,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(AppImages.iconsIc),
                      4.horizontalSpace,
                      Text(order.bookingNumber,
                          style: TextStyle(
                            color: AppColors.orangeColor,
                            fontSize: 13.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w700,
                          )),
                      // 4.horizontalSpace,
                      // Icon(Icons.article_outlined,
                      //     size: 15.r, color: AppColors.orangeColor),
                    ],
                  ),
                ),
              ],
            ),
            5.verticalSpace,
            _infoRow(AppImages.iconsPhone, 'رقم الهاتف', c.phone),
            5.verticalSpace,
            _infoRow(AppImages.iconsLocation2, 'العنوان', c.address),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomImageHandler(icon,
            width: 18.r, height: 18.r, color: AppColors.titleGrey2),
        10.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.titleGrey2,
                    fontSize: 13.r,
                    fontFamily: 'Almarai',
                  )),
              2.verticalSpace,
              Text(value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.blacksoft,
                    fontSize: 14.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
//  Booking summary card
// ─────────────────────────────────────────────────────────────────────────
class _BookingSummaryCard extends StatelessWidget {
  final OrderDetailsModel order;
  const _BookingSummaryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        // shape: RoundedRectangleBorder(
        //   side: const BorderSide(color: AppColors.lineGrey),
        //   borderRadius: BorderRadius.circular(16.r),
        // ),
        border: Border.all(color: AppColors.lineGrey),
        borderRadius:BorderRadius.circular(16.r) ,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: ReservationStatusHelper.isCancelled(order.status)
                      ? AppColors.redBg
                      : AppColors.greenBg1,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(ReservationStatusHelper.label(order.status),
                    style: TextStyle(
                      color: ReservationStatusHelper.isCancelled(order.status)
                          ? AppColors.red3
                          : AppColors.green8,
                      fontSize: 12.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                    )),
              ),
              8.horizontalSpace,
              // Icon(Icons.access_time,color: AppColors.grey),
              CustomImageHandler(AppImages.iconsAccessTime,
                  width: 16.r, height: 16.r, color: AppColors.grey),
              6.horizontalSpace,
              Text('${order.createdDate}  ${order.createdTime}',
                  style: AppTextStyles.font12greyRegular),
              // const Spacer(),
            ],
          ),
          14.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // venue (right)
              Expanded(
                child: _miniBlock(
                  icon: AppImages.iconsBuildings,
                  line1: order.hallName,
                  tag: order.eventType,
                  line2: order.venueLocation,
                ),
              ),
              Container(width: 1, height: 36.h, color: AppColors.lineGrey),
              12.horizontalSpace,
              // date (left)
              Expanded(
                child: _miniBlock(
                  line1: order.eventDay,
                  line1Color: AppColors.orangeColor,
                  line2: order.eventDate,
                  line2Color: AppColors.black,
                  line2Style:FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniBlock({
    String? icon,
    required String line1,
    required String line2,
    String? tag,
    Color? line1Color,
    Color? line2Color,
    FontWeight? line2Style,
  }) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(line1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: line1Color ?? AppColors.blacksoft,
                    fontSize: 13.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w700,
                  )),
            ),
            if (tag != null && tag.isNotEmpty) ...[
              6.horizontalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryAlpha1A,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(tag,
                    style: TextStyle(
                      color: AppColors.orangeColor,
                      fontSize: 10.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                    )),
              ),
            ],
          ],
        ),
        2.verticalSpace,
        Text(line2,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font13greyRegular.copyWith(
              color: line2Color ?? AppColors.grey,
              fontWeight: line2Style?? FontWeight.w400

            )),
      ],
    );
    if (icon == null) return content;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 35.r,
            height: 34.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
        )
            ,child: Padding(
              padding: const EdgeInsets.all(7),
              child: CustomImageHandler(icon, width: 22.r, height: 22.r),
            )),
        8.horizontalSpace,
        Expanded(child: content),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
//  Section header (orange marker + title)
// ─────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 18.h,
          decoration: BoxDecoration(
            color: AppColors.orangeColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        8.horizontalSpace,
        Text(title, style: AppTextStyles.font16BlackBold),
      ],
    );
  }
}

Widget _sectionCard({required Widget child}) {
  return Builder(
    builder: (context) => Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: ShapeDecoration(
        color: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.lineGrey),
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: child,
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────
//  Additions list card
// ─────────────────────────────────────────────────────────────────────────
class _AdditionsListCard extends StatelessWidget {
  final List<OrderLineItem> items;
  const _AdditionsListCard({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AdditionItem(item: item),
              if (i != items.length - 1)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final dashWidth = 5.0;
                      final dashCount = (constraints.constrainWidth() / (2 * dashWidth)).floor();
                      return Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(dashCount, (_) {
                          return SizedBox(
                            width: dashWidth,
                            height: 1,
                            child: const DecoratedBox(decoration: BoxDecoration(color: AppColors.lineGrey)),
                          );
                        }),
                      );
                    },
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _AdditionItem extends StatelessWidget {
  final OrderLineItem item;
  const _AdditionItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8.r, height: 8.r,
              decoration: const BoxDecoration(color: AppColors.orangeColor, shape: BoxShape.circle),
            ),
            8.horizontalSpace,
            Expanded(
              child: Text(item.name,
                  style: TextStyle(
                    color: AppColors.blacksoft,
                    fontSize: 14.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w700,
                  )),
            ),
            if (item.price == 0) ...[
              CustomImageHandler(AppImages.imagesGift, width: 20.r, height: 20.r),
              8.horizontalSpace,
            ],
            _priceText(item.price),
          ],
        ),
        if (item.count != null) ...[
          4.verticalSpace,
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Text('عدد ${item.count}',
                style: AppTextStyles.font12greyRegular),
          ),
        ],
        if (item.description != null) ...[
          6.verticalSpace,
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Text(item.description!, style: AppTextStyles.font12greyRegular),
          ),
        ],
        if (item.subName != null) ...[
          10.verticalSpace,
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.lightestPrimaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(item.subName!,
                      style: TextStyle(
                        color: AppColors.orangeColor,
                        fontSize: 12.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ),
              const Spacer(),
              _priceText(item.subPrice ?? 0),
            ],
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
//  Cost and Total card
// ─────────────────────────────────────────────────────────────────────────
class _CostAndTotalCard extends StatelessWidget {
  final OrderDetailsModel order;
  const _CostAndTotalCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.boarderColor),
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            child: Column(
              children: order.costBreakdown.map((row) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(row.label.tr(),
                                textAlign: TextAlign.right,
                                style: AppTextStyles.font14BlacksoftRegular),
                            if (row.subtitle != null) ...[
                              2.verticalSpace,
                              Text('• ${row.subtitle!}',
                                  textAlign: TextAlign.right,
                                  style: AppTextStyles.font12greyRegular),
                            ],
                          ],
                        ),
                      ),
                      Text.rich(
                        textDirection: TextDirection.rtl,
                        TextSpan(children: [
                          TextSpan(
                            text: '${row.value} ',
                            style: TextStyle(
                              color: AppColors.blacksoft,
                              fontSize: 14.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: row.unit.tr(),
                            style: TextStyle(
                              color: AppColors.blueGrey,
                              fontSize: 12.r,
                              fontFamily: 'Almarai',
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          // Ticket-style separator: concave notches biting into both card edges
          // (band height must equal 2 * notchRadius so the arcs meet the side borders).
          SizedBox(
            height: 24.r,
            width: double.infinity,
            child: CustomPaint(
              painter: _TicketDividerPainter(
                notchRadius: 12.r,
                cardColor: AppColors.whiteColor,
                borderColor: AppColors.boarderColor,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('إجمالي التكلفة',
                          style: AppTextStyles.font16BlackBold),
                    ),
                    _priceText(order.totalCost, numberSize: 22, unitSize: 14),
                  ],
                ),
                12.verticalSpace,
                _totalRow('المدفوع', order.paid),
                8.verticalSpace,
                _totalRow('المتبقي', order.remaining),
                8.verticalSpace,
                _totalRow('المسترد', order.refunded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(String label, num value) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: AppTextStyles.font14BlacksoftRegular),
        ),
        Text.rich(
          textDirection: TextDirection.rtl,
          TextSpan(children: [
            TextSpan(
              text: '$value ',
              style: TextStyle(
                color: AppColors.blacksoft,
                fontSize: 14.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: 'جنيه',
              style: TextStyle(
                color: AppColors.blueGrey,
                fontSize: 12.r,
                fontFamily: 'Almarai',
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

/// Paints the ticket separator: a dashed line with a concave semicircle notch
/// cut into each card edge. The notches erase the card's side border and redraw
/// it as an inward arc, matching the Figma "coupon" divider.
class _TicketDividerPainter extends CustomPainter {
  final double notchRadius;
  final Color cardColor; // erases the card's side border behind the notch
  final Color borderColor;

  const _TicketDividerPainter({
    required this.notchRadius,
    required this.cardColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 5.0;
    const dashGap = 4.0;
    final r = notchRadius;
    final cy = size.height / 2;

    final erase = Paint()
      ..color = cardColor
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Left notch (opens from the left edge, bulging right into the card).
    final leftRect = Rect.fromCircle(center: Offset(0, cy), radius: r);
    canvas
      ..drawPath(
        Path()
          ..moveTo(0, cy - r)
          ..arcToPoint(Offset(0, cy + r),
              radius: Radius.circular(r), clockwise: true)
          ..close(),
        erase,
      )
      ..drawArc(leftRect, -pi / 2, pi, false, stroke);

    // Right notch (opens from the right edge, bulging left into the card).
    final rightRect = Rect.fromCircle(center: Offset(size.width, cy), radius: r);
    canvas
      ..drawPath(
        Path()
          ..moveTo(size.width, cy - r)
          ..arcToPoint(Offset(size.width, cy + r),
              radius: Radius.circular(r), clockwise: false)
          ..close(),
        erase,
      )
      ..drawArc(rightRect, pi / 2, pi, false, stroke);

    // Dashed line spanning between the two notches.
    final endX = size.width - r;
    for (double x = r; x < endX; x += dashWidth + dashGap) {
      canvas.drawLine(Offset(x, cy), Offset(min(x + dashWidth, endX), cy), stroke);
    }
  }

  @override
  bool shouldRepaint(_TicketDividerPainter old) =>
      old.notchRadius != notchRadius ||
      old.cardColor != cardColor ||
      old.borderColor != borderColor;
}

// ─────────────────────────────────────────────────────────────────────────
//  Notes field
// ─────────────────────────────────────────────────────────────────────────
class _NotesField extends StatelessWidget {
  const _NotesField();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrderDetailsCubit>();
    return Focus(
      // Save the note when the field loses focus.
      onFocusChange: (hasFocus) {
        if (!hasFocus) cubit.saveUserNote();
      },
      child: TextFormField(
        controller: cubit.notesController,
        maxLines: 3,
      textAlign: TextAlign.start,
      textDirection: TextDirection.rtl,
      style: AppTextStyles.font14BlacksoftRegular,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.bgLightGrey,
        hintText: 'في حال وجود ملاحظات .. اكتب ملاحظتك هنا باختصار شديد',
        hintStyle: AppTextStyles.font12greyRegular,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(14.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.orangeColor),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      ),
    );
  }
}

void _showOptionsSheet(BuildContext context) {
  final cubit = context.read<OrderDetailsCubit>();
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (sheetCtx) => SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  Icon(Icons.picture_as_pdf, color: AppColors.orangeColor),
              title: Text('تحميل PDF',
                  style: AppTextStyles.font16BlackRegularHeader),
              onTap: () {
                Navigator.pop(sheetCtx);
                cubit.downloadPdf();
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.star_outline_rounded, color: AppColors.orangeColor),
              title: Text('أضف تقييم',
                  style: AppTextStyles.font16BlackRegularHeader),
              onTap: () {
                Navigator.pop(sheetCtx);
                _showReviewSheet(context, cubit);
              },
            ),
          ],
        ),
      ),
    ),
  );
}

/// Bottom sheet to submit a review (stars + comment) for the reservation.
void _showReviewSheet(BuildContext context, OrderDetailsCubit cubit) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (_) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: _ReviewSheet(cubit: cubit),
    ),
  );
}

class _ReviewSheet extends StatefulWidget {
  final OrderDetailsCubit cubit;
  const _ReviewSheet({required this.cubit});

  @override
  State<_ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<_ReviewSheet> {
  final _commentController = TextEditingController();
  int _stars = 0;
  bool _submitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    final ok = await widget.cubit.submitReview(
      stars: _stars,
      comment: _commentController.text,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text('أضف تقييم',
                  style: AppTextStyles.font18BlackExtraBoldHeader),
            ),
            16.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final filled = i < _stars;
                return GestureDetector(
                  onTap: () => setState(() => _stars = i + 1),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Icon(
                      filled ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: AppColors.orangeColor,
                      size: 36.r,
                    ),
                  ),
                );
              }),
            ),
            20.verticalSpace,
            TextField(
              controller: _commentController,
              maxLines: 4,
              textDirection: TextDirection.rtl,
              style: AppTextStyles.font16BlackRegularHeader,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.boarderFillColor,
                hintText: 'اكتب تقييمك هنا',
                hintStyle: TextStyle(
                  color: AppColors.blueGrey,
                  fontSize: 13.r,
                  fontFamily: 'Almarai',
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            ),
            20.verticalSpace,
            CustomButton(
              text: 'إرسال التقييم',
              height: 52.h,
              isLoading: _submitting,
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

/// Price in the app's convention: orange number + smaller, lighter "جنيه".
Widget _priceText(num value, {double numberSize = 16, double unitSize = 12}) {
  return Text.rich(
    textDirection: TextDirection.rtl,
    TextSpan(
      children: [
        TextSpan(
          text: '$value ',
          style: TextStyle(
            color: AppColors.orangeColor,
            fontSize: numberSize.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w800,
          ),
        ),
        TextSpan(
          text: 'جنيه',
          style: TextStyle(
            color: AppColors.unitGrey,
            fontSize: unitSize.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}
