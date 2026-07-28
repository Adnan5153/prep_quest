import 'package:flutter/material.dart';

/// Brand and semantic colors used across the application.
///
/// Every color that touches the UI must come from this file — widget code is
/// not allowed to instantiate [Color] literals. This keeps theming,
/// dark-mode, and future re-skins cheap.
class AppColors {
  const AppColors._();

  // ----- Brand palette (from Plans/BCS_Booster_AI_SRS (1).md, section 6.1) --
  /// Primary green — main actions, success associations.
  static const Color primary = Color(0xFF0E7C4A);

  /// Secondary navy — headers, institutional credibility.
  static const Color secondary = Color(0xFF1B3B6F);

  /// Accent amber — streaks, ranks, premium badges.
  static const Color accent = Color(0xFFF5A623);

  // ----- Semantic states -----------------------------------------------------
  static const Color success = Color(0xFF2ECC71);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);
  static const Color info = Color(0xFF3498DB);

  // ----- Light surfaces -----------------------------------------------------
  static const Color lightSurface = Color(0xFFFAFAFA);
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF1F2933);
  static const Color lightMuted = Color(0xFF7B8794);

  // ----- Dark surfaces ------------------------------------------------------
  static const Color darkSurface = Color(0xFF121212);
  static const Color darkBackground = Color(0xFF0B0F14);
  static const Color darkOnSurface = Color(0xFFE4E7EB);
  static const Color darkMuted = Color(0xFF8A95A5);

  // ----- 3D depth & lighting ------------------------------------------------
  /// Soft drop shadow used beneath floating nodes / cards.
  static const Color nodeDropShadow = Color(0x33000000);

  /// Stronger contact shadow used at the base of raised nodes.
  static const Color nodeContactShadow = Color(0x55000000);

  /// Top-left directional light highlight (warm-white).
  static const Color nodeHighlight = Color(0x80FFFFFF);

  /// Inner shadow cast on the recessed center of the node top surface.
  static const Color nodeInsetShadow = Color(0x40000000);

  // ----- Playground world palette -------------------------------------------
  /// Sky / background tone used for cloud highlights in light mode.
  static const Color skyLight = Color(0xFFCFE5FF);

  /// Sky / background tone used for cloud highlights in dark mode.
  static const Color skyDark = Color(0xFF0E1424);

  /// Foliage green used by trees / bushes.
  static const Color foliageGreen = Color(0xFF3FB37C);

  /// Darker foliage tone for shading the underside of trees / bushes.
  static const Color foliageGreenDark = Color(0xFF1F6F4A);

  /// Brighter foliage tone for lit tops of trees / bushes.
  static const Color foliageGreenLight = Color(0xFF7FD6A8);

  /// Trunk / branch brown used by trees and bridges.
  static const Color trunkBrown = Color(0xFF8B5A2B);

  /// Darker trunk shade for shading.
  static const Color trunkBrownDark = Color(0xFF5A3A1A);

  /// Lighter plank / rope tone.
  static const Color plankLight = Color(0xFFD7A86E);

  /// Mountain stone color used in foreground layers.
  static const Color mountainStone = Color(0xFF9CA3A6);

  /// Mountain stone shadow tone.
  static const Color mountainStoneDark = Color(0xFF5C6168);

  /// Snow-cap highlight color.
  static const Color snowCap = Color(0xFFF4F8FB);

  /// River water color used in light mode.
  static const Color waterLight = Color(0xFF5BA0FF);

  /// River water color used in dark mode.
  static const Color waterDark = Color(0xFF1F4F8A);

  /// River foam highlight color.
  static const Color waterFoam = Color(0xCCFFFFFF);

  /// Cloud body tone (light mode).
  static const Color cloudLight = Color(0xFFFFFFFF);

  /// Cloud body tone (dark mode).
  static const Color cloudDark = Color(0xFF36405A);

  /// Flag accent used by default flags (royal blue).
  static const Color flagRed = Color(0xFFE74C3C);

  /// Sparkle / star particle color.
  static const Color sparkleGold = Color(0xFFFFD980);

  // ----- Building palettes --------------------------------------------------
  /// Academy primary tone (light mode).
  static const Color academyPrimary = Color(0xFF3F7CCC);

  /// Academy highlight tone.
  static const Color academyHighlight = Color(0xFF5BA0FF);

  /// Academy shaded tone.
  static const Color academyShade = Color(0xFF214E83);

  /// Academy roof tone.
  static const Color academyRoof = Color(0xFF1B3B6F);

  /// Library primary tone (light mode).
  static const Color libraryPrimary = Color(0xFFA86B36);

  /// Library highlight tone.
  static const Color libraryHighlight = Color(0xFFD49261);

  /// Library shaded tone.
  static const Color libraryShade = Color(0xFF6E441F);

  /// Library roof tone.
  static const Color libraryRoof = Color(0xFF8B5A2B);

  /// Warm window glow used for completed / unlocked buildings.
  static const Color windowGlow = Color(0xFFFFD580);

  /// Premium building accent (gold trim).
  static const Color buildingGold = Color(0xFFF5C040);

  /// Locked building base tone.
  static const Color buildingLocked = Color(0xFF6B7280);
}
