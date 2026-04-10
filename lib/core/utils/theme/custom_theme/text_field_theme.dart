import 'package:flutter/material.dart';

class TextFieldTheme {
  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
    hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.red, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.orange, width: 2),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
    hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
    errorStyle: TextStyle(fontWeight: FontWeight.normal),
    floatingLabelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.red, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.orange, width: 2),
    ),
  );
}
