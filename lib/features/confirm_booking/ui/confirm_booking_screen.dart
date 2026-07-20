import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/text_field_builder_widget.dart';
import 'package:evex_user/data/cubits/confirm_booking/confirm_booking_cubit.dart';
import 'package:evex_user/data/cubits/confirm_booking/confirm_booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

const _orange = AppColors.primaryColor;

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
                              AppColors.lightOrange3,
                              AppColors.peachBg3,
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
                                  '${state.depositAmount} جنيه',
                                  textDirection: TextDirection.ltr,
                                  // maxLines: 1,
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
                                if (state.isLoadingNetCost ||
                                    state.netCostTotal > 0) ...[
                                  10.verticalSpace,
                                  _netCostPill(state),
                                ],
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
              // Cash needs no online payment, so the button only shows for card.
              if (state.selectedMethod == BookingPaymentMethod.card)
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blackAlpha14,
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
                        onTap: () async {
                          final result = await cubit.confirmCardPayment();
                          if (result != null) {
                            NavigationHelper.pushNamed(
                              Routes.paymentWebViewScreen,
                              arguments: result,
                            );
                          }
                        },
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
        InkWell( onTap: () => NavigationHelper.pop(),
    child: Container(
    width: 40.r,
    height: 40.r,
    alignment: Alignment.center,
    decoration: BoxDecoration(
    border: Border.all(color: Colors.black, width: 1.4),
    borderRadius: BorderRadius.circular(10.r),
    ),
    child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 16.r),
    ),
    ),
        SizedBox(width: 10,),
        // const Spacer(),
        Text(
          'تأكيد الحجز',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w800,
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

  /// إجمالي تكلفة الخدمات من CalculateNetCost (تحت المقدم).
  Widget _netCostPill(ConfirmBookingState state) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'إجمالي الخدمات',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w400,
            ),
          ),
          8.horizontalSpace,
          if (state.isLoadingNetCost)
            SizedBox(
              width: 14.r,
              height: 14.r,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          else
            Text(
              '${state.netCostTotal} جنيه',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w800,
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
        // Hidden per request — card fields. Restore by uncommenting:
        // return _CardForm(cubit: cubit);
        return const SizedBox.shrink();
      case BookingPaymentMethod.evex:
        return _WalletBox(
          balance: state.walletBalance,
          onRecharge: cubit.rechargeWallet,
        );
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
          BoxShadow(color: AppColors.blackAlpha12, blurRadius: 16, offset: Offset(0, 6)),
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
          // _divider(),
          // _row(
          //   method: BookingPaymentMethod.evex,
          //   label: 'محفظة evex',
          //   logos: Image.asset(AppImages.imagesNewLogo, height: 20.r),
          // ),
          // _divider(),
          // _row(
          //   method: BookingPaymentMethod.cash,
          //   label: 'الدفع نقداً',
          //   logos: Image.asset(AppImages.imagesDollars, height: 20.r),
          // ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(color: AppColors.fillGrey1, height: 1.h);

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
                color: AppColors.blacksoft,
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
              color: isSelected ? _orange : AppColors.grey4,
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
          color: selected ? _orange : AppColors.grey8,
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

// ─────────────────────────── Card form (hidden per request) ───────────────────────────
// Kept for when the payment gateway is wired. Currently not rendered
// (see _expansionContent: the card case returns SizedBox.shrink()).
// ignore: unused_element
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
                  color: AppColors.blacksoft,
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
                  color: AppColors.blue4,
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
                        color: AppColors.grey,
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
        // Hidden per request — wallet top-up button. Restore by uncommenting:
        // 14.verticalSpace,
        // CustomButton(
        //   text: 'شحن المحفظة',
        //   isfilled: false,
        //   backgroundColor: Colors.transparent,
        //   bordereColor: _orange,
        //   fontColor: _orange,
        //   height: 48.h,
        //   width: double.infinity,
        //   onTap: onRecharge,
        // ),
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
                    color: AppColors.grey,
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

  static const _terms = '''
أولاً : تأكيد الحجز و سياسة الدفع
1- يتم تأكيد الحجز فقط بعد دفعي لمقدم الحجز من خلال  تطبيق evex , ولايحق لي إلغاء الحجز أو استرداد المقدم إلا وفقاً لسياسات وشروط التاجر التي وافقت عليها مسبقاً .
 2- تلتزم شركة evex بتطبيق سياسات التاجر في الحجز , التي قرأتها ووافقت عليها مسبقاً , ولا دخل لها في وضع تلك السياسات ,  بل فقط تُعلِن حقي كعميل وحق التاجر وفقاً لتلك السياسات . 
3- ألتزم بسداد باقي مبلغ الحجز المتبقي إلى شركة evex وليس إلى التاجر مباشرة , وذلك قبل ميعاد المناسبة بمدة لاتقل عن 20 يوم وفي حالة التأخير , يحق ل evex إلغاء الخصومات التي حصلت عليها أو إلغاء الحجز بالكامل إن زاد التأخير , ولايحق لي المطالبه بأي مستحقات نهائياً.  4- ألتزم بدفع جميع المبالغ المالية للحجز من خلال evex فقط , ولايعتد بأي مبالغ يتم دفعها مباشرة لأي تاجر .. بإستثناء قسم الخدمات المباشرة فقط .  ثانياً : إلغاء الحجز ورد المقدّم 5- في حالة الإلغاء من قِبل التاجر و عدم إمكانية التاجر تنفيذ الخدمة المحجوزه لأي سبب , يلتزم التاجر برد مقدم الحجز بالكامل لي , ورد أي مبالغ أو دفعات أخرى مدفوعه من قيمة الحجز من خلال evex , وأيضاً تعمل evex على مساعدة العميل في إيجاد حل بديل وفقاً للمتاح ,   6-في حالة حدوث إلغاء من قِبل التاجر في يوم المناسبة ذاته , ووجود ضرر لي ناتج عن عدم تنفيذ الخدمة , يتم اتخاذ الإجراءات اللازمة ضد التاجر بعد مراجعة الحالة  وثبوت التقصير (مثل إيقاف حسابه وخصم مستحقاته وإلزامه بدفع غرامات وجزاءات محدده ) وذلك طبقاً لإتفاقية وسياسة evex مع التجار.  7- يتم رد المبالغ المستحقه لي في حالة إلغائي للحجز (إن وجدت) وفقاً لسياسات التاجر , من خلال evex , وذلك في خلال  من 15 الي 30 يوم عمل من تاريخ الإلغاء . 
8- يتم رد مبلغ التأمين لي ( إن وجد) طبقاً لسياسات التاجر , من خلال evex , في مدة من 15 الى 30 يوم عمل من تاريخ المناسبة المحجوزه , وذلك بالقيمة المحدده من التاجر بحسب سياساته وبحسب نسبة الأضرار أو المخالفات الناتجه .  9- يحق لـ evex تعليق أو إلغاء أي حجز في حالة وجود استخدام مخالف أو احتيالي أو أي انتهاك لشروط الاستخدام , ولا يحق لي المطالبه بأي مستحقات . 
ثالثاً : الإلتزام بمواعيد الحجز
10- ألتزم بمواعيد الحجز التي تم تأكيدها وأتحمل مسئولية غير ذلك , وفي حالة تغيبي عن حضور المناسبة , لايحق لي المطالبه بأي مستحقات قمت بدفعها من قبل .  11- تضمن evex تاريخ المناسبة لي كعميل وللتاجر , ولكن في حالة حجزي لخدمة على تطبيق evex لا تتوافر بها معلومات كافية عن توقيت الخدمة المقدمه من التاجر “بساعات محدده” , يتم الإتفاق على ذلك خارج التطبيق بعد إتمام تأكيد حجز اليوم ودفع المقدم , ولا مسئولية ل evex عن تأخيري أو تأخير التاجر عن الحضور  في هذا التوقيت .  رابعاً : مشاركة البيانات 12- جميع البيانات التي أدخلتها صحيحة وتشمل بياناتي الشخصية وبيانات وتفاصيل المناسبة المطلوبة , وأتحمل مسئولية غير ذلك.  13- أوافق على مشاركة بياناتي وبيانات الحجز اللازمه مع التاجر  ومع شركة evex , وذلك لإتمام الخدمة والتواصل بشأنها .  خامساً : دور evex 14- تعمل evex كمنصة لحجز المناسبات وربط العملاء بالتجار ومقدمي الخدمات , وإدارة عمليات الدفع والتحصيل وفقاً للنظام المتبع دخل التطبيق ووفقاً لسياسات وشروط التاجر في الحجز .  15- تضمن evex ثبات أسعار الخدمات التي قمت بحجزها بعد دفعي لمقدم الحجز لحين إتمام المناسبة , فيما عدا قيامي بتعديل الحجز  قبل ميعاد المناسبة لأي سبب , حينها يتم تغيير أسعار خدماتي المحجوزه بالأسعار الجديدة الموضوعه من قِبل التاجر .  16- لا تتحمل evex مسئولية جودة أو تفاصيل الخدمات التي قمت بإختيارها , وأنا كعميل مسئول مسئولية كاملة عن اختياري للتاجر . وأيضاً لا علاقة ل evex بتسليم أعمال المناسبة لي , من فيديوهات وصور وغيرها أو مواعيد تسليمها , وهذه كلها مسئولية التاجر .  17- evex غير مسئولة تماماً عن أي إتفاقات خارجية بيني وبين التاجر تحت أي مسمى ولأي سبب , ولايعتد إلا بتفاصيل الحجز المحدده والمتفق عليها في تطبيق evex فقط.  18- بإستخدامي لتطبيق evex  وإتمام الحجز , فأنني أقر بأنني قرأت هذه الشروط والأحكام وأوافق عليها بالكامل .
  
  ''';
      // 'نص الشروط والسياسات والملحوظات نص الشروط والسياسات والملحوظات نص '
      // 'الشروط والسياسات والملحوظات نص الشروط والسياسات والملحوظات نص الشروط '
      // 'والسياسات والملحوظات نص الشروط والسياسات والملحوظات نص الشروط والسياسات '
      // 'والسياسات والملحوظات نص الشروط والسياسات والملحوظات نص الشروط والسياسات '
      // 'والملحوظات نص الشروط والسياسات والملحوظات نص';

  /// Acknowledgment line above the policies, naming the signed-in client's
  /// phone (dynamic from the profile) so the terms are tied to their account.
  Widget _acknowledgment(BuildContext context) {
    final user = context.read<UserService>().currentUser?.userViewModel;
    final phone = user?.phoneNumber?.trim() ?? '';
    // Stored country code may or may not carry a leading '+'; normalize so it
    // always shows as "(+20)".
    final code = user?.countryCode?.replaceAll('+', '').trim() ?? '';
    if (phone.isEmpty) return const SizedBox.shrink();
    // The phone + country code is wrapped in an LTR isolate (U+2066 .. U+2069)
    // so it reads "01284623066 (+20)" inside the surrounding RTL sentence.
    final lri = String.fromCharCode(0x2066);
    final pdi = String.fromCharCode(0x2069);
    final phonePart =
        '$lri$phone${code.isNotEmpty ? ' ' : ''}$pdi';
        // '$lri$phone${code.isNotEmpty ? ' (+$code)' : ''}$pdi';
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Text.rich(
        TextSpan(
          style: TextStyle(
            color: AppColors.blacksoft,
            fontSize: 13.r, 
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w600,
            height: 1.6,
          ),
          children: [
            const TextSpan(text: 'أقر أنا العميل المُسَجَّل برقم هاتف '),
            TextSpan(
              text: phonePart,
              style: const TextStyle(
                color: _orange,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
    );
  }

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
                color: AppColors.blacksoft,
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
            color: AppColors.blueGrey,
            fontSize: 12.r,
            fontFamily: 'Almarai',
          ),
        ),
        // 6.verticalSpace,
        6.verticalSpace,
        Container(
          width: double.infinity,
          height: 330.h,
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.lineGrey),
          ),
          child: Column(
            children: [
              _acknowledgment(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _terms,
                    style: TextStyle(
                        color: AppColors.descriptionText,
                        fontSize: 12.r,
                        fontFamily: 'Almarai',
                        height: 1.8,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Container(
        //   // No fixed height / inner scroll — the box grows to fit the full
        //   // terms text so the whole page scrolls as one instead.
        //   width: double.infinity,
        //   padding: EdgeInsets.all(14.r),
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.circular(14.r),
        //     border: Border.all(color: AppColors.lineGrey),
        //   ),
        //   child: Text(
        //     _terms,
        //     style: TextStyle(
        //       color: AppColors.descriptionText,
        //       fontSize: 12.r,
        //       fontFamily: 'Almarai',
        //       height: 1.8,
        //       fontWeight: FontWeight.w400,
        //     ),
        //   ),
        // ),
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
                  color: AppColors.blacksoft,
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
