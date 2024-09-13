import 'package:flutter/material.dart';
import 'package:fitoagricola/core/app_export.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillBlue => BoxDecoration(
        color: appTheme.blue50,
      );
  static BoxDecoration get fillBlue5001 => BoxDecoration(
        color: appTheme.blue5001,
      );
  static BoxDecoration get fillPrimary => BoxDecoration(
        color: theme.colorScheme.primary,
      );
  static BoxDecoration get fillGreen => BoxDecoration(
        color: appTheme.green50,
      );
  static BoxDecoration get fillWhiteA => BoxDecoration(
        color: appTheme.whiteA700,
      );
  static BoxDecoration get fillWhiteA70001 => BoxDecoration(
        color: appTheme.whiteA70001,
      );

  // Gradient decorations
  static BoxDecoration get gradientWhiteAToGray => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0.74),
          end: Alignment(0.5, 1.02),
          colors: [
            appTheme.whiteA70001,
            appTheme.gray100,
          ],
        ),
      );

  // Outline decorations
  static BoxDecoration get outlineBlue => BoxDecoration(
        color: appTheme.whiteA70001,
        border: Border.all(
          color: appTheme.blue5001,
          width: 1.h,
        ),
      );

  // Cards Decorations
  static BoxDecoration get boxDecoration => BoxDecoration(
      color: appTheme.whiteA70001,
      borderRadius: BorderRadius.all(Radius.circular(15)));

  static BoxDecoration get loginDecoration => BoxDecoration(
      color: Color.fromRGBO(0, 0, 0, 0.7),
      borderRadius: BorderRadius.all(Radius.circular(35)));
}

class BorderRadiusStyle {
  // Custom borders
  static BorderRadius get customBorderTL10 => BorderRadius.vertical(
        top: Radius.circular(10.h),
      );

  // Rounded borders
  static BorderRadius get roundedBorder10 => BorderRadius.circular(
        10.h,
      );
}

// Comment/Uncomment the below code based on your Flutter SDK version.

// For Flutter SDK Version 3.7.2 or greater.

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;

// For Flutter SDK Version 3.7.1 or less.

// StrokeAlign get strokeAlignInside => StrokeAlign.inside;
//
// StrokeAlign get strokeAlignCenter => StrokeAlign.center;
//
// StrokeAlign get strokeAlignOutside => StrokeAlign.outside;
