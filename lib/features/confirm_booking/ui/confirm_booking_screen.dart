import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/text_field_builder_widget.dart';
import 'package:evex_user/data/cubits/confirm_booking/confirm_booking_cubit.dart';
import 'package:evex_user/data/cubits/confirm_booking/confirm_booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _orange = Color(0xFFF38B4A);

class ConfirmBookingScreen extends StatelessWidget {
  const ConfirmBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ConfirmBookingCubit>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ConfirmBookingCubit, ConfirmBookingState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Warm gradient top area ──
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 0.55, 1.0],
                            colors: [
                              _orange,
                              Color(0xFFF9B98C),
                              Color(0xFFFDEFE5),
                            ],
                          ),
                        ),
                        child: SafeArea(
                          bottom: false,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Column(
                              children: [
                                12.verticalSpace,
                                _header(state),
                                20.verticalSpace,
                                _timerPill(state),
                                20.verticalSpace,
                                Text(
                                  '${state.totalAmount} جنيه',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26.r,
                                    fontFamily: 'Almarai',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                4.verticalSpace,
                                Text(
                                  'إجمالي مقدم الحجوزات المطلوبة',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.r,
                                    fontFamily: 'Almarai',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                24.verticalSpace,
                                _PaymentMethodsCard(
                                  selected: state.selectedMethod,
                                  onSelect: cubit.selectMethod,
                                ),
                                16.verticalSpace,
                                _expansionContent(context, state, cubit),
                                24.verticalSpace,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // ── Policies (white) ──
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 20.h,
                        ),
                        child: _PoliciesSection(
                          accepted: state.termsAccepted,
                          onChanged: cubit.toggleTerms,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ── Bottom confirm button ──
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 24,
                      offset: Offset(0, -6),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 12.h),
                    child: CustomButton(
                      text: 'تأكيد الدفع',
                      height: 54.h,
                      isLoading: state.isLoading,
                      onTap: cubit.confirmPayment,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _header(ConfirmBookingState state) {
    return Row(
      children: [
        Text(
          'تأكيد الحجز',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () => NavigationHelper.pop(),
          child: Container(
            width: 40.r,
            height: 40.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.4),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16.r),
          ),
        ),
      ],
    );
  }

  Widget _timerPill(ConfirmBookingState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.formattedTime,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w800,
            ),
          ),
          6.horizontalSpace,
          Text(
            'برجاء استكمال عملية الدفع خلال',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _expansionContent(
    BuildContext context,
    ConfirmBookingState state,
    ConfirmBookingCubit cubit,
  ) {
    switch (state.selectedMethod) {
      case BookingPaymentMethod.card:
        return _CardForm(cubit: cubit);
      case BookingPaymentMethod.evex:
        return _WalletBox(balance: state.walletBalance, onRecharge: cubit.rechargeWallet);
      case BookingPaymentMethod.cash:
        return const _CashInfo();
    }
  }
}

// ─────────────────────────── Payment methods card ───────────────────────────
class _PaymentMethodsCard extends StatelessWidget {
  final BookingPaymentMethod selected;
  final ValueChanged<BookingPaymentMethod> onSelect;
  const _PaymentMethodsCard({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 16, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          _row(
            method: BookingPaymentMethod.card,
            label: 'بطاقة إئتمان',
            logos: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppImages.imagesVisa, height: 18.r),
                4.horizontalSpace,
                Image.asset(AppImages.imagesMasterCard2, height: 18.r),
              ],
            ),
          ),
          _divider(),
          _row(
            method: BookingPaymentMethod.evex,
            label: 'محفظة evex',
            logos: Image.asset(AppImages.imagesNewLogo, height: 20.r),
          ),
          _divider(),
          _row(
            method: BookingPaymentMethod.cash,
            label: 'الدفع نقداً',
            logos: Image.asset(AppImages.imagesDollars, height: 20.r),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(color: const Color(0xFFF0F0F0), height: 1.h);

  Widget _row({
    required BookingPaymentMethod method,
    required String label,
    required Widget logos,
  }) {
    final isSelected = selected == method;
    return InkWell(
      onTap: () => onSelect(method),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: const Color(0xFF2C262C),
                fontSize: 14.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
              ),
            ),
            10.horizontalSpace,
            logos,
            const Spacer(),
            Icon(
              isSelected ? Icons.keyboard_arrow_down : Icons.chevron_left,
              color: isSelected ? _orange : const Color(0xFFB7B7B7),
              size: 20.r,
            ),
            10.horizontalSpace,
            _radio(isSelected),
          ],
        ),
      ),
    );
  }

  Widget _radio(bool selected) {
    return Container(
      width: 20.r,
      height: 20.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? _orange : const Color(0xFFCFCFCF),
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: selected
          ? Container(
              width: 10.r,
              height: 10.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _orange,
              ),
            )
          : null,
    );
  }
}

// ─────────────────────────── Card form ───────────────────────────
class _CardForm extends StatelessWidget {
  final ConfirmBookingCubit cubit;
  const _CardForm({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldBuilder(
          title: 'اسم البطاقة',
          hintText: 'اسم صاحب البطاقة',
          controller: cubit.cardNameController,
          validator: (_) => null,
          fillColor: Colors.white,
        ),
        14.verticalSpace,
        TextFieldBuilder(
          title: 'رقم البطاقة',
          hintText: 'رقم البطاقة',
          keyboardType: TextInputType.number,
          controller: cubit.cardNumberController,
          validator: (_) => null,
          fillColor: Colors.white,
        ),
        14.verticalSpace,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFieldBuilder(
                title: 'تاريخ الإنتهاء',
                hintText: '__ / __',
                controller: cubit.expiryController,
                validator: (_) => null,
                fillColor: Colors.white,
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: TextFieldBuilder(
                title: 'CVV',
                hintText: '...',
                keyboardType: TextInputType.number,
                controller: cubit.cvvController,
                validator: (_) => null,
                fillColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────── Wallet box ───────────────────────────
class _WalletBox extends StatelessWidget {
  final num balance;
  final VoidCallback onRecharge;
  const _WalletBox({required this.balance, required this.onRecharge});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Row(
            children: [
              Text(
                'الرصيد النقدي للمحفظة',
                style: TextStyle(
                  color: const Color(0xFF2C262C),
                  fontSize: 14.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '$balance جنيه',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: const Color(0xFF3F8CFF),
                  fontSize: 15.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        12.verticalSpace,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImageHandler(AppImages.iconsInfo,
                width: 16.r, height: 16.r, color: _orange),
            8.horizontalSpace,
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'ينصح بتغيير الرقم السري للمحفظة بشكل دوري لضمان مستوى الأمان ',
                      style: TextStyle(
                        color: const Color(0xFF6F767E),
                        fontSize: 12.r,
                        fontFamily: 'Almarai',
                        height: 1.6,
                      ),
                    ),
                    TextSpan(
                      text: 'تغيير كلمة المرور للمحفظة',
                      style: TextStyle(
                        color: _orange,
                        fontSize: 12.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        14.verticalSpace,
        CustomButton(
          text: 'شحن المحفظة',
          isfilled: false,
          backgroundColor: Colors.transparent,
          bordereColor: _orange,
          fontColor: _orange,
          height: 48.h,
          width: double.infinity,
          onTap: onRecharge,
        ),
      ],
    );
  }
}

// ─────────────────────────── Cash info ───────────────────────────
class _CashInfo extends StatelessWidget {
  const _CashInfo();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomImageHandler(AppImages.iconsInfo,
            width: 18.r, height: 18.r, color: _orange),
        8.horizontalSpace,
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      'يمكنك استكمال الحجز بالدفع نقداً بمكتب الشركة علماً بأنه حتى تلك اللحظة، لايمكننا تثبيت أو حجز الميعاد المطلوب قبل دفع المبلغ ',
                  style: TextStyle(
                    color: const Color(0xFF6F767E),
                    fontSize: 13.r,
                    fontFamily: 'Almarai',
                    height: 1.7,
                  ),
                ),
                TextSpan(
                  text: 'اتصل بنا - عناوين مكاتبنا',
                  style: TextStyle(
                    color: _orange,
                    fontSize: 13.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────── Policies ───────────────────────────
class _PoliciesSection extends StatelessWidget {
  final bool accepted;
  final ValueChanged<bool> onChanged;
  const _PoliciesSection({required this.accepted, required this.onChanged});

  static const _terms =
      'نص الشروط والسياسات والملحوظات نص الشروط والسياسات والملحوظات نص '
      'الشروط والسياسات والملحوظات نص الشروط والسياسات والملحوظات نص الشروط '
      'والسياسات والملحوظات نص الشروط والسياسات والملحوظات نص الشروط والسياسات '
      'والملحوظات نص الشروط والسياسات والملحوظات نص';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4.w,
              height: 18.h,
              decoration: BoxDecoration(
                color: _orange,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            8.horizontalSpace,
            Text(
              'سياسات الحجز',
              style: TextStyle(
                color: const Color(0xFF2C262C),
                fontSize: 16.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        6.verticalSpace,
        Text(
          'تأكد من قراءة جميع الشروط والسياسات بعناية',
          style: TextStyle(
            color: const Color(0xFF99A2AC),
            fontSize: 12.r,
            fontFamily: 'Almarai',
          ),
        ),
        12.verticalSpace,
        Container(
          width: double.infinity,
          height: 120.h,
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFFEDEDED)),
          ),
          child: SingleChildScrollView(
            child: Text(
              _terms,
              style: TextStyle(
                color: const Color(0xFFB7B7B7),
                fontSize: 12.r,
                fontFamily: 'Almarai',
                height: 1.8,
              ),
            ),
          ),
        ),
        12.verticalSpace,
        InkWell(
          onTap: () => onChanged(!accepted),
          child: Row(
            children: [
              SizedBox(
                width: 22.r,
                height: 22.r,
                child: Checkbox(
                  value: accepted,
                  onChanged: (v) => onChanged(v ?? false),
                  activeColor: _orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ),
              8.horizontalSpace,
              Text(
                'قرأت جميع الشروط والسياسات وأوافق عليها',
                style: TextStyle(
                  color: const Color(0xFF2C262C),
                  fontSize: 13.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
