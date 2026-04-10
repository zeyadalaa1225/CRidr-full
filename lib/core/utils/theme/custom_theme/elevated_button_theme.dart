import 'package:flutter/material.dart';

class ZElevatedButtonTheme {
  static ElevatedButtonThemeData lightElevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Color(0xffAF99CC),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey,
          disabledForegroundColor: Colors.grey,
          side: BorderSide(color: Color(0xffAF99CC)),
          textStyle: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
  static ElevatedButtonThemeData darkElevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Color(0xffAF99CC),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey,
          disabledForegroundColor: Colors.grey,
          side: BorderSide(color: Color(0xffAF99CC)),
          textStyle: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
}
