import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class MyFunction{
  static bool isAndroid() => Platform.isAndroid;

  ///isRTL
  static bool isRTL(BuildContext context) => Directionality.of(context).name=="ar";


  static void copyText(String text){
    Clipboard.setData(ClipboardData(text: '$text'));
    // myApplication.showToast(text: "Text copied to clipboard!", color: MyColors.green);
  }
}
