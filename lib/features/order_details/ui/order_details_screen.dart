import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_images.dart';
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
                        child: Icon(Icons.more_horiz,
                            color: AppColors.blacksoft, size: 24.r),
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

                        _SectionHeader('الخدمات الأساسية'),
                        10.verticalSpace,
                        _BasicServiceCard(item: order.basicService),
                        20.verticalSpace,

                        _SectionHeader('الإضافات'),
                        10.verticalSpace,
                        ...order.additions
                            .map((a) => _AdditionCard(item: a)),
                        20.verticalSpace,

                        _SectionHeader('البوفيه'),
                        10.verticalSpace,
                        ...order.buffet.map((a) => _AdditionCard(item: a)),
                        20.verticalSpace,

                        _SectionHeader('تفاصيل التكلفة'),
                        10.verticalSpace,
                        _CostBreakdownCard(rows: order.costBreakdown),
                        20.verticalSpace,

                        _TotalCard(order: order),
                        20.verticalSpace,

                        _SectionHeader('إضافة ملاحظات'),
                        10.verticalSpace,
                        const _NotesField(),
                        20.verticalSpace,
                      ],
                    ),
                  ),
                ),
                // ── Bottom action buttons ──
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
                            NavigationHelper.pushNamed(
                              Routes.editReservationScreen,
                              arguments: EditReservationArgs(
                                reservationId: id,
                                isConfirmed: order.status == 'حجز مؤكد',
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
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: ShapeDecoration(
        color: AppColors.lightestPrimaryColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFF6DCC9)),
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.name, style: AppTextStyles.font16BlackBold),
                    2.verticalSpace,
                    Text(c.email, style: AppTextStyles.font12greyRegular),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(8.r),
                  border: const Border.fromBorderSide(
                      BorderSide(color: Color(0xFFF6DCC9))),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(order.bookingNumber,
                        style: TextStyle(
                          color: AppColors.orangeColor,
                          fontSize: 13.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w700,
                        )),
                    4.horizontalSpace,
                    Icon(Icons.confirmation_number_outlined,
                        size: 14.r, color: AppColors.orangeColor),
                  ],
                ),
              ),
            ],
          ),
          12.verticalSpace,
          const Divider(color: Color(0xFFF0E2D6), height: 1),
          12.verticalSpace,
          _infoRow(AppImages.iconsPhone, 'رقم الهاتف', c.phone),
          12.verticalSpace,
          _infoRow(AppImages.iconsLocation2, 'العنوان', c.address),
        ],
      ),
    );
  }

  Widget _infoRow(String icon, String label, String value) {
    return Row(
      children: [
        CustomImageHandler(icon,
            width: 18.r, height: 18.r, color: AppColors.orangeColor),
        10.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.font12greyRegular),
              2.verticalSpace,
              Text(value,
                  style: TextStyle(
                    color: AppColors.blacksoft,
                    fontSize: 13.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w600,
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
      decoration: ShapeDecoration(
        color: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFEDEDED)),
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F7EE),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(order.status,
                    style: TextStyle(
                      color: const Color(0xFF1F9D55),
                      fontSize: 12.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                    )),
              ),
              const Spacer(),
              Text('${order.createdDate}  ${order.createdTime}',
                  style: AppTextStyles.font12greyRegular),
              6.horizontalSpace,
              CustomImageHandler(AppImages.iconsCalendar,
                  width: 16.r, height: 16.r, color: AppColors.grey),
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
                  line1: '${order.hallName}  -  ${order.eventType}',
                  line2: order.venueLocation,
                ),
              ),
              Container(width: 1, height: 36.h, color: const Color(0xFFEDEDED)),
              12.horizontalSpace,
              // date (left)
              Expanded(
                child: _miniBlock(
                  icon: AppImages.iconsCalendar2,
                  line1: order.eventDay,
                  line2: order.eventDate,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniBlock({
    required String icon,
    required String line1,
    required String line2,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomImageHandler(icon,
            width: 18.r, height: 18.r, color: AppColors.orangeColor),
        8.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(line1,
                  style: TextStyle(
                    color: AppColors.blacksoft,
                    fontSize: 13.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w700,
                  )),
              2.verticalSpace,
              Text(line2, style: AppTextStyles.font12greyRegular),
            ],
          ),
        ),
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
        color: const Color(0xFFF8F8F8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      child: child,
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────
//  Basic service card
// ─────────────────────────────────────────────────────────────────────────
class _BasicServiceCard extends StatelessWidget {
  final OrderLineItem item;
  const _BasicServiceCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(item.name,
                    style: TextStyle(
                      color: AppColors.blacksoft,
                      fontSize: 14.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                    )),
              ),
              _priceText(item.price),
            ],
          ),
          if (item.description != null) ...[
            6.verticalSpace,
            Text(item.description!, style: AppTextStyles.font12greyRegular),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
//  Addition / buffet card
// ─────────────────────────────────────────────────────────────────────────
class _AdditionCard extends StatelessWidget {
  final OrderLineItem item;
  const _AdditionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: _sectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(item.name,
                      style: TextStyle(
                        color: AppColors.blacksoft,
                        fontSize: 14.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                      )),
                ),
                _priceText(item.price),
              ],
            ),
            if (item.count != null) ...[
              4.verticalSpace,
              Text('عدد ${item.count}',
                  style: AppTextStyles.font12greyRegular),
            ],
            if (item.subName != null) ...[
              10.verticalSpace,
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
                  const Spacer(),
                  _priceText(item.subPrice ?? 0),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
//  Cost breakdown card
// ─────────────────────────────────────────────────────────────────────────
class _CostBreakdownCard extends StatelessWidget {
  final List<CostRow> rows;
  const _CostBreakdownCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return _sectionCard(
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rows[i].label,
                          style: AppTextStyles.font14BlacksoftRegular),
                      if (rows[i].subtitle != null)
                        Text(rows[i].subtitle!,
                            style: AppTextStyles.font12greyRegular),
                    ],
                  ),
                ),
                Text('${rows[i].value} ${rows[i].unit}',
                    style: AppTextStyles.font14BlacksoftRegular),
              ],
            ),
            if (i != rows.length - 1) 10.verticalSpace,
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
//  Total card
// ─────────────────────────────────────────────────────────────────────────
class _TotalCard extends StatelessWidget {
  final OrderDetailsModel order;
  const _TotalCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: ShapeDecoration(
        color: AppColors.lightestPrimaryColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFF6DCC9)),
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
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
    );
  }

  Widget _totalRow(String label, num value) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: AppTextStyles.font14BlacksoftRegular),
        ),
        Text('$value جنيه', style: AppTextStyles.font14BlacksoftRegular),
      ],
    );
  }
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
        fillColor: const Color(0xFFF8F8F8),
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
                fillColor: const Color(0xFFF4F4F4),
                hintText: 'اكتب تقييمك هنا',
                hintStyle: TextStyle(
                  color: const Color(0xFF99A2AC),
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
            color: const Color(0xFFA5B7C6),
            fontSize: unitSize.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}
