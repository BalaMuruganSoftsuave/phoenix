import 'package:flutter/material.dart';

class FontHelper {
  static const String fontFamily = 'WorkSans';

  // Font weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // Font sizes
  static const double small = 12.0;
  static const double mediumSize = 16.0;
  static const double large = 20.0;
  static const double extraLarge = 24.0;

  // Common text styles
  static const TextStyle normalText = TextStyle(
    fontFamily: fontFamily,
    fontWeight: regular,
    fontSize: mediumSize,
  );

  static const TextStyle boldText = TextStyle(
    fontFamily: fontFamily,
    fontWeight: bold,
    fontSize: large,
  );

  static const TextStyle semiBoldText = TextStyle(
    fontFamily: fontFamily,
    fontWeight: semiBold,
    fontSize: mediumSize,
  );
}
