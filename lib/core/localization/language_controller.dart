// import 'package:flutter/material.dart';
// import 'package:get/get.dart';


// //Getx Controller that's responsible for changing the language and for the start of the app it will have the default
// //Device Language
// class LanguageController extends GetxController {
//   late Rxn<Locale> currentLanguage =
//       Rxn<Locale>(Locale(CashHelper.getData(CacheKeys.languageCode) ?? "ar"));

//   void toggleLanguage() {
//     currentLanguage.value = currentLanguage.value!.languageCode == 'en'
//         ? const Locale('ar')
//         : const Locale('en');
//     Get.updateLocale(currentLanguage.value!);
//   }

//   void changeLanguage(String languageCode) {
//     currentLanguage.value = Locale(languageCode);
//     CashHelper.setData(CacheKeys.languageCode, languageCode);
//     Get.updateLocale(currentLanguage.value!);
//   }

//   Locale getCacheLanguage() {
//     Locale locale = Locale(CashHelper.getData(CacheKeys.languageCode) ??
//         currentLanguage.value!.languageCode);
//     return locale;
//   }

//   Rxn<Color> primColor = Rxn<Color>(Colors.white);
// }
