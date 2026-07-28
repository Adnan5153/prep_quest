import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Centralized configuration for all widgets in the Prep Quest application.
///
/// This utility acts as the single source of truth for UI-related constants,
/// ensuring visual consistency and simplifying multi-platform scaling.
class WidgetConstants {
  const WidgetConstants._();

  // ----- Animation -----
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration normalAnimationDuration = Duration(milliseconds: 300);
  static const Duration slowAnimationDuration = Duration(milliseconds: 600);
  static const Duration pageTransitionDuration = Duration(milliseconds: 400);
  static const Duration heroAnimationDuration = Duration(milliseconds: 500);
  static const Duration hoverAnimationDuration = Duration(milliseconds: 200);
  static const Duration pressAnimationDuration = Duration(milliseconds: 100);
  static const Duration loadingAnimationDuration = Duration(seconds: 2);
  static const Duration snackbarAnimationDuration = Duration(seconds: 3);
  static const Duration tooltipAnimationDuration = Duration(milliseconds: 500);

  static const Curve defaultAnimationCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve easeCurve = Curves.ease;
  static const Curve easeInCurve = Curves.easeIn;
  static const Curve easeOutCurve = Curves.easeOut;
  static const Curve easeInOutCurve = Curves.easeInOut;
  static const Curve fastOutSlowInCurve = Curves.fastOutSlowIn;

  // ----- Elevation -----
  static const double buttonElevation = 0.0;
  static const double cardElevation = AppSizes.cardElevation;
  static const double dialogElevation = 8.0;
  static const double drawerElevation = 16.0;
  static const double appBarElevation = 0.0;
  static const double navigationBarElevation = 4.0;
  static const double navigationRailElevation = 0.0;
  static const double bottomSheetElevation = 12.0;
  static const double floatingActionButtonElevation = 6.0;

  // ----- Opacity -----
  static const double disabledOpacity = 0.38;
  static const double hoverOpacity = 0.08;
  static const double pressedOpacity = 0.12;
  static const double overlayOpacity = 0.6;
  static const double glassOpacity = 0.1;
  static const double focusOpacity = 0.12;
  static const double dragOpacity = 0.7;
  static const double selectedOpacity = 0.16;

  // ----- Borders -----
  static const double defaultBorderWidth = AppSizes.borderThin;
  static const double focusedBorderWidth = AppSizes.borderThick;
  static const double selectedBorderWidth = 2.0;
  static const double dividerThickness = 1.0;
  static const double outlineThickness = 1.0;

  // ----- Buttons -----
  static const double smallButtonHeight = 32.0;
  static const double mediumButtonHeight = 48.0;
  static const double largeButtonHeight = 56.0;
  static const double buttonMinWidth = 64.0;
  static const double buttonIconSize = 18.0;
  static const double buttonLoadingSize = 20.0;

  // ----- Cards -----
  static const double cardMinHeight = AppSizes.cardMinHeight;
  static const double cardMaxWidth = 600.0;
  static const double cardHoverScale = 1.02;
  static const double cardPressScale = 0.98;
  static const BoxShadow cardGlowShadow = BoxShadow(
    color: AppColors.primary,
    blurRadius: 15.0,
    spreadRadius: 2.0,
  );
  static const double glassBlurSigma = 12.0;
  static const double glassBorderOpacity = 0.2;
  static const double glassShadowBlur = 20.0;
  static const double glassShadowSpread = 0.0;

  // ----- Icons -----
  static const double smallIconSize = AppSizes.iconSm;
  static const double mediumIconSize = AppSizes.iconMd;
  static const double largeIconSize = AppSizes.iconLg;
  static const double extraLargeIconSize = AppSizes.iconXl;

  // ----- Avatars -----
  static const double smallAvatarSize = 32.0;
  static const double mediumAvatarSize = 48.0;
  static const double largeAvatarSize = 80.0;
  static const double avatarBorderWidth = AppSizes.borderThick;
  static const double onlineIndicatorSize = 12.0;

  // ----- Chips -----
  static const double chipHeight = 32.0;
  static const double chipMinWidth = 56.0;
  static const double chipIconSize = 18.0;

  // ----- Progress Indicators -----
  static const double linearProgressHeight = 4.0;
  static const double circularProgressStrokeWidth = 3.0;
  static const Duration progressAnimationDuration = Duration(milliseconds: 300);

  // ----- Loaders -----
  static const double smallLoaderSize = 24.0;
  static const double mediumLoaderSize = 48.0;
  static const double largeLoaderSize = 80.0;
  static const double fullscreenOverlayOpacity = 0.4;

  // ----- Navigation -----
  static const double appBarHeight = AppSizes.appBarHeight;
  static const double sliverExpandedHeight = 240.0;
  static const double bottomNavigationHeight = AppSizes.bottomNavHeight;
  static const double navigationRailWidth = 72.0;
  static const double drawerWidth = 304.0;

  // ----- Dialogs -----
  static const double dialogMaxWidth = 560.0;
  static const double bottomSheetMaxWidth = 640.0;
  static const double snackbarMaxWidth = 480.0;

  // ----- Badges -----
  static const double smallBadgeSize = 16.0;
  static const double mediumBadgeSize = 24.0;
  static const double largeBadgeSize = 32.0;
  static const double premiumBadgeSize = 20.0;

  // ----- Widget Builder Defaults -----
  static const String defaultPreviewTitle = 'Preview Title';
  static const String defaultPreviewSubtitle =
      'This is a secondary description for the widget.';
  static const String defaultButtonLabel = 'GET STARTED';
  static const String defaultCardTitle = 'Standard Card';
  static const String defaultChipLabel = 'Active';
  static const String defaultStatusLabel = 'SUCCESS';
  static const String defaultAvatarName = 'Ahmed Yeasin';
  static const String defaultTagLabel = 'Featured';
}
