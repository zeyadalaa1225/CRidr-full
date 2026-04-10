import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeviceUtility {
  DeviceUtility._();

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static Future<void> setStatusBarColor(Color color) async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: color),
    );
  }

  static bool isLandscapeOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static bool isPortraitOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static void setFullScreenMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  static double getPixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double getBottomNavigationBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }
  static double getAppBarHeight(BuildContext context) {
    return AppBar().preferredSize.height;
  }
  static bool isAndroid(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.android;
  }
  static bool isIOS(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }


  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
