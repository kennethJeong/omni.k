import 'package:flutter/material.dart';

class MyTheme {
  MyTheme._();
  static Color kPrimaryColor = const Color(0x98BCB6F1);
  static Color kPrimaryColorVariant = const Color(0xff686795);
  static Color kAccentColor = const Color(0xffffbfbf);
  static Color kAccentColorVariant = const Color(0xffF7A3A2);
  static Color kHintColor = const Color(0x981F1F25);

  // IOS용 테마
  static ThemeData kIOSTheme = ThemeData(
    primarySwatch: Colors.deepPurple,
    primaryColor: MyTheme.kPrimaryColor,
    fontFamily: 'NotoSansKR',
    dividerColor: Colors.transparent,
    scaffoldBackgroundColor: Colors.white,
    hintColor: Colors.black38,
    iconTheme: const IconThemeData(
      color: Colors.black45,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      background: Colors.white
    ),
    unselectedWidgetColor: Colors.white,
  );

  // 기본 테마
  static ThemeData kDefaultTheme = ThemeData(
    primaryColor: MyTheme.kPrimaryColor,
    fontFamily: 'NotoSansKR',
    dividerColor: Colors.transparent,
    scaffoldBackgroundColor: Colors.white,
    hintColor: Colors.black38,
    iconTheme: const IconThemeData(
      color: Colors.black45,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      background: Colors.white
    ),
    unselectedWidgetColor: Colors.white,
  );
}