import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/MyColors.dart';
import '../constants/app_images.dart';
import '../constants/app_text_styles.dart';
import 'custom_image_handler.dart';
class EvexDropDownField<T> extends StatefulWidget {
  final String title;
  final String? hint;
  final List<T> items;
  final void Function(T?) onChanged;
  final T? value;
  const EvexDropDownField({
    super.key,
    required this.title,
    required this.items,
    required this.onChanged,
    this.hint,
    this.value,
  });

  @override
  State<EvexDropDownField<T>> createState() => _EvexDropDownFieldState<T>();
}

class _EvexDropDownFieldState<T> extends State<EvexDropDownField<T>> {
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
            return DropdownButtonFormField<T>(
              value: widget.value,
              items:
                  widget.items
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            '$item',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                      .toList(),

              selectedItemBuilder: (context) {
                return widget.items
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          '$item',
                          style: TextStyle(
                            fontFamily: "din",
                            fontSize: 16.sp,
                            color: Color(0xFF121212),
                          ),
                        ),
                      ),
                    )
                    .toList();
              },
              onChanged: widget.onChanged,
              dropdownColor: Colors.white,

              focusNode: _myFocusNode,

              style: TextStyle(
                fontFamily: 'din',
                fontWeight: FontWeight.w600,
                fontSize: 2.sp,
                color: Color(0xFF121212),
              ),

              hint:
                  widget.hint != null
                      ? Text(
                        widget.hint!,
                        style: TextStyle(
                          fontFamily: 'din',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.normal,
                          color:
                              widget.items.isEmpty
                                  ? Color(0xFF99A2AC)
                                  : Color(0xFF6F767E),
                        ),
                      )
                      : null,
              validator: (value) {
                if (value == null) {
                  isError = true;
                  return "يجب ادخال الحقل";
                }
                isError = false;

                return null;
              },
              autovalidateMode: AutovalidateMode.onUnfocus,
              // iconSize: 24.r,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color:
                    widget.items.isEmpty
                        ? Color(0xFF99A2AC)
                        : Color(0xFF121212),
                // size: 30.r,
              ),
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                // suffixIcon: Icon(Icons.arrow_back),
                filled: true,
                fillColor:
                    isError
                        ? AppColors.backgroundColor
                        : isFocus
                        ? AppColors.backgroundColor
                        : AppColors.boarderFillColor,

                errorStyle: TextStyle(fontSize: 12.sp),
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
