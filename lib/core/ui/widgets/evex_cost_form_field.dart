import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pattern_formatter/numeric_formatter.dart';

import '../../theme/app_colors.dart';

class EvexCostFormField extends StatefulWidget {
  final String title;
  final TextEditingController textEditingController;
  const EvexCostFormField({
    super.key,
    required this.title,
    required this.textEditingController,
  });

  @override
  State<EvexCostFormField> createState() => _EvexCostFormFieldState();
}

class _EvexCostFormFieldState extends State<EvexCostFormField> {
  late FocusNode _myFocusNode;
  final ValueNotifier<bool> _myFocusNotifier = ValueNotifier<bool>(false);
  bool isError = false;

  @override
  void initState() {
    super.initState();

    _myFocusNode = FocusNode();
    _myFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _myFocusNode.removeListener(_onFocusChange);
    _myFocusNode.dispose();
    _myFocusNotifier.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    _myFocusNotifier.value = _myFocusNode.hasFocus;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontFamily: "din",
            fontSize: 16.sp,
            color: Color(0xFF121212),
          ),
        ),
        4.r.verticalSpace,
        ValueListenableBuilder(
          valueListenable: _myFocusNotifier,
          builder: (_, isFocus, child) {
            return TextFormField(
              controller: widget.textEditingController,
              maxLength: 21,

              onTap: () {
                if (widget.textEditingController.selection ==
                    TextSelection.fromPosition(TextPosition(offset: 0))) {
                  setState(() {
                    widget
                        .textEditingController
                        .selection = TextSelection.fromPosition(
                      TextPosition(
                        offset: widget.textEditingController.text.length,
                      ),
                    );
                  });
                }
              },
              focusNode: _myFocusNode,
              textAlign: TextAlign.start,
              textDirection: TextDirection.rtl,
              keyboardType: TextInputType.number,
              inputFormatters: [ThousandsFormatter()],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: Color(0xFF121212),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  isError = true;
                  return "يجب ادخال السعر";
                }
                isError = false;

                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                counterText: '',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                filled: true,
                fillColor:
                    isError
                        ? AppColors.backgroundColor
                        : isFocus
                        ? AppColors.backgroundColor
                        : AppColors.boarderFillColor,
                // fillColor: Color(0xFFF4F4F4),
                errorStyle: TextStyle(fontSize: 12.sp),

                suffixText: "جنيه مصري",
                suffixStyle: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6F767E),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.orangeColor),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
