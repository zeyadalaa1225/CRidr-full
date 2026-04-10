import 'package:flutter/material.dart';

class AppbarTheme {
  static const lightAppBarTheme = AppBarTheme(
    centerTitle: true,
    scrolledUnderElevation: 0,
    foregroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Color(0xff73559A), size: 24),
    actionsIconTheme: IconThemeData(color: Color(0xff73559A), size: 24),
    titleTextStyle: TextStyle(
      color: Color(0xff73559A),
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
  );
  static const darkAppBarTheme = AppBarTheme(
    centerTitle: true,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.black,
    elevation: 0,
    iconTheme: IconThemeData(color: Color(0xff73559A), size: 24),
    actionsIconTheme: IconThemeData(color: Color(0xff73559A), size: 24),
    titleTextStyle: TextStyle(
      color: Color(0xff73559A),
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
  );
}
