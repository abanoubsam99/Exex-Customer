import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OfferItemWithCount extends StatefulWidget {
  final String title, trilling;
  final int? giftCount, initialCount;
  final bool isSelected;
  final Function(int) onChanged;
  final Function(int) onChangeCount;
  const OfferItemWithCount(
      {super.key,
      required this.title,
      required this.isSelected,
      required this.trilling,
      required this.onChangeCount,
      this.initialCount,
      this.giftCount,
      required this.onChanged});

  @override
  State<OfferItemWithCount> createState() => _OfferItemWithCountState();
}

class _OfferItemWithCountState extends State<OfferItemWithCount> {
  int count = 0;
  TextEditingController countController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _validate() {
    final value = int.tryParse(countController.text);
    if (value == null || value < 1) {
      countController.text = '0';
    }
  }

  @override
  void initState() {
    count = widget.initialCount ?? 1;
    countController.text = count.toString();
    super.initState();

    // Listen for focus loss
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _validate();
      }
    });
  }

  @override
  void dispose() {
    countController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.giftCount != null) {
          return;
        }
        print('widget.isSelected ${widget.isSelected} count $count');
        //معكوسة علشان بتكون false الاول
        if (widget.isSelected == false && count == 0) {
          setState(() {
            count = 1;
          });
          countController.text = count.toString();
        }
        widget.onChanged(count);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected && count > 0 ||
                      (widget.giftCount != null && widget.giftCount! > 0)
                  ? AppColors.secondaryColor
                  : const Color(0xffE4E7EC),
            )),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 6),
                SizedBox(
                  width: 0.15.sw,
                  // fit: BoxFit.scaleDown,
                  child: Text(
                    widget.title,
                    softWrap: true,
                    style: const TextStyle(
                      color: Color(0xFF2C262C),
                      fontSize: 12,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.24,
                    ),
                  ),
                ),
                const Spacer(),
                if (widget.giftCount != null)
                  SizedBox(
                    width: 0.25.sw,
                    child: Card(
                      color: const Color(0xffFFF1E9),
                      shape: const StadiumBorder(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              const CustomImageHandler(AppImages.imagesGift),
                              Text(
                                "  ${widget.giftCount} ${widget.title} ",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.secondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                const Spacer(),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: RichText(
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: widget.trilling,

                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.secondaryColor,
                          ), // Use .sp for responsive font size
                        ),
                        TextSpan(
                          text: ' جنيه',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.blackColor,
                          ), // Use .sp for responsive font size
                        ),
                      ])),
                )
              ],
            ),
            // if (widget.totalCount != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: TextFormField(
                controller: countController,
                focusNode: _focusNode,

                // readOnly: !isSelected,
                // enabled: widget.isSelected,
                onChanged: (value) {
                  setState(() {
                    count = int.parse(value == '' ? "0" : value);
                  });
                  countController.selection = TextSelection.fromPosition(
                    TextPosition(offset: countController.text.length),
                  );
                  widget.onChangeCount(count);
                },
                onTap: () {
                  //fix cursor position for english text
                  if (countController.selection ==
                      TextSelection.fromPosition(
                          const TextPosition(offset: 0))) {
                    setState(() {
                      countController.selection = TextSelection.fromPosition(
                        TextPosition(
                          offset: countController.text.length,
                        ),
                      );
                    });
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefix: const Text('LE'),
                  suffixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            count = count + 1;
                            widget.onChangeCount(count);
                            countController.text = count.toString();
                            setState(() {});
                          },
                          onLongPress: () {
                            count = count + 5;
                            widget.onChangeCount(count);
                            countController.text = count.toString();
                            setState(() {});
                          },
                          child: const CircleAvatar(
                            radius: 15,
                            backgroundColor: AppColors.secondaryColor,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        10.horizontalSpace,
                        Container(
                          height: 25.h,
                          width: 1.1,
                          color: const Color(0xffE4E7EC),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (count >= 1) {
                              count = count - 1;
                              widget.onChangeCount(count);
                              countController.text = count.toString();
                              setState(() {});
                            }
                          },
                          onLongPress: () {
                            if (count >= 5) {
                              count = count - 5;
                              widget.onChangeCount(count);
                              countController.text = count.toString();
                              setState(() {});
                            } else if (count >= 1) {
                              count = count - 1;
                              widget.onChangeCount(count);
                              countController.text = count.toString();
                              setState(() {});
                            }
                          },
                          child: const CircleAvatar(
                            backgroundColor: AppColors.offWhite,
                            radius: 15,
                            child: Icon(Icons.remove),
                          ),
                        )
                      ],
                    ),
                  ),
                  filled: true,
                  focusColor: Colors.white,
                  fillColor: _focusNode.hasFocus
                      ? Colors.transparent // No fill color when focused
                      : AppColors.whiteColor,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(
                        color: AppColors.bgGray,
                      )),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(
                        color: AppColors.bgGray,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(
                        color: AppColors.darkPrimaryColor,
                      )),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: const BorderSide(
                      color: AppColors.bgGray,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(color: Colors.red.shade700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
