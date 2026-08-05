import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/looping_marquee_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdditionItem extends StatefulWidget {
  final String title;
  final String price;
  final bool isSelected;
  final VoidCallback onChanged;

  /// When false the price ("... LE") is hidden — the port keeps its prices
  /// private (port-level displayPrice).
  final bool showPrice;

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
    this.showPrice = true,
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

  @override
  void didUpdateWidget(covariant AdditionItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync the displayed count when the parent supplies a new initialCount
    // (e.g. edit-mode autofill), but never while the user is editing the field.
    if (widget.hasCount &&
        widget.initialCount != oldWidget.initialCount &&
        !(_focusNode?.hasFocus ?? false)) {
      final next = widget.initialCount ?? 0;
      if (next != count) {
        count = next;
        countController?.text = count.toString();
      }
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
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            children: [
              // ── Name (right side) ──
              // Fixed font size (no FittedBox scale-down) so every row reads at
              // the same size instead of short names looking huge and long names
              // shrinking to nothing. Long names scroll in a loop so they stay
              // readable — static when they fit.
              Flexible(
                flex: 5,
                // Every row wraps its name in the same pill so gift and
                // non-gift rows share one layout. Gift rows use the peach fill
                // + gift icon; plain rows use a neutral grey fill and no icon.
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 6.h,
                    horizontal: 12.w,
                  ),
                  decoration: ShapeDecoration(
                    color: hasGift ? AppColors.lightPeach : AppColors.fillGrey3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (hasGift) ...[
                        CustomImageHandler(AppImages.imagesGift),
                        4.horizontalSpace,
                      ],
                      Expanded(
                        child: LoopingMarqueeText(
                          hasGift && widget.hasCount
                              ? "${widget.giftCount} ${widget.title}"
                              : widget.title,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: hasGift
                                ? AppColors.secondaryColor
                                : AppColors.blacksoft,
                            fontSize: 10.sp,
                            fontFamily: 'Almarai',
                            fontWeight:
                                hasGift ? FontWeight.w600 : FontWeight.w700,
                            letterSpacing: hasGift ? null : -0.24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ── Count stepper (middle) ──
              // Always sits between the name (right) and the price (left),
              // centered in the free space so it reads as the middle control.
              if (widget.hasCount)
                Flexible(
                  flex: 4,
                  child: Center(child: _buildCountControls()),
                )
              else
                const Spacer(flex: 4),
              // ── Price (far left) ──
              // Pinned to the far left on every row, even when a count stepper
              // is present. Hidden when the port keeps its prices private.
              if (widget.showPrice) ...[
                6.horizontalSpace,
                Row(
                  mainAxisSize: MainAxisSize.min,
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
