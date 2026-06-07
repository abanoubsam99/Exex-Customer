import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppValidationFunctions {
  //Validation Functions for validating user input
  static String? emailValidationFunction(String? email) {
    if (email!.isEmpty) {
      return Get.locale!.languageCode == 'ar'
          ? 'البريد الإلكتروني لا يمكن أن يكون فارغًا!'
          : "Email can't be empty!";
    }

    // Regular expression for a valid email address
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@([a-zA-Z0-9-]+\.)+[a-zA-Z]+$',
    );

    if (!emailRegExp.hasMatch(email)) {
      return Get.locale!.languageCode == 'ar'
          ? 'الرجاء إدخال عنوان بريد إلكتروني صحيح'
          : 'Please enter a valid email address';
    }

    return null;
  }

  static String? passwordValidationFunction(String? password) {
    if (password == '') {
      return Get.locale!.languageCode == 'ar'
          ? 'كلمة المرور لا يمكن ان تكون فارغة !'
          : "Password can't be empty";
    } else if (password!.length < 6) {
      return Get.locale!.languageCode == 'ar'
          ? '!كلمة المرور يجب ان تحتوي على 6 حروف على الأقل'
          : "Password must have at least 8 characters";
    } else if (!RegExp(r'[a-z]').hasMatch(password)) {
      return Get.locale!.languageCode == 'ar'
          ? 'يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل'
          : "Password must contain at least one lowercase letter";
    } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return Get.locale!.languageCode == 'ar'
          ? 'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل'
          : "Password must contain at least one uppercase letter";
    } else if (!RegExp(r'[0-9]').hasMatch(password)) {
      return Get.locale!.languageCode == 'ar'
          ? 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل'
          : "Password must contain at least one number";
    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return Get.locale!.languageCode == 'ar'
          ? 'يجب أن تحتوي كلمة المرور على رمز خاص واحد على الأقل'
          : "Password must contain at least one special character";
    } else {
      return null;
    }
  }

  static String? phoneValidationFunction(String? phoneNumber) {
    final RegExp phoneRegex = RegExp(r'^(011|012|010|015)\d{8}$');
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return Get.locale!.languageCode == 'ar'
          ? 'رقم الهاتف لا يمكن ان يكون فارغ'
          : 'phone number can not be empty';
    } else if (!phoneRegex.hasMatch(phoneNumber)) {
      return Get.locale!.languageCode == 'ar'
          ? 'رقم الهاتف غير صالح'
          : 'phone number is not valid';
    }
    return null;
  }

  static String? nationalnumberValidationFunction(String? number) {
    //write regex that makes sure it has only digits an d not more than 20 digit and not smaller than 9 digits
    final RegExp reg = RegExp(r'^\d{14}$');
    if (!reg.hasMatch(number!)) {
      return Get.locale!.languageCode == 'ar'
          ? 'الرقم القومي غير صالح'
          : 'enter a valid national  number';
    }
    return null;
  }

  static String? stringValidationFunction(String? fullName, String fieldName) {
    if (fullName == null || fullName.isEmpty) {
      return Get.locale!.languageCode == 'ar'
          ? '$fieldName لا يمكن أن يكون فارغًا!'
          : "$fieldName can't be empty!";
    }

    // Regular expression for valid names (Arabic and English letters only)
    // final RegExp nameRegExp = RegExp(r'^[a-zA-Z\u0621-\u064A 0-9]{3,50}$');

    // if (!nameRegExp.hasMatch(fullName)) {
    //   return Get.locale!.languageCode == 'ar'
    //       ? 'الرجاء إدخال $fieldName صحيح (3-50 أحرف)'
    //       : 'Please enter a valid $fieldName (3-50 characters)';
    // }

    return null;
  }

  static String? fullNameValidation(String? fullName, String fieldName) {
    if (fullName == null || fullName.isEmpty) {
      return Get.locale!.languageCode == 'ar'
          ? '$fieldName لا يمكن أن يكون فارغًا!'
          : "$fieldName can't be empty!";
    } else {
      List<String> names = fullName.split(' ');
      names = names.where((element) => element.trim().isNotEmpty).toList();
      names = names.join(' ').split(' ');
      if (names.length < 3) {
        return Get.locale!.languageCode == 'ar'
            ? '$fieldName يجب ان يكون ثلاثي'
            : 'The name must be three-word';
      }
    }
    return null;
  }

  static String? validateNumbersOnly(String? value) {
    if (value == null || value.isEmpty) {
      return "هذا الحقل مطلوب";
    }

    // تحقق أن القيمة تحتوي فقط على أرقام
    final numericRegex = RegExp(r'^[0-9]+$');
    if (!numericRegex.hasMatch(value)) {
      return "يجب أن يحتوي الحقل على أرقام فقط";
    }

    return null; // القيمة صحيحة
  }
}

class NoSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new value contains spaces, reject it
    if (newValue.text.contains(' ')) {
      // Return the old value to prevent inserting spaces
      return oldValue;
    }
    // Otherwise, accept the new value
    return newValue;
  }
}
