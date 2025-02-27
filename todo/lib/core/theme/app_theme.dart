import 'package:flutter/material.dart';
import 'package:todo/core/theme/app_color.dart';

class AppTheme {
  static final darkThemeMode = ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: AppColor.backGroundColor,
      appBarTheme: const AppBarTheme(backgroundColor: AppColor.appBarColor),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppColor.appColor));
}
