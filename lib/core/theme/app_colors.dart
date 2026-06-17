import 'package:flutter/material.dart';

class AppColors {
  // add a private constructor to prevent this class being instantiated
  // e.g. invoke `AppColors()` accidentally
  AppColors._();

  // the properties are static so that we can use them without a class instance
  // e.g. can be retrieved by `LocalStorageKey.saveUserId`.
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color primaryColor = Color(0xffF38B4A);

  static const Color backgroundColor = Color(0xFFFFFFFF);

  static const Color boarderColor = Color(0xFFF2F4F7);
  static const Color boarderFillColor = Color(0xFFF4F4F4);

  static const Color orangeColor = Color(0xFFF38B4A);
  static const Color lightOrangeColor = Color(0xFFFFB88C);

  static const Color black = Color(0xFF121212);
  static const Color blacksoft = Color(0xff2C262C);
  static const Color blacksoftHint = Color(0xFFC4C4C4);
  static const Color offBlackColor = Color(0xff433D42);
  static const Color grey = Color(0xFF6F767E);

  static List<Color> authGradient = [
    const Color(0xff120404),
    const Color(0xff5D0D0D),
  ];
  static List<Color> welcomeGradient = [
    Colors.transparent,
    Colors.black.withOpacity(0.2),
    Colors.black.withOpacity(0.5),
    Colors.black.withOpacity(0.6),
  ];
  static const Color redtext = Color(0xffF17272);
  static const Color lightestPrimaryColor = Color(0xffFFF8F3);
  static const Color secondaryColor = Color(0xffF38B4A);
  static const Color darkPrimaryColor = Color(0xffFFB88C);
  static const Color lightPrimaryColor = Color(0xff2A2A2A);
  static const Color blackColor = Color(0xff00070D);
  static const Color blackColor2 = Color(0xFF121212);
  static const Color subtitleColor = Color(0xff8A8A8A);

  static const Color offWhite = Color(0xffE8E8E8);
  static const Color bgGrey2 = Color(0xfff7f7f7);
  static const Color textLightGreyColor = Color(0xffB0B0B0);
  static const Color textDarkGreyColor = Color(0xffE8E8E8);
  static const Color navigationUnSelected = Color(0xff8C8C8C);
  static const Color textWhiteSubtitleColor = Color(0xffB7D7FF);
  static Color textInputBorderColor = const Color.fromRGBO(
    0,
    0,
    64,
    0,
  ).withOpacity(0.25);
  static const Color greenColor = Color(0xff00A92F);
  static const redColor = Color(0xffFF0000);
  static const redAlertColor = Color.fromRGBO(0, 0, 26, 1);
  static const yellowColor = Color(0xffC19600);
  static const Color buttonSecondaryColor = Color(0xffF4F4F4);
  static const Color textfieldBgColor = Color(0xffF9FAFB);
  static const Color textfieldBorderColor = Color(0xffF1F3F9);
  static const Color textfieldHintTxtColor = Color(0xff6F767E);
  static const Color text300Color = Color(0xff010b13);
  static const Color lightGray = Color(0xffB5B5B5);
  static const Color lightGray2 = Color(0xff8A8A8A);
  static const Color bgGrey = Color(0xffF9FAFB);
  static const Color bgGray = Color(0xffE9EFF5);

  // ── Recurring inline colors (centralized so the whole app changes here) ──
  /// Blue-grey hint/secondary text (0xFF99A2AC) — very common.
  static const Color blueGrey = Color(0xFF99A2AC);
  static const Color titleGrey2 = Color.fromRGBO(111, 118, 126, 1);

  /// Light blue-grey for unit labels like "جنيه" (0xFFA5B7C6).
  static const Color unitGrey = Color(0xFFA5B7C6);

  /// Divider / placeholder grey (0xFFD9D9D9).
  static const Color dividerGrey = Color(0xFFD9D9D9);

  /// Light border grey (0xFFE4E7EC).
  static const Color borderGrey = Color(0xFFE4E7EC);

  /// Faint line / separator (0xFFEDEDED).
  static const Color lineGrey = Color(0xFFEDEDED);

  /// Medium grey text (0xFF787878).
  static const Color grey2 = Color(0xFF787878);

  /// Success green (0xFF4CD195) + softer deposit green (0xFF79E2B2).
  static const Color green = Color(0xFF4CD195);
  static const Color greenSoft = Color(0xFF79E2B2);

  /// Coral / cancel-total red (0xFFFE7062).
  static const Color coral = Color(0xFFFE7062);

  /// Card/elevation shadows.
  static const Color shadow = Color(0x19000000);
  static const Color shadowSoft = Color(0x0A000000);

  // ── Oranges / peach tints ──
  static const Color peachOrange = Color(0xFFF9C5A4);
  static const Color lightPeach = Color(0xFFFFF1E9);
  static const Color peachBg1 = Color(0xFFFEF3ED);
  static const Color peachBg2 = Color(0xFFFFF0E5);
  static const Color peachBg3 = Color(0xFFFDEFE5);
  static const Color peachBg4 = Color(0xFFFDE7D8);
  static const Color peach2 = Color(0xFFFFC9A9);
  static const Color lightOrange2 = Color(0xFFF8BC96);
  static const Color lightOrange3 = Color(0xFFF9B98C);
  static const Color beige = Color(0xFFF3E2D6);
  static const Color salmon = Color(0xFFFF928E);
  static const Color salmon2 = Color(0xFFFB7272);
  static const Color salmon3 = Color(0xFFF4897F);

  // ── Reds / pinks ──
  static const Color red2 = Color(0xFFFE2B2C);
  static const Color red3 = Color(0xFFEF6164);
  static const Color red4 = Color(0xFFEB5757);
  static const Color red5 = Color(0xFFD42D1C);
  static const Color redSoft = Color(0xFFEF5350);
  static const Color errorRed = Color(0xFFD92D20);
  static const Color redBg = Color(0xFFFDECEC);
  static const Color pinkBg = Color(0xFFFFECEE);

  // ── Yellows / amber ──
  static const Color amber = Color(0xFFFFBC2B);
  static const Color yellowBg = Color(0xFFFFF6D9);

  // ── Greens ──
  static const Color green2 = Color(0xFF42C287);
  static const Color green3 = Color(0xFF2CAC61);
  static const Color green4 = Color(0xFF55A07E);
  static const Color green5 = Color(0xFF3FC086);
  static const Color green6 = Color(0xFF2BA577);
  static const Color green7 = Color(0xFF27AE60);
  static const Color green8 = Color(0xFF1F9D55);
  static const Color greenBg1 = Color(0xFFE7F7EE);
  static const Color greenBg2 = Color(0xFFEAF8F1);

  // ── Blues / cyan ──
  static const Color blue1 = Color(0xFF2F80ED);
  static const Color blue2 = Color(0xFF4A7CF7);
  static const Color blue3 = Color(0xFF4764E8);
  static const Color blue4 = Color(0xFF3F8CFF);
  static const Color cyan = Color(0xFF40C4D6);
  static const Color periwinkle = Color(0xFF879DFF);
  static const Color lightBlue1 = Color(0xFFB6DAEE);
  static const Color lightBlue2 = Color(0xFFBFD9EC);
  static const Color lightBlue3 = Color(0xFFAED0E7);
  static const Color blueBg1 = Color(0xFFEAF4FF);
  static const Color blueBg2 = Color(0xFFE8F0FE);
  static const Color blueGreyBg = Color(0xFFE8ECF4);

  // ── Purples ──
  static const Color purple1 = Color(0xFF9670F7);
  static const Color purple2 = Color(0xFF6C5CE7);
  static const Color purple3 = Color(0xFF584191);
  static const Color lavenderBg = Color(0xFFEDEBFB);

  // ── Neutrals / greys ──
  static const Color bgLightGrey = Color(0xFFF8F8F8);
  static const Color fillGrey1 = Color(0xFFF0F0F0);
  static const Color fillGrey2 = Color(0xFFF3F3F3);
  static const Color fillGrey3 = Color(0xFFF6F6F6);
  static const Color fillGrey4 = Color(0xFFF4F5F7);
  static const Color fillGrey5 = Color(0xFFEFEFEF);
  static const Color grey3 = Color(0xFFD0D0D0);
  static const Color grey4 = Color(0xFFB7B7B7);
  static const Color grey5 = Color(0xFF777175);
  static const Color grey6 = Color(0xFFDADADA);
  static const Color grey7 = Color(0xFFD8DADC);
  static const Color grey8 = Color(0xFFCFCFCF);
  static const Color grey9 = Color(0xFFC5BFC3);
  static const Color blueGrey2 = Color(0xFF6681AF);
  static const Color darkGrey = Color(0xFF5E5E5E);
  static const Color borderGrey2 = Color(0xFFD0D5DD);
  static const Color pureBlack = Color(0xFF000000);

  // ── Alpha / overlay variants (exact values preserved) ──
  static const Color primaryAlpha1A = Color(0x1AF38B4A);
  static const Color primaryAlpha19 = Color(0x19F38B4A);
  static const Color primaryAlpha23 = Color(0x23F38B4A);
  static const Color primaryAlpha28 = Color(0x28F38B4A);
  static const Color primaryAlpha33 = Color(0x33F38B4A);
  static const Color primaryAlpha99 = Color(0x99F38B4A);
  static const Color blackAlpha0F = Color(0x0F000000);
  static const Color blackAlpha12 = Color(0x12000000);
  static const Color blackAlpha14 = Color(0x14000000);
  static const Color blackAlpha1E = Color(0x1E000000);
  static const Color blackAlpha23 = Color(0x23000000);
  static const Color blackAlpha66 = Color(0x66000000);
  static const Color dividerGreyAlpha33 = Color(0x33D9D9D9);
  static const Color red2Alpha19 = Color(0x19FE2B2C);
  static const Color lightOrangeAlpha7F = Color(0x7FFFB88C);
  static const Color peachAlpha7F = Color(0x7FFEF1E9);
  static const Color fillGreyAlpha7F = Color(0x7FF4F4F4);
  static const Color lightBlue3Alpha33 = Color(0x33AED0E7);
  static const Color redSoftAlpha1A = Color(0x1AEF5350);
  static const Color green2Alpha1A = Color(0x1A42C287);
  static const Color cyanAlpha1A = Color(0x1A40C4D6);
  static const Color red6Alpha19 = Color(0x19EE6163);
  static const Color greenSoftAlpha19 = Color(0x1979E2B2);
  static const Color greenAlpha19 = Color(0x194CD195);
}
