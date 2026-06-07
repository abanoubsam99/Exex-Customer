import 'package:animate_do/animate_do.dart';
import 'package:evex_user/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

class CustomCheckbox extends StatefulWidget {
  final String? text;
  final Color? color;
  final Color? checkColor;
  final double? iconSize;
  final Function(bool?) onChanged;

  const CustomCheckbox({
    super.key,
    this.text,
    this.color,
    this.checkColor,
    this.iconSize,
    required this.onChanged,
  });

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool isChecked = false;
  late AnimationController animateController;
  bool animate = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // borderRadius: BorderRadius.circular(16.r),
      customBorder: StadiumBorder(),
      onTap: () {
        setState(() {
          isChecked = !isChecked;
          animate = true;
        });
        animateController
          ..reset
          ..reverse(from: 0.05);

        widget.onChanged(isChecked);
      },
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(5.0.r),
            onTap: () {
              setState(() {
                isChecked = !isChecked;
                animate = true;
              });
              animateController
                ..reset
                ..reverse(from: 0.05);

              widget.onChanged.call(isChecked);
            },
            child: HeartBeat(
              animate: animate,
              manualTrigger: true,
              controller: (controller) {
                animateController = controller;

                return animateController;
              },
              child: Container(
                // duration: const Duration(milliseconds: 200),
                width: 20.r,
                height: 20.r,
                decoration: BoxDecoration(
                  color: isChecked ? AppColors.orangeColor : null,
                  border:
                      isChecked
                          ? null
                          : Border.all(width: 1.67.r, color: Color(0xFFD0D5DD)),
                  borderRadius: BorderRadius.circular(5.0.r),
                ),

                child:
                    isChecked
                        ? Icon(
                          Icons.check_rounded,
                          size: 16.r,
                          color: AppColors.whiteColor,
                        )
                        : null,
              ),
            ),
          ),
          if (widget.text != null) ...[
            10.horizontalSpace,
            Text(
              widget.text ?? '',
              style: AppTextStyles.font16GreyRegularHint.copyWith(color: widget.color),
            ),
          ],
        ],
      ),
    );
  }
}
