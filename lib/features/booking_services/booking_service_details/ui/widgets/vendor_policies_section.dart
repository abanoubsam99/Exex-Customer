import 'package:evex_user/data/models/port_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

/// قسم "سياسات التاجر" — بيعرض بيانات GetPortPolicy.
/// The visual styling here mirrors the vendor app's `PortPolicyView` so both
/// apps render the merchant policies identically (same sizes, weights, colors).
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

  /// Muted grey used for the unit suffix and the "last updated" line.
  static const Color _grey = Color(0xffA2A9B0);

  /// Hairline between policy sections.
  static const Color _dividerColor = Color(0xffE8EDF1);

  /// Policy body text — darker than [_grey] so it reads clearly like Figma.
  static const Color _policyText = Color(0xff5A6673);

  /// Card outline.
  static const Color cardBorder = Color(0xffE6EAEE);

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
              width: 6.w,
              height: 22.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            8.horizontalSpace,
            Text(
              'سياسات التاجر',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        8.verticalSpace,
        Text(
          'جميعها موضوعه من التاجر نفسه , وتخضع لها evex كما هي ..',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: _policyText,
            fontSize: 12.sp,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
        if (lastUpdated != null) ...[
          4.verticalSpace,
          Text(
            'اخر تحديث في $lastUpdated',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: _grey,
              fontSize: 12.sp,
              fontFamily: 'Almarai',
            ),
          ),
        ],
        16.verticalSpace,
        ExpandableContainer(
          height: 470.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── تعديل الحجز في الخدمات والإضافات ──
              _sectionTitle('تكلفة تعديل الحجز  (في الخدمات والإضافات)'),
              12.verticalSpace,
              _periodRow(
                prefix: 'التعديل من الان حتى ',
                period: policy?.periodEditingServices,
                suffix: ' ايام قبل تاريخ المناسبة',
                value: _num(policy?.costOfModifyingServicesBeforePeriod),
                unit: 'جنيه',
              ),
              10.verticalSpace,
              _row(
                'التعديل بعد ذلك',
                _num(policy?.costOfModifyingServicesAfterPeriod),
                'جنيه',
              ),
              _divider(),
              // ── تعديل الحجز في تاريخ ومكان المناسبة ──
              _sectionTitle('تكلفة تعديل الحجز  (في تاريخ ومكان المناسبة)'),
              12.verticalSpace,
              _periodRow(
                prefix: 'التعديل من الان حتى ',
                period: policy?.periodEditingDateAndLocaltion,
                suffix: ' ايام قبل تاريخ المناسبة',
                value: _num(policy?.costOfModifyingDateAndLocationBeforePeriod),
                unit: 'جنيه',
              ),
              10.verticalSpace,
              _row(
                'التعديل بعد ذلك',
                _num(policy?.costOfModifyingDateAndLocationAfterPeriod),
                'جنيه',
              ),
              _divider(),
              // ── إلغاء الحجز ──
              _sectionTitle('تكلفة إلغاء الحجز'),
              12.verticalSpace,
              _periodRow(
                prefix: 'الإلغاء من الان حتى ',
                period: policy?.cancellationPeriod,
                suffix: ' ايام قبل المناسبة',
                value: '${_num(policy?.costOfCancellationBeforePeriod)}%',
                unit: 'من العربون',
              ),
              10.verticalSpace,
              _row(
                'الإلغاء بعد ذلك',
                '${_num(policy?.costOfCancellationAfterPeriod)}%',
                'من العربون',
              ),
              _divider(),
              // ── التأمين ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: _sectionTitle('مبلغ التأمين')),
                  8.horizontalSpace,
                  _valueUnit(_num(policy?.insuranceAmount), 'جنيه'),
                ],
              ),
              8.verticalSpace,
              _plainLabel(
                'يلتزم التاجر برد مبلغ التأمين كاملًا للعميل من خلال evex بعد انتهاء المناسبة في حالة عدم حدوث اي مخالفات من العميل',
              ),
              _divider(),
              // ── سياسات أخرى ──
              _sectionTitle('سياسات أخرى'),
              8.verticalSpace,
              _plainLabel(
                (otherPolicies != null && otherPolicies.isNotEmpty)
                    ? otherPolicies
                    : 'لا توجد سياسات إضافية',
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
        color: Colors.black,
        fontSize: 14.sp,
        fontFamily: 'Almarai',
        fontWeight: FontWeight.w700,
        height: 1.4,
      ),
    );
  }

  /// نص السياسة العادي (الوصف / السياسات الأخرى).
  Widget _plainLabel(String text) {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: TextStyle(
        color: _policyText,
        fontSize: 12.sp,
        fontFamily: 'Almarai',
        fontWeight: FontWeight.w500,
        height: 1.6,
      ),
    );
  }

  /// صف "عنوان ... قيمة + وحدة". في RTL العنوان على اليمين والقيمة على الشمال.
  Widget _row(String title, String value, String unit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _plainLabel(title)),
        10.horizontalSpace,
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
    final labelStyle = TextStyle(
      color: _policyText,
      fontSize: 12.sp,
      fontFamily: 'Almarai',
      fontWeight: FontWeight.w500,
      height: 1.6,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              style: labelStyle,
              children: [
                TextSpan(text: prefix),
                TextSpan(
                  text: _num(period),
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: suffix),
              ],
            ),
            textAlign: TextAlign.right,
          ),
        ),
        10.horizontalSpace,
        _valueUnit(value, unit),
      ],
    );
  }

  /// القيمة على الشمال: الرقم برتقالي والوحدة رمادية.
  Widget _valueUnit(String value, String unit) {
    return Text.rich(
      TextSpan(
        style: TextStyle(fontFamily: 'Almarai', fontSize: 12.sp),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: ' $unit',
            style: const TextStyle(color: _grey),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: const Divider(height: 1, color: _dividerColor),
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
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: VendorPoliciesSection.cardBorder),
          borderRadius: BorderRadius.circular(18),
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
              padding: EdgeInsets.all(14.r),
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
                              Colors.white.withValues(alpha: 0.0),
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
