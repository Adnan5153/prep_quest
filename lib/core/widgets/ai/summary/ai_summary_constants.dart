import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../ai_constants.dart';

class AiSummaryConstants {
  const AiSummaryConstants._();

  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color darkSurface = Color(0xFF15171F);
  static const Color lightBorder = Color(0xFFE0E7FF);
  static const Color darkBorder = Color(0xFF2A2D55);

  static const Gradient lightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFFFFFFFF), Color(0xFFF6F7FB)],
  );

  static const Gradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF1B1E2E), Color(0xFF14162A)],
  );

  static const Gradient accentStripGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      AiConstants.aiViolet,
      AiConstants.aiPurple,
      AiConstants.aiCyan,
    ],
  );

  static const Color defaultAccent = AiConstants.aiViolet;
  static const Color briefAccent = AiConstants.aiCyan;
  static const Color deepDiveAccent = AiConstants.aiIndigo;
  static const Color tipAccent = AiConstants.aiPurple;
  static const Color warningAccent = Color(0xFFF59E0B);

  static const double accentStripWidth = AppSizes.borderThick * 2;
  static const double headerAvatarSize = 36.0;
  static const double headerIconSize = AppSizes.iconSm;
  static const double badgeHeight = 24.0;
  static const double footerIconSize = AppSizes.iconSm;
  static const double maxCardWidth = 720.0;
  static const double compactBreakpoint = AppSizes.mobileMaxWidth;

  static const double cardRadius = AppRadius.lg;
  static const double sectionRadius = AppRadius.md;
  static const double pillRadius = AppRadius.pill;
  static const double tagRadius = AppRadius.pill;

  static const double gapXxs = AppSpacing.xxs;
  static const double gapXs = AppSpacing.xs;
  static const double gapSm = AppSpacing.sm;
  static const double gapMd = AppSpacing.md;
  static const double gapLg = AppSpacing.lg;
  static const double gapXl = AppSpacing.xl;
  static const double gapXxl = AppSpacing.xxl;

  static const EdgeInsets comfortablePadding = EdgeInsets.all(AppSpacing.xl);
  static const EdgeInsets compactPadding = EdgeInsets.all(AppSpacing.lg);
  static const double sectionGap = AppSpacing.lg;
  static const double listItemGap = AppSpacing.sm;
  static const double tagGap = AppSpacing.xs;

  static const Duration hoverDuration = Duration(milliseconds: 180);
  static const Duration pressDuration = Duration(milliseconds: 100);
  static const Duration expandDuration = Duration(milliseconds: 320);

  static List<BoxShadow> floatingShadow(Color tint) => <BoxShadow>[
    BoxShadow(
      color: tint.withValues(alpha: 0.14),
      blurRadius: 24,
      spreadRadius: -4,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: tint.withValues(alpha: 0.06),
      blurRadius: 8,
      spreadRadius: 0,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> hoverShadow(Color tint) => <BoxShadow>[
    BoxShadow(
      color: tint.withValues(alpha: 0.28),
      blurRadius: 32,
      spreadRadius: -2,
      offset: const Offset(0, 16),
    ),
    BoxShadow(
      color: tint.withValues(alpha: 0.10),
      blurRadius: 12,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];
}

enum AiSummaryTone { summary, brief, deepDive, tip, warning }
