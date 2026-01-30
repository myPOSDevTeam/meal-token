import 'package:flutter/material.dart';
import 'package:jkh_mealtoken/components/extentions/utils/size_utils.dart';
import 'package:jkh_mealtoken/components/theme/theme_helper.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodyLargeGray400a2 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray400A2,
      );
  static get bodyLargeOnPrimary => theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static get bodyMediumPrimary => theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.primary.withOpacity(1),
      );
  static get bodyMediumPrimary_1 => theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.primary.withOpacity(1),
      );
  // Headline style
  static get headlineSmall_1 => theme.textTheme.headlineSmall!;
  // Title text style
  static get titleMediumGray800 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray800,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w500,
      );
  static get titleMedium => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray800,
        fontSize: 28.fSize,
        fontWeight: FontWeight.bold,
      );

  static get titleMedium1 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray800,
        fontSize: 14.fSize,
        fontWeight: FontWeight.bold,
      );
  static get titleMediumInter => theme.textTheme.titleMedium!.inter;
  static get titleMediumRed600 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.red600,
      );
  static get titleMediumRed => theme.textTheme.titleMedium!
      .copyWith(color: appTheme.red600, fontSize: 24);
  static get titleSmallBold => theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w700,
      );
  static get titleSmall_1 => theme.textTheme.titleSmall!;

  static get titleMedium2 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray800,
        fontSize: 20.fSize,
        fontWeight: FontWeight.w500,
      );

  static get titleMedium3 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.yellow700,
        fontSize: 22.fSize,
        fontWeight: FontWeight.w800,
      );

  static get titleMedium4 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
        fontSize: 20.fSize,
        fontWeight: FontWeight.bold,
      );

  static get titleMedium5 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
        fontSize: 16.fSize,
        fontWeight: FontWeight.bold,
      );

  static get appbartitle => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
        fontSize: 24.fSize,
        fontWeight: FontWeight.bold,
      );

  static get titleMedium7 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
        fontSize: 18.fSize,
        fontWeight: FontWeight.w600,
      );

  static get titleMedium6 => theme.textTheme.titleMedium!.copyWith(
        color: Colors.green,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w600,
      );

  static get titleMedium8 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.red600,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w600,
      );
}

extension on TextStyle {
  TextStyle get nunito {
    return copyWith(
      fontFamily: 'Nunito',
    );
  }

  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }
}
