import 'package:flutter/material.dart';

import '../core/app_export.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodyLargeOnBlackBold => theme.textTheme.bodyLarge!.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      );
  static get bodyLargeOnPrimary => theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static get bodyLargeOnGray => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray400,
      );
  static get bodyMediumOnGray => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray400,
      );
  static get bodyLargeOnWhite => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.whiteA70001,
      );
  static get bodyMedium14 => theme.textTheme.bodyMedium!.copyWith(
        fontSize: 14.fSize,
      );
  static get bodyMedium15 => theme.textTheme.bodyMedium!.copyWith(
        fontSize: 15.fSize,
        fontWeight: FontWeight.w700,
        color: appTheme.whiteA70001,
      );
  static get bodySmall11 => theme.textTheme.bodyMedium!.copyWith(
        fontSize: 11.fSize,
      );
  static get bodyMediumWhite => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.whiteA70001,
      );
  static get bodyMediumWhiteUnderline => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.whiteA70001,
        decoration: TextDecoration.underline,
      );
  static get bodyMediumSecondaryContainer =>
      theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.secondaryContainer,
      );
  static get bodyLargeHintStyle => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.hintPrimary,
      );
  static get bodyMediumSecondary => theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.secondary,
      );
  static get bodySmallOnPrimary => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static get bodySmallOnWhite => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.whiteA70001,
      );
  // Headline text style
  static get headlineLarge32 => theme.textTheme.headlineLarge!.copyWith(
        fontSize: 32.fSize,
      );
  static get headlineLargeOnPrimary => theme.textTheme.headlineLarge!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 30.fSize,
      );
  static get headlineLargeWhiteA70001 =>
      theme.textTheme.headlineLarge!.copyWith(
        color: appTheme.whiteA70001,
      );
  static get headlineLargeWhiteA7000130 =>
      theme.textTheme.headlineLarge!.copyWith(
        color: appTheme.whiteA70001,
        fontSize: 30.fSize,
      );
  static get headlineLargeWhiteA7000132 =>
      theme.textTheme.headlineLarge!.copyWith(
        color: appTheme.whiteA70001,
        fontSize: 32.fSize,
      );
  static get headlineLargeff63d9ff => theme.textTheme.headlineLarge!.copyWith(
        color: Color(0XFF63D9FF),
      );
  static get headlineLargeff63d9ff32 => theme.textTheme.headlineLarge!.copyWith(
        color: Color(0XFF63D9FF),
        fontSize: 32.fSize,
      );
  static get headlineSmallOnWhite => theme.textTheme.headlineSmall!.copyWith(
        color: Color(0XFFFFFFFF),
      );
  static get labelMediumGreen400 => theme.textTheme.labelMedium!.copyWith(
        color: appTheme.green400,
      );
  // Label text style
  static get labelLargeSemiBold => theme.textTheme.labelLarge!.copyWith(
        fontSize: 12.fSize,
        fontWeight: FontWeight.w600,
      );
  // Title text style
  static get titleMediumff006297 => theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFF006297),
      );
  static get titleSmallOnPrimary => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallPrimary => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get titleSmallWhiteA700 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.whiteA700,
      );

  static get propertyTitle => theme.textTheme.bodyLarge!.copyWith(
      fontSize: 18,
      color: theme.colorScheme.onPrimary,
      fontWeight: FontWeight.bold);
}
