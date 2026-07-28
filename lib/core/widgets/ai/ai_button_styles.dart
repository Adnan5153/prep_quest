import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';
import 'ai_button_variants.dart';
import 'ai_button_constants.dart';

class AiButtonStyles {
  const AiButtonStyles._();

  static AiButtonStyle resolve(
    BuildContext context, {
    required AiButtonVariant variant,
    required AiButtonSize size,
    required AiButtonState state,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ----- Resolve Size-based properties -----
    double height;
    double iconSize;
    EdgeInsets padding;
    TextStyle textStyle;

    switch (size) {
      case AiButtonSize.small:
        height = 36;
        iconSize = 16;
        padding = const EdgeInsets.symmetric(horizontal: AppSpacing.md);
        textStyle = theme.textTheme.labelLarge!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        );
      case AiButtonSize.medium:
        height = 48;
        iconSize = 20;
        padding = const EdgeInsets.symmetric(horizontal: AppSpacing.lg);
        textStyle = theme.textTheme.titleSmall!.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 15,
        );
      case AiButtonSize.large:
        height = 56;
        iconSize = 24;
        padding = const EdgeInsets.symmetric(horizontal: AppSpacing.xl);
        textStyle = theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: 17,
        );
    }

    // ----- Resolve State-based properties -----
    Color bgColor;
    Color fgColor;
    Color? borderColor;
    Gradient? gradient;
    List<BoxShadow>? shadows;

    if (state == AiButtonState.disabled) {
      bgColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
      fgColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    } else if (state == AiButtonState.premiumLocked) {
      bgColor = AppColors.secondary;
      fgColor = AppColors.accent;
    } else {
      switch (variant) {
        case AiButtonVariant.filled:
          bgColor = AiButtonConstants.aiIndigo;
          fgColor = Colors.white;
        case AiButtonVariant.outlined:
          bgColor = Colors.transparent;
          fgColor = AiButtonConstants.aiIndigo;
          borderColor = AiButtonConstants.aiIndigo;
        case AiButtonVariant.gradient:
          bgColor = Colors.transparent;
          fgColor = Colors.white;
          gradient = AiButtonConstants.primaryGradient;
        case AiButtonVariant.glass:
          bgColor = (isDark ? Colors.white : Colors.black).withValues(
            alpha: 0.05,
          );
          fgColor = isDark ? Colors.white : Colors.black87;
          borderColor = (isDark ? Colors.white : Colors.black).withValues(
            alpha: 0.1,
          );
        case AiButtonVariant.elevated:
          bgColor = isDark ? AppColors.darkSurface : Colors.white;
          fgColor = AiButtonConstants.aiIndigo;
          shadows = AiButtonConstants.glowShadow(AiButtonConstants.aiIndigo);
        case AiButtonVariant.minimal:
          bgColor = Colors.transparent;
          fgColor = AiButtonConstants.aiIndigo;
        case AiButtonVariant.floating:
          bgColor = AiButtonConstants.aiPurple;
          fgColor = Colors.white;
          shadows = AiButtonConstants.glowShadow(AiButtonConstants.aiPurple);
        case AiButtonVariant.iconOnly:
          bgColor = AiButtonConstants.aiIndigo.withValues(alpha: 0.1);
          fgColor = AiButtonConstants.aiIndigo;
          padding = EdgeInsets.zero;
      }
    }

    return AiButtonStyle(
      height: height,
      iconSize: iconSize,
      padding: padding,
      textStyle: textStyle,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      borderColor: borderColor,
      gradient: gradient,
      shadows: shadows,
      borderRadius: AppRadius.md,
    );
  }
}

class AiButtonStyle {
  const AiButtonStyle({
    required this.height,
    required this.iconSize,
    required this.padding,
    required this.textStyle,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
    this.gradient,
    this.shadows,
    required this.borderRadius,
  });

  final double height;
  final double iconSize;
  final EdgeInsets padding;
  final TextStyle textStyle;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final Gradient? gradient;
  final List<BoxShadow>? shadows;
  final double borderRadius;
}
