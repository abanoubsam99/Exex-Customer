import 'package:animate_do/animate_do.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import 'evex_filled_button.dart';
import 'evex_heading_text.dart';
import 'my_checkbox.dart';

class EvexMultiSelectDropDownSearchField<T> extends StatefulWidget {
  final String title;
  final String? hint;
  final List<T> items;
  final void Function(T?) onChanged;
  final T? value;
  const EvexMultiSelectDropDownSearchField({
    super.key,
    required this.title,
    required this.items,
    required this.onChanged,
    this.hint,
    this.value,
  });

  @override
  State<EvexMultiSelectDropDownSearchField<T>> createState() =>
      _EvexMultiSelectDropDownSearchFieldState<T>();
}

class _EvexMultiSelectDropDownSearchFieldState<T>
    extends State<EvexMultiSelectDropDownSearchField<T>> {
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
        DropdownSearch<T>.multiSelection(
          items: (filter, s) => widget.items,
          compareFn: (i, s) => i == s,

          //sufffix icon
          suffixProps: DropdownSuffixProps(
            dropdownButtonProps: DropdownButtonProps(
              iconClosed: Icon(
                Icons.keyboard_arrow_down_rounded,
                color:
                    widget.items.isEmpty
                        ? Color(0xFF99A2AC)
                        : Color(0xFF121212),
              ),
              iconOpened: Icon(Icons.keyboard_arrow_up),
            ),
          ),
          // TextFormField decoration
          dropdownBuilder:
              (context, selectedItems) => Text(
                selectedItems.join(","),
                style: TextStyle(
                  fontFamily: "din",
                  fontSize: 16.sp,
                  color: Color(0xFF121212),
                ),
              ),
          decoratorProps: DropDownDecoratorProps(
            baseStyle: TextStyle(color: Colors.amber),
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              isDense: true,
              contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 12),
              hintText: widget.hint,
              hintStyle: TextStyle(
                fontFamily: 'din',
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                color:
                    widget.items.isEmpty
                        ? Color(0xFF99A2AC)
                        : Color(0xFF6F767E),
              ),
              // suffixIcon: Icon(Icons.arrow_back),
              filled: true,
              fillColor:
                  isError
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
          ),

          //popup decoration
          popupProps: PopupPropsMultiSelection.modalBottomSheet(
            modalBottomSheetProps: ModalBottomSheetProps(),
            // textDirection: TextDirection.rtl,
            fit: FlexFit.loose,
            constraints: BoxConstraints(maxHeight: 1.sh),
            //ok button
            validationBuilder:
                (context, items) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  color: Colors.white,
                  child: EvexFilledButton(
                    text: "حفظ التغيرات",
                    onPressed: () {},
                  ),
                ),
            containerBuilder:
                (context, popupWidget) => Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 18.h,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Container(
                        width: 80.w,
                        height: 4.r,
                        decoration: BoxDecoration(
                          color: Color(0xFFE4E7EC),
                          borderRadius: BorderRadius.circular(500),
                        ),
                      ),
                      14.verticalSpace,
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Color(0xFFE4E7EC)),
                          ),
                        ),
                        height: 48.r,
                        child: Row(
                          children: [
                            EvexHeadingText(
                              title: 'أختر الايام',
                              fontSize: 18.r,
                            ),
                          ],
                        ),
                      ),
                      // MyCheckbox(item: 'test'),
                      Flexible(child: popupWidget),
                    ],
                  ),
                ),
            // fit: FlexFit.tight,
            listViewProps: ListViewProps(shrinkWrap: true),
            // title: Center(
            //   child: Container(
            //     margin: EdgeInsets.symmetric(vertical: 8.h),
            //     width: 80.w,
            //     height: 4.r,
            //     decoration: BoxDecoration(
            //       color: Color(0xFFE4E7EC),
            //       borderRadius: BorderRadius.circular(500),
            //     ),
            //   ),
            // ),
            itemClickProps: ClickProps(
              highlightColor: Color(0xFFFFF1E9),
              splashColor: Color(0xFFFFF1E9),
              onLongPress: () {
                print("hello");
              },
            ),
            // interceptCallBacks: true,
            // itemBuilder: (context, item, isDisabled, isSelected) => SizedBox(),
            // checkBoxBuilder:
            //     (context, item, isDisabled, isSelected) =>
            //         MyCheckbox(isSelected: isSelected, item: item as String),
            itemBuilder:
                (context, item, isDisabled, isSelected) =>
                    MyCheckbox(isSelected: isSelected, item: item as String),

            // checkBoxBuilder:
            //     (context, item, isDisabled, isSelected) =>
            //         MyCheck2(isSelected: isSelected),
            // showSearchBox: true,
          ),
        ),
      ],
    );
  }
}

Checkbox myCheck(isSelected) {
  return Checkbox(value: isSelected, onChanged: (value) {});
}

class MyCheck2 extends StatefulWidget {
  final bool isSelected;
  const MyCheck2({super.key, required this.isSelected});

  @override
  State<MyCheck2> createState() => _MyCheck2State();
}

class _MyCheck2State extends State<MyCheck2> {
  late AnimationController animateController;
  bool animate = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            // isChecked = !isChecked;
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
                'hhhh',
                style: TextStyle(fontSize: 16.sp, color: Color(0xFF121212)),
              ),
              8.horizontalSpace,
              Checkbox(value: widget.isSelected, onChanged: (value) {}),
              8.horizontalSpace,
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    // isChecked = !isChecked;
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
                      color: widget.isSelected ? AppColors.orangeColor : null,
                      border:
                          widget.isSelected
                              ? null
                              : Border.all(
                                width: 1.67.r,
                                color: Color(0xFFD0D5DD),
                              ),
                      borderRadius: BorderRadius.circular(5.0.r),
                    ),

                    child:
                        widget.isSelected
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
