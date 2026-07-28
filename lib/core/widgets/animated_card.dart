import 'dart:ui';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import 'widget_constants.dart';

/// Predefined animation types for [AnimatedCard].
enum CardAnimationType { fade, scale, slide, none }

/// Predefined visual variants for [AnimatedCard].
enum CardVariant { filled, outlined, glass, gradient }

/// A highly customizable and responsive animated card widget.
///
/// Follows the project's design system using centralized constants.
class AnimatedCard extends StatefulWidget {
  const AnimatedCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.footer,
    this.onTap,
    this.animationType = CardAnimationType.scale,
    this.variant = CardVariant.filled,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.backgroundColor,
    this.gradient,
    this.borderRadius,
    this.elevation,
    this.animationDuration,
    this.animationCurve,
    this.enableHover = true,
    this.enablePress = true,
    this.enableGlow = false,
    this.glassEffect = false,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? footer;
  final VoidCallback? onTap;
  final CardAnimationType animationType;
  final CardVariant variant;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double? borderRadius;
  final double? elevation;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final bool enableHover;
  final bool enablePress;
  final bool enableGlow;
  final bool glassEffect;

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  void _onHoverChanged(bool value) {
    if (widget.enableHover) {
      setState(() => _isHovered = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final double effectiveRadius = widget.borderRadius ?? AppRadius.lg;
    final double effectiveElevation =
        widget.elevation ?? WidgetConstants.cardElevation;
    final Duration effectiveDuration =
        widget.animationDuration ?? WidgetConstants.normalAnimationDuration;
    final Curve effectiveCurve =
        widget.animationCurve ?? WidgetConstants.defaultAnimationCurve;

    final double scale = _isPressed && widget.enablePress
        ? WidgetConstants.cardPressScale
        : (_isHovered && widget.enableHover
              ? WidgetConstants.cardHoverScale
              : 1.0);

    return MouseRegion(
      onEnter: (_) => _onHoverChanged(true),
      onExit: (_) => _onHoverChanged(false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: scale,
          duration: WidgetConstants.fastAnimationDuration,
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: effectiveDuration,
            curve: effectiveCurve,
            width: widget.width,
            height: widget.height,
            margin: widget.margin,
            decoration: _buildDecoration(
              isDark,
              effectiveRadius,
              effectiveElevation,
            ),
            child: _buildContent(effectiveRadius),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(bool isDark, double radius, double elevation) {
    final Color baseColor =
        widget.backgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.lightSurface);

    Color borderColor = Colors.transparent;
    if (widget.variant == CardVariant.outlined) {
      borderColor = isDark
          ? AppColors.darkMuted.withValues(
              alpha: WidgetConstants.glassBorderOpacity,
            )
          : AppColors.lightMuted.withValues(
              alpha: WidgetConstants.glassBorderOpacity,
            );
    }

    final List<BoxShadow> shadows = [];
    if (elevation > 0) {
      shadows.add(
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
          blurRadius: elevation * 2,
          offset: Offset(0, elevation),
        ),
      );
    }

    if (widget.enableGlow && _isHovered) {
      shadows.add(WidgetConstants.cardGlowShadow);
    }

    return BoxDecoration(
      color: widget.variant == CardVariant.glass
          ? Colors.transparent
          : baseColor,
      gradient: widget.variant == CardVariant.gradient
          ? (widget.gradient ?? _defaultGradient())
          : null,
      borderRadius: BorderRadius.circular(radius),
      border: widget.variant == CardVariant.outlined
          ? Border.all(
              color: borderColor,
              width: WidgetConstants.defaultBorderWidth,
            )
          : null,
      boxShadow: shadows,
    );
  }

  Gradient _defaultGradient() {
    return const LinearGradient(
      colors: [AppColors.primary, AppColors.secondary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  Widget _buildContent(double radius) {
    Widget body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.title != null ||
            widget.leading != null ||
            widget.trailing != null)
          _buildHeader(),
        Padding(
          padding: widget.padding ?? const EdgeInsets.all(AppSpacing.lg),
          child: widget.child,
        ),
        if (widget.footer != null) widget.footer!,
      ],
    );

    if (widget.variant == CardVariant.glass || widget.glassEffect) {
      body = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: WidgetConstants.glassBlurSigma,
            sigmaY: WidgetConstants.glassBlurSigma,
          ),
          child: Container(
            color:
                (Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : Colors.white)
                    .withValues(alpha: WidgetConstants.glassOpacity),
            child: body,
          ),
        ),
      );
    }

    return body;
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        0,
      ),
      child: Row(
        children: [
          if (widget.leading != null) ...[
            widget.leading!,
            const SizedBox(width: AppSpacing.md),
          ],
          if (widget.title != null)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.subtitle != null)
                    Text(
                      widget.subtitle!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          if (widget.trailing != null) ...[
            const SizedBox(width: AppSpacing.md),
            widget.trailing!,
          ],
        ],
      ),
    );
  }
}
