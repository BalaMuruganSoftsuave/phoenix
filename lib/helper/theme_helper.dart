import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'color_helper.dart';

class ThemeHelper {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
    primaryColor: AppColors.darkBg2,
    brightness: Brightness.light,
    useMaterial3: true,
    textTheme: _buildTextTheme(context),
  );

  static ThemeData darkTheme(BuildContext context) => ThemeData(
    primaryColor: Colors.red,
    brightness: Brightness.dark,
  );

  static TextTheme _buildTextTheme(BuildContext context) {
    return TextTheme(
      titleLarge: _customTextStyle(context, 8),
      titleMedium: _customTextStyle(context, 8),
      titleSmall: _customTextStyle(context, 8),
      bodyLarge: _customTextStyle(context, 5),
      bodyMedium: _customTextStyle(context, 4),
      bodySmall: _customTextStyle(context, 5),
      displayLarge: _customTextStyle(context, 4),
      displayMedium: _customTextStyle(context, 4),
      displaySmall: _customTextStyle(context, 4),
      headlineLarge: _customTextStyle(context, 7),
      headlineMedium: _customTextStyle(context, 7),
      headlineSmall: _customTextStyle(context, 7),
    );
  }

  static TextStyle _customTextStyle(BuildContext context, double size) {
    return GoogleFonts.workSans().copyWith(
      fontSize: Responsive.fontSize(context, size),
      fontWeight: FontWeight.w400,
    );
  }
}
