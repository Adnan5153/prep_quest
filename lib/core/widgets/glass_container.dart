import 'dart:ui';
import 'package:flutter/material.dart';

import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';

/// A foundational glassmorphism surface component for Prep Quest.
///
/// This widget serves as a highly customizable base for cards, dialogs,
/// and other surface-level UI elements. It features adaptive blur,
/// translucent borders, and interactive feedback.
class GlassContainer extends StatefulWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.constraints,
    this.padding,
    this.margin,
    this.alignment,
    this.clipBehavior = Clip.antiAlias,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.gradient,
    this.shadow,
    this.blur,
    this.opacity,
    this.borderOpacity,
    this.enableHover = true,
    this.enableTapAnimation = true,
    this.enableShadow = true,
    this.enableBorder = true,
    this.onTap,
  });

  final Widget child;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final Clip clipBehavior;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Gradient? gradient;
  final List<BoxShadow>? shadow;
  final double? blur;
  final double? opacity;
  final double? borderOpacity;
  final bool enableHover;
  final bool enableTapAnimation;
  final bool enableShadow;
  final bool enableBorder;
  final VoidCallback? onTap;

  @override
  State<GlassContainer> createState() => _GlassContainerState();
}

class _GlassContainerState extends State<GlassContainer> {
  bool _isHovered = false;
  bool _isPressed = false;

  void _handleHover(bool isHovered) {
    if (widget.enableHover && widget.onTap != null) {
      setState(() => _isHovered = isHovered);
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enableTapAnimation && widget.onTap != null) {
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enableTapAnimation && widget.onTap != null) {
      setState(() => _isPressed = false);
    }
  }

  void _handleTapCancel() {
    if (widget.enableTapAnimation && widget.onTap != null) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final double effectiveBlur = widget.blur ?? 12.0;
    final double effectiveOpacity = widget.opacity ?? (isDark ? 0.1 : 0.6);
    final double effectiveBorderOpacity =
        widget.borderOpacity ?? (isDark ? 0.15 : 0.3);

    final Color effectiveBaseColor =
        widget.backgroundColor ?? (isDark ? Colors.black : Colors.white);

    final Color effectiveBorderColor =
        widget.borderColor ?? (isDark ? Colors.white : Colors.black);

    final BorderRadiusGeometry effectiveRadius =
        widget.borderRadius ?? BorderRadius.circular(AppRadius.lg);

    final double scale = _isPressed ? 0.98 : (_isHovered ? 1.02 : 1.0);

    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          child: Container(
            width: widget.width,
            height: widget.height,
            constraints: widget.constraints,
            margin: widget.margin,
            alignment: widget.alignment,
            child: _buildGlassEffect(
              theme: theme,
              effectiveBlur: effectiveBlur,
              effectiveRadius: effectiveRadius,
              effectiveBaseColor: effectiveBaseColor,
              effectiveOpacity: effectiveOpacity,
              effectiveBorderColor: effectiveBorderColor,
              effectiveBorderOpacity: effectiveBorderOpacity,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassEffect({
    required ThemeData theme,
    required double effectiveBlur,
    required BorderRadiusGeometry effectiveRadius,
    required Color effectiveBaseColor,
    required double effectiveOpacity,
    required Color effectiveBorderColor,
    required double effectiveBorderOpacity,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: effectiveRadius,
        boxShadow: (widget.enableShadow && widget.shadow == null)
            ? [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: _isHovered ? 0.15 : 0.08,
                  ),
                  blurRadius: _isHovered ? 20 : 10,
                  offset: Offset(0, _isHovered ? 8 : 4),
                ),
              ]
            : widget.shadow,
      ),
      child: ClipRRect(
        borderRadius: effectiveRadius,
        clipBehavior: widget.clipBehavior,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: effectiveBlur,
            sigmaY: effectiveBlur,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: widget.padding ?? const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: effectiveBaseColor.withValues(alpha: effectiveOpacity),
              borderRadius: effectiveRadius,
              gradient: widget.gradient,
              border: widget.enableBorder
                  ? Border.all(
                      color: effectiveBorderColor.withValues(
                        alpha: effectiveBorderOpacity,
                      ),
                      width: AppSizes.borderThin,
                    )
                  : null,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
