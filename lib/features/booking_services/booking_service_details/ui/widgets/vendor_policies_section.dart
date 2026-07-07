import 'package:evex_user/data/models/port_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

/// قسم "سياسات التاجر" — بيعرض بيانات GetPortPolicy.
class VendorPoliciesSection extends StatelessWidget {
  final PortPolicy? policy;
  final bool accepted;
  final ValueChanged<bool> onTermsChanged;

  const VendorPoliciesSection({
    super.key,
    required this.policy,
    required this.accepted,
    required this.onTermsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final lastUpdated = policy?.lastUpdatedLabel;
    final otherPolicies = policy?.otherPolicies?.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 6.r,
              height: 18.r,
              decoration: ShapeDecoration(
                color: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ),
            8.horizontalSpace,
            Text(
              'سياسات التاجر',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
                letterSpacing: -0.24,
              ),
            ),
          ],
        ),
        8.verticalSpace,
        Text(
          'جميعها موضوعه من التاجر نفسه , وتخضع لها evex كما هي ..',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 11.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
        if (lastUpdated != null)
          Text(
            'اخر تحديث في $lastUpdated',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 11.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        12.verticalSpace,
        ExpandableContainer(
          height: 427.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── تعديل الحجز في الخدمات والإضافات ──
              _sectionTitle('تكلفة تعديل الحجز  (في الخدمات والإضافات)'),
              8.verticalSpace,
              _periodRow(
                prefix: 'التعديل من الان حتى',
                period: policy?.periodEditingServices,
                suffix: 'ايام قبل تاريخ المناسبة',
                value: _num(policy?.costOfModifyingServicesBeforePeriod),
                unit: 'جنيه',
              ),
              4.verticalSpace,
              _row(
                'التعديل بعد ذلك',
                _num(policy?.costOfModifyingServicesAfterPeriod),
                'جنيه',
              ),
              _divider(),
              // ── تعديل الحجز في تاريخ ومكان المناسبة ──
              _sectionTitle('تكلفة تعديل الحجز  (في تاريخ ومكان المناسبة)'),
              8.verticalSpace,
              _periodRow(
                prefix: 'التعديل من الان حتى',
                period: policy?.periodEditingDateAndLocaltion,
                suffix: 'ايام قبل تاريخ المناسبة',
                value: _num(policy?.costOfModifyingDateAndLocationBeforePeriod),
                unit: 'جنيه',
              ),
              4.verticalSpace,
              _row(
                'التعديل بعد ذلك',
                _num(policy?.costOfModifyingDateAndLocationAfterPeriod),
                'جنيه',
              ),
              _divider(),
              // ── إلغاء الحجز ──
              _sectionTitle('تكلفة إلغاء الحجز'),
              8.verticalSpace,
              _periodRow(
                prefix: 'الإلغاء من الان حتى',
                period: policy?.cancellationPeriod,
                suffix: 'ايام قبل المناسبة',
                value: '${_num(policy?.costOfCancellationBeforePeriod)}%',
                unit: 'من العربون',
              ),
              4.verticalSpace,
              _row(
                'الإلغاء بعد ذلك',
                '${_num(policy?.costOfCancellationAfterPeriod)}%',
                'من العربون',
              ),
              _divider(),
              // ── التأمين ──
              _row(
                'مبلغ التأمين',
                _num(policy?.insuranceAmount),
                'جنيه',
                boldTitle: true,
              ),
              Text(
                'يلتزم التاجر برد مبلغ التأمين كاملاً للعميل من خلال evex\nبعد انتهاء المناسبة في حالة عدم حدوث اي مخالفات من العميل',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 11.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w300,
                  height: 1.82,
                ),
              ),
              _divider(),
              // ── سياسات أخرى ──
              Text(
                'سياسات أخرى',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.blacksoft,
                  fontSize: 12.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  height: 1.50,
                ),
              ),
              Text(
                (otherPolicies != null && otherPolicies.isNotEmpty)
                    ? otherPolicies
                    : 'لا توجد سياسات أخرى',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 11.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w300,
                  height: 1.82,
                ),
              ),
            ],
          ),
        ),
        18.verticalSpace,
        Row(
          children: [
            Transform.scale(
              scale: 1.1,
              child: Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: accepted,
                onChanged: (value) => onTermsChanged(value ?? false),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
                side: BorderSide(
                  color: AppColors.primaryColor.withValues(alpha: 0.6),
                  width: 1.1.r,
                ),
                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.primaryColor;
                  }
                  return Colors.transparent;
                }),
                checkColor: Colors.white,
              ),
            ),
            Text(
              'قرأت جميع الشروط والسياسات وأوافق عليها',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
                height: 1.50,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// عنوان قسم عريض بدون قيمة (مثل "تكلفة تعديل الحجز (في الخدمات والإضافات)").
  Widget _sectionTitle(String text) {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: TextStyle(
        color: AppColors.blacksoft,
        fontSize: 12.r,
        fontFamily: 'Almarai',
        fontWeight: FontWeight.w700,
        height: 1.50,
      ),
    );
  }

  /// صف "عنوان ... قيمة + وحدة". في RTL العنوان على اليمين والقيمة على الشمال.
  Widget _row(String title, String value, String unit, {bool boldTitle = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.right,
            style: TextStyle(
              color:
                  boldTitle ? AppColors.blacksoft : AppColors.grey,
              fontSize: boldTitle ? 12.r : 11.r,
              fontFamily: 'Almarai',
              fontWeight: boldTitle ? FontWeight.w700 : FontWeight.w300,
              height: 1.50,
            ),
          ),
        ),
        8.horizontalSpace,
        _valueUnit(value, unit),
      ],
    );
  }

  /// صف تعديل/إلغاء بعنوان فيه فترة السماح مضمّنة والرقم مميّز باللون البرتقالي
  /// (مثل "التعديل من الان حتى 10 ايام قبل تاريخ المناسبة").
  Widget _periodRow({
    required String prefix,
    required num? period,
    required String suffix,
    required String value,
    required String unit,
  }) {
    final greyStyle = TextStyle(
      color: AppColors.grey,
      fontSize: 11.r,
      fontFamily: 'Almarai',
      fontWeight: FontWeight.w300,
      height: 1.50,
    );
    return Row(
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '$prefix ', style: greyStyle),
                TextSpan(
                  text: _num(period),
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 11.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                  ),
                ),
                TextSpan(text: ' $suffix', style: greyStyle),
              ],
            ),
            textAlign: TextAlign.right,
          ),
        ),
        8.horizontalSpace,
        _valueUnit(value, unit),
      ],
    );
  }

  /// القيمة على الشمال: الرقم برتقالي والوحدة رمادية.
  Widget _valueUnit(String value, String unit) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 12.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          TextSpan(
            text: ' ',
            style: TextStyle(fontSize: 11.r, fontFamily: 'Almarai'),
          ),
          TextSpan(
            text: unit,
            style: TextStyle(
              color: AppColors.unitGrey,
              fontSize: 11.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.r),
      child: Container(
        width: double.infinity,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
            side: BorderSide(
              width: 0.5.r,
              strokeAlign: BorderSide.strokeAlignCenter,
              color: AppColors.boarderFillColor,
            ),
          ),
        ),
      ),
    );
  }

  /// بيعرض الرقم من غير الكسر الزايد (10.0 → "10")، و null → "0".
  String _num(num? value) {
    if (value == null) return '0';
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toString();
  }
}

class ExpandableContainer extends StatefulWidget {
  final double? height;
  final Widget child;

  const ExpandableContainer({super.key, required this.child, this.height});

  @override
  State<ExpandableContainer> createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: AppColors.boarderColor),
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  isExpanded ? double.infinity : widget.height ?? double.infinity,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 12.r),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: isExpanded
                        ? const ClampingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    child: widget.child,
                  ),
                  if (!isExpanded)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 29.r,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0.0),
                              Colors.white,
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
