import 'package:flutter/cupertino.dart';

class ZColors {
  ZColors._();
  // app basic colors
  static const Color primaryColor = Color(0xffAF99CC);
  static const Color secondaryColor = Color(0xFFffe24b);
  static const Color accentColor = Color(0xFFb0c7ff);
  static const Color containterColor = Color(0xFFF6F5F5);

  // gradient colors
  static const Gradient linearGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(.707, .707),
    colors: [Color(0xFFff9a9e), Color(0xFFfad0c4), Color(0xFFfad0c4)],
  );
  //text colors
  static const Color textPrimaryColor = Color(0xFF333333);
  static const Color textSecondaryColor = Color(0xFF9586A8);
  static const Color white = Color(0xFFFFFFFF);

  //background colors
  static const Color lightBackgroundColor = Color(0xFFF6F6F6);
  static const Color darkBackgroundColor = Color(0xFF272727);
  static const Color primaryBackgroundColor = Color(0xFFf3f5ff);

  // background container colors
  static const Color lightContainerColor = Color(0xFFF6f6f6);
  static const Color darkContainerColor = Color.fromRGBO(255, 255, 255, 0.1);

  //button colors
  static const Color buttonPrimaryColor = Color(0xFF4b68ff);
  static const Color buttonSecondaryColor = Color(0xFF6c757d);
  static const Color buttonDisabledColor = Color(0xFFc4c4c4);

  //border colors
  static const Color borderPrimary = Color(0xFFd9d9d9);
  static const Color borderSecondary = Color(0xFFe6e6e6);

  //error and validation colors
  static const Color errorColor = Color(0xFFd32f2f);
  static const Color successColor = Color(0xFF388e3c);
  static const Color warningColor = Color(0xFFf57c00);
  static const Color infoColor = Color(0xFF1976d2);

  //shadow colors
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4f4f4f);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFf0f0f0);
  static const Color softGrey = Color(0xfff4f4f4);
  static const Color lightGrey = Color(0xFFf9f9f9);
}
