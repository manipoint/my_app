import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/constent/const.dart';

class AppProvider extends GetxController {
  static AppProvider instance = Get.find();
  AppProvider() {
    checkTheme();
  }

  ThemeData theme = Constants.lightTheme;
  Key key = UniqueKey();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void setKey(value) {
    key = value;
    update();
  }

  void setNavigatorKey(value) {
    navigatorKey = value;
    update();
  }

  void setTheme(value, c) {
    theme = value;
    SharedPreferences.getInstance().then((preference) {
      preference.setString("theme", c).then((val) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor:
              c == "dark" ? Constants.darkPrimary : Constants.lightPrimary,
          statusBarIconBrightness:
              c == "dark" ? Brightness.light : Brightness.dark,
        ));
      });
    });
    update();
  }

  ThemeData getTheme(value) {
    return theme;
  }

  Future<ThemeData> checkTheme() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    ThemeData t;
    String? r = preference.getString("theme") ?? "light";

    if (r == "light") {
      t = Constants.lightTheme;
      setTheme(Constants.lightTheme, "light");
    } else {
      t = Constants.darkTheme;
      setTheme(Constants.darkTheme, "dark");
    }

    return t;
  }
}
