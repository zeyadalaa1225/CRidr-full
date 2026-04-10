import 'package:cridr/core/utils/theme/custom_theme/app_bar_theme.dart';
import 'package:cridr/core/utils/theme/custom_theme/elevated_button_theme.dart';
import 'package:cridr/core/utils/theme/custom_theme/text_field_theme.dart';
import 'package:flutter/material.dart';

class ZAppTheme {
  ZAppTheme._(); //private constructor to prevent instantiation and enforce static usage
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Color(0xffF6F5F5),
    elevatedButtonTheme: ZElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: AppbarTheme.lightAppBarTheme,
    inputDecorationTheme: TextFieldTheme.lightInputDecorationTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    elevatedButtonTheme: ZElevatedButtonTheme.darkElevatedButtonTheme,
    appBarTheme: AppbarTheme.darkAppBarTheme,
    inputDecorationTheme: TextFieldTheme.darkInputDecorationTheme,
  );
}
