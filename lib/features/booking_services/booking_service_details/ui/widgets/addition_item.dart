import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdditionItem extends StatefulWidget {
  final String title;
  final String price;
  final bool isSelected;
  final VoidCallback onChanged;

  // Count-related properties (optional)
  final bool hasCount;
  final int? initialCount;
  final int? giftCount;
  final Function(int)? onChangeCount;

  const AdditionItem({
    super.key,
    required this.title,
    required this.price,
    required this.isSelected,
    required this.onChanged,
    this.hasCount = false,
    this.initialCount,
    this.giftCount,
    this.onChangeCount,
  }) : assert(
         !hasCount || onChangeCount != null,
         'onChangeCount must be provided when hasCount is true',
       );

  @override
  State<AdditionItem> createState() => _AdditionItemState();
}

class _AdditionItemState extends State<AdditionItem> {
  late int count;
  TextEditingController? countController;
  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();
    if (widget.hasCount) {
      count = widget.initialCount ?? 1;
      countController = TextEditingController(text: count.toString());
      _focusNode = FocusNode();
      _focusNode!.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    if (_focusNode != null && !_focusNode!.hasFocus) {
      _validateCount();
    }
  }

  void _validateCount() {
    final value = int.tryParse(countController?.text ?? '0');
    if (value == null || value < 1) {
      countController?.text = '0';
    }
  }

  void _updateCount(int newCount) {
    setState(() {
      count = newCount;
      countController?.text = count.toString();
    });
    widget.onChangeCount?.call(count);
  }

  @override
  void dispose() {
    countController?.dispose();
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasGift = widget.giftCount != null;
    final isActive =
        widget.isSelected && (!widget.hasCount || count > 0) || hasGift;

    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: 1.sw,
        height: 46.h,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isActive ? AppColors.primaryAlpha99 : AppColors.boarderColor,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            children: [
              Text(
                widget.title,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.blacksoft,
                  fontSize: 13.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.24,
                ),
              ),
              if (hasGift) ...[
                12.horizontalSpace,
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 4.h,
                    horizontal: 10.w,
                  ),
                  decoration: ShapeDecoration(
                    color: AppColors.lightPeach,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomImageHandler(AppImages.imagesGift),
                        4.horizontalSpace,
                        Text(
                          widget.hasCount
                              ? "${widget.giftCount} ${widget.title}"
                              : widget.title,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const Spacer(),
              Row(
                children: [
                  Text(
                    'LE',
                    style: TextStyle(
                      color: AppColors.unitGrey,
                      fontSize: 12.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.24,
                    ),
                  ),
                  3.horizontalSpace,
                  Text(
                    widget.price,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.24,
                    ),
                  ),
                ],
              ),
              if (widget.hasCount) ...[
                8.horizontalSpace,
                _buildCountControls(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    if (widget.giftCount != null) return;

    if (widget.hasCount) {
      if (count == 0)
        _updateCount(1);
      else if (widget.isSelected && count > 0)
        _updateCount(0);
    } else {
      widget.onChanged();
    }

    // if (widget.hasCount) {
    //   widget.onChanged();
    //   if (!widget.isSelected && count == 0) {
    //     _updateCount(1);
    //   } else {
    //     _updateCount(0);
    //   }
    // } else {
    //   widget.onChanged();
    // }
  }

  Widget _buildCountControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => _updateCount(count + 1),
          onLongPress: () => _updateCount(count + 5),
          child: Container(
            height: 28.r,
            width: 28.r,
            decoration: const ShapeDecoration(
              shape: CircleBorder(side: BorderSide(color: AppColors.boarderColor)),
              color: AppColors.primaryColor,
            ),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
        SizedBox(
          width: 32.w,
          child: TextFormField(
            controller: countController,
            focusNode: _focusNode,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: AppColors.blacksoft,
              fontSize: 13.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w700,
            ),
            onChanged: (value) {
              _updateCount(int.parse(value.isEmpty ? "0" : value));
              countController!.selection = TextSelection.fromPosition(
                TextPosition(offset: countController!.text.length),
              );
            },
            onTap: () {
              if (countController!.selection ==
                  TextSelection.fromPosition(TextPosition(offset: 0))) {
                setState(() {
                  countController!.selection = TextSelection.fromPosition(
                    TextPosition(offset: countController!.text.length),
                  );
                });
              }
            },
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (count >= 1) _updateCount(count - 1);
          },
          onLongPress: () {
            if (count >= 5) {
              _updateCount(count - 5);
            } else if (count >= 1) {
              _updateCount(count - 1);
            }
          },
          child: Container(
            height: 28.r,
            width: 28.r,
            decoration: const ShapeDecoration(
              shape: CircleBorder(side: BorderSide(color: AppColors.boarderColor)),
              color: Colors.white,
            ),
            child: const Icon(Icons.remove),
          ),
        ),
      ],
    );
  }
}
