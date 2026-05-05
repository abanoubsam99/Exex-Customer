import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EvexSubHeadingText extends StatelessWidget {
  final String title;
  const EvexSubHeadingText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.right,
      style: TextStyle(
        color: Color.fromRGBO(111, 118, 126, 1),
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
