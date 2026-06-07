import 'package:evex_user/core/ui/widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VendorPoliciesSection extends StatelessWidget {
  const VendorPoliciesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 6.r,
              height: 18.r,
              decoration: ShapeDecoration(
                color: const Color(0xFFF38B4A),
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
          'جميعها مطروحه ومشروطه من قبل مقدم الخدمة أو التاجر نفسه',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: const Color(0xFF6F767E),
            fontSize: 11.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
        Text(
          'اخر تحديث في 11/11/2025',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: const Color(0xFF6F767E),
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
              Row(
                children: [
                  Text(
                    'فترة السماح بالتعديل في الخدمات',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color(0xFF2C262C),
                      fontSize: 12.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                      height: 1.50,
                    ),
                  ),
                  Spacer(),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '0',
                          style: TextStyle(
                            color: const Color(0xFFF38B4A),
                            fontSize: 12.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: const Color(0xFF6F767E),
                            fontSize: 12.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: 'يوم قبل المناسبة',
                          style: TextStyle(
                            color: const Color(0xFFA5B7C6),
                            fontSize: 11.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              4.verticalSpace,
              Row(
                children: [
                  Text(
                    'تكلفة التعديل في فترة السماح / لكل مرة',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color(0xFF6F767E),
                      fontSize: 11.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w300,
                      height: 1.50,
                    ),
                  ),
                  Spacer(),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '0',
                          style: TextStyle(
                            color: const Color(0xFFF38B4A),
                            fontSize: 12.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: const Color(0xFF6F767E),
                            fontSize: 11.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: 'جنيه',
                          style: TextStyle(
                            color: const Color(0xFFA5B7C6),
                            fontSize: 11.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              4.verticalSpace,
              Row(
                children: [
                  Text(
                    'تكلفة التعديل بعد فترة السماح / لكل مرة',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color(0xFF6F767E),
                      fontSize: 11.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w300,
                      height: 1.50,
                    ),
                  ),
                  Spacer(),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '0',
                          style: TextStyle(
                            color: const Color(0xFFF38B4A),
                            fontSize: 12.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: const Color(0xFF6F767E),
                            fontSize: 11.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: 'جنيه',
                          style: TextStyle(
                            color: const Color(0xFFA5B7C6),
                            fontSize: 11.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              8.verticalSpace,
              Container(
                width: double.infinity,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    side: BorderSide(
                      width: 0.5.r,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: const Color(0xFFF4F4F4),
                    ),
                  ),
                ),
              ),
              8.verticalSpace,
              Row(
                children: [
                  Text(
                    'فترة السماح بالتعديل في التاريخ والمكان',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color(0xFF2C262C),
                      fontSize: 12.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                      height: 1.50,
                    ),
                  ),
                  Spacer(),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '0',
                          style: TextStyle(
                            color: const Color(0xFFF38B4A),
                            fontSize: 12.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: const Color(0xFF6F767E),
                            fontSize: 12.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: 'يوم قبل المناسبة',
                          style: TextStyle(
                            color: const Color(0xFFA5B7C6),
                            fontSize: 11.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              4.verticalSpace,
              Row(
                children: [
                  Text(
                    'تكلفة التعديل في فترة السماح / لكل مرة',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color(0xFF6F767E),
                      fontSize: 11.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w300,
                      height: 1.50,
                    ),
                  ),
                  Spacer(),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '0',
                          style: TextStyle(
                            color: const Color(0xFFF38B4A),
                            fontSize: 12.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: const Color(0xFF6F767E),
                            fontSize: 11.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: 'جنيه',
                          style: TextStyle(
                            color: const Color(0xFFA5B7C6),
                            fontSize: 11.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              4.verticalSpace,
              Row(
                children: [
                  Text(
                    'تكلفة التعديل بعد فترة السماح / لكل مرة',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color(0xFF6F767E),
                      fontSize: 11.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w300,
                      height: 1.50,
                    ),
                  ),
                  Spacer(),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '0',
                          style: TextStyle(
                            color: const Color(0xFFF38B4A),
                            fontSize: 12.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: const Color(0xFF6F767E),
                            fontSize: 11.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: 'جنيه',
                          style: TextStyle(
                            color: const Color(0xFFA5B7C6),
                            fontSize: 11.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              8.verticalSpace,
              Container(
                width: double.infinity,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    side: BorderSide(
                      width: 0.5.r,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: const Color(0xFFF4F4F4),
                    ),
                  ),
                ),
              ),
              8.verticalSpace,
              Row(
                children: [
                  Text(
                    'فترة السماح بإلغاء الحجز',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color(0xFF2C262C),
                      fontSize: 12.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                      height: 1.50,
                    ),
                  ),
                  Spacer(),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '0',
                          style: TextStyle(
                            color: const Color(0xFFF38B4A),
                            fontSize: 12.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: const Color(0xFF6F767E),
                            fontSize: 12.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: 'يوم قبل المناسبة',
                          style: TextStyle(
                            color: const Color(0xFFA5B7C6),
                            fontSize: 11.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              4.verticalSpace,
              Row(
                children: [
                  Text(
                    'تكلفة الإلغاء في فترة السماح',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color(0xFF6F767E),
                      fontSize: 11.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w300,
                      height: 1.50,
                    ),
                  ),
                  Spacer(),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '0%',
                          style: TextStyle(
                            color: const Color(0xFFF38B4A),
                            fontSize: 12.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: const Color(0xFF6F767E),
                            fontSize: 11.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: 'من مقدم الحجز',
                          style: TextStyle(
                            color: const Color(0xFFA5B7C6),
                            fontSize: 11.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              4.verticalSpace,
              Row(
                children: [
                  Text(
                    'تكلفة الإلغاء بعد فترة السماح',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color(0xFF6F767E),
                      fontSize: 11.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w300,
                      height: 1.50,
                    ),
                  ),
                  Spacer(),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '0%',
                          style: TextStyle(
                            color: const Color(0xFFF38B4A),
                            fontSize: 12.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: const Color(0xFF6F767E),
                            fontSize: 11.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: 'من مقدم الحجز',
                          style: TextStyle(
                            color: const Color(0xFFA5B7C6),
                            fontSize: 11.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              8.verticalSpace,
              Container(
                width: double.infinity,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    side: BorderSide(
                      width: 0.5.r,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: const Color(0xFFF4F4F4),
                    ),
                  ),
                ),
              ),
              8.verticalSpace,
              Row(
                children: [
                  Text(
                    'مبلغ التأمين',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color(0xFF2C262C),
                      fontSize: 12.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                      height: 1.50,
                    ),
                  ),
                  Spacer(),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '0',
                          style: TextStyle(
                            color: const Color(0xFFF38B4A),
                            fontSize: 12.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: const Color(0xFF6F767E),
                            fontSize: 12.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: 'جنيه',
                          style: TextStyle(
                            color: const Color(0xFFA5B7C6),
                            fontSize: 11.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                'يلتزم التاجر برد مبلغ التأمين كاملاً للعميل\nبعد انتهاء المناسبة في حالة عدم حدوث اي مخالفات من قبل العميل',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: const Color(0xFF6F767E),
                  fontSize: 11.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w300,
                  height: 1.82,
                ),
              ),
              8.verticalSpace,
              Container(
                width: double.infinity,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    side: BorderSide(
                      width: 0.5.r,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: const Color(0xFFF4F4F4),
                    ),
                  ),
                ),
              ),
              8.verticalSpace,
              Text(
                'سياسات أخرى',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: const Color(0xFF2C262C),
                  fontSize: 12.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  height: 1.50,
                ),
              ),
              Text(
                'نص الشروط والسياسات والملحوظات نص الشروط والسياسات والملحوظات نص الشروط والسياسات والملحوظات نص الشروط والسياسات والملحوظات نص الشروط والسياسات والملحوظ',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: const Color(0xFF6F767E),
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
            Builder(
              builder: (context) {
                bool isChecked = false;
                return StatefulBuilder(
                  builder: (context, setState) {
                    return Transform.scale(
                      scale: 1.1,
                      child: Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: isChecked, // your boolean variable
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value ?? false;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),

                        side: BorderSide(
                          color: Color(0xFFF38B4A).withValues(alpha: 0.6),
                          width: 1.1.r,
                        ),

                        fillColor: WidgetStateProperty.resolveWith<Color>((
                          states,
                        ) {
                          if (states.contains(WidgetState.selected)) {
                            return Color(0xFFF38B4A);
                          }
                          return Colors.transparent;
                        }),
                        checkColor: Colors.white,
                      ),
                    );
                  },
                );
              },
            ),
            // 6.horizontalSpace,
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
            side: BorderSide(width: 1, color: const Color(0xFFF2F4F7)),
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          // curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  isExpanded
                      ? double.infinity
                      : widget.height ?? double.infinity,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 12.r),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics:
                        isExpanded
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
                          // borderRadius: BorderRadius.only(
                          //   bottomLeft: Radius.circular(16.r),
                          //   bottomRight: Radius.circular(16.r),
                          // ),
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
