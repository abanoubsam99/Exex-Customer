import 'package:flutter/material.dart';

class ObfuscatedTextWidget extends StatelessWidget {
  final String text;

  const ObfuscatedTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    String obfuscatedText = _obfuscateText(text);

    return Text(
      obfuscatedText,
      textDirection: TextDirection.ltr,
      // style: Get.textTheme.labelSmall!.copyWith(
      //   color: AppColors.lightGray2,
      //   fontSize: 15,
      //   fontWeight: FontWeight.w500,
      // ),
    );
  }

  String _obfuscateText(String input) {
    int length = input.length;

    if (length < 3) {
      return input;
    }

    int start = length ~/ 3;
    int end = (2 * length) ~/ 3;

    String middle = '*' * (end - start);

    return input.substring(0, start) + middle + input.substring(end);
  }
}
