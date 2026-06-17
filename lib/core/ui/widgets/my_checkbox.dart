import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

class MyCheckbox extends StatefulWidget {
  const MyCheckbox({
    super.key,
    this.width = 24.0,
    this.height = 24.0,
    this.color,
    this.iconSize,
    this.isSelected,
    this.checkColor,
    required this.item,
  });

  final double width;
  final double height;
  final Color? color;
  // Now you can set the checkmark size of your own
  final double? iconSize;
  final Color? checkColor;
  final bool? isSelected;
  final String item;

  @override
  State<MyCheckbox> createState() => _MyCheckboxState();
}

class _MyCheckboxState extends State<MyCheckbox> {
  late bool isChecked;
  late AnimationController animateController;
  bool animate = false;

  @override
  void initState() {
    isChecked = widget.isSelected ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          print("Hhhhhh");
          setState(() {
            isChecked = !isChecked;
            animate = true;
          });
          animateController
            ..reset
            ..reverse(from: 0.05);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
          child: Row(
            children: [
              Text(
                widget.item,
                style: TextStyle(fontSize: 16.sp, color: AppColors.black),
              ),
              8.horizontalSpace,
              Checkbox(value: isChecked, onChanged: (value) {}),
              8.horizontalSpace,
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    isChecked = !isChecked;
                    animate = true;
                  });
                  animateController
                    ..reset
                    ..reverse(from: 0.05);
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
                              : Border.all(
                                width: 1.67.r,
                                color: AppColors.borderGrey2,
                              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
