import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';

/// Predefined variants for the [PrimaryButton].
enum PrimaryButtonVariant { filled, gradient, outlined, tonal }

/// Predefined sizes for the [PrimaryButton].
enum PrimaryButtonSize { small, medium, large }

/// Predefined shapes for the [PrimaryButton].
enum PrimaryButtonShape { rounded, pill, rectangle }

/// A highly reusable, responsive primary button widget.
///
/// Designed as the default Call-To-Action (CTA) component across the application.
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = PrimaryButtonVariant.filled,
    this.size = PrimaryButtonSize.medium,
    this.shape = PrimaryButtonShape.rounded,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.icon,
    this.trailingIcon,
    this.iconSize,
    this.iconColor,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.gradient,
    this.borderRadius,
    this.textStyle,
    this.isLoading = false,
    this.isEnabled = true,
    this.fullWidth = false,
    this.elevation = 0,
    this.tooltip,
    this.semanticLabel,
  });

  final String text;
  final VoidCallback? onPressed;
  final PrimaryButtonVariant variant;
  final PrimaryButtonSize size;
  final PrimaryButtonShape shape;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final IconData? icon;
  final IconData? trailingIcon;
  final double? iconSize;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final Gradient? gradient;
  final double? borderRadius;
  final TextStyle? textStyle;
  final bool isLoading;
  final bool isEnabled;
  final bool fullWidth;
  final double elevation;
  final String? tooltip;
  final String? semanticLabel;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  void _onHoverChanged(bool value) {
    if (widget.isEnabled && !widget.isLoading) {
      setState(() => _isHovered = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bool effectivelyEnabled =
        widget.isEnabled && !widget.isLoading && widget.onPressed != null;

    final config = _getButtonConfig(theme, isDark, effectivelyEnabled);

    Widget content = Semantics(
      label: widget.semanticLabel ?? widget.text,
      button: true,
      enabled: effectivelyEnabled,
      child: AnimatedScale(
        scale: _isPressed && effectivelyEnabled ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: MouseRegion(
          onEnter: (_) => _onHoverChanged(true),
          onExit: (_) => _onHoverChanged(false),
          cursor: effectivelyEnabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            onTap: effectivelyEnabled ? widget.onPressed : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.fullWidth ? double.infinity : widget.width,
              height: widget.height ?? config.height,
              margin: widget.margin,
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? config.backgroundColor,
                gradient: widget.variant == PrimaryButtonVariant.gradient
                    ? (widget.gradient ?? config.gradient)
                    : null,
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? config.borderRadius,
                ),
                border: widget.variant == PrimaryButtonVariant.outlined
                    ? Border.all(
                        color: widget.borderColor ?? config.borderColor!,
                        width: 1.5,
                      )
                    : null,
                boxShadow: widget.elevation > 0 && effectivelyEnabled
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: widget.elevation * 2,
                          offset: Offset(0, widget.elevation),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: effectivelyEnabled ? widget.onPressed : null,
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? config.borderRadius,
                  ),
                  splashColor: config.foregroundColor.withValues(alpha: 0.12),
                  highlightColor: config.foregroundColor.withValues(
                    alpha: 0.04,
                  ),
                  child: Padding(
                    padding: widget.padding ?? config.padding,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.isLoading)
                          _buildLoader(config.foregroundColor)
                        else ...[
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              size: widget.iconSize ?? config.iconSize,
                              color: widget.iconColor ?? config.foregroundColor,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                          ],
                          Text(
                            widget.text,
                            textAlign: TextAlign.center,
                            style:
                                widget.textStyle ??
                                config.textStyle.copyWith(
                                  color:
                                      widget.foregroundColor ??
                                      config.foregroundColor,
                                ),
                          ),
                          if (widget.trailingIcon != null) ...[
                            const SizedBox(width: AppSpacing.sm),
                            Icon(
                              widget.trailingIcon,
                              size: widget.iconSize ?? config.iconSize,
                              color: widget.iconColor ?? config.foregroundColor,
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      content = Tooltip(message: widget.tooltip!, child: content);
    }

    return content;
  }

  Widget _buildLoader(Color color) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  _ButtonConfig _getButtonConfig(ThemeData theme, bool isDark, bool enabled) {
    double height;
    double iconSize;
    EdgeInsets padding;
    TextStyle textStyle;

    switch (widget.size) {
      case PrimaryButtonSize.small:
        height = 36;
        iconSize = 16;
        padding = const EdgeInsets.symmetric(horizontal: AppSpacing.md);
        textStyle = theme.textTheme.labelLarge!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        );
      case PrimaryButtonSize.medium:
        height = 48;
        iconSize = 20;
        padding = const EdgeInsets.symmetric(horizontal: AppSpacing.lg);
        textStyle = theme.textTheme.titleSmall!.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 15,
        );
      case PrimaryButtonSize.large:
        height = 56;
        iconSize = 24;
        padding = const EdgeInsets.symmetric(horizontal: AppSpacing.xl);
        textStyle = theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: 17,
        );
    }

    double borderRadius;
    switch (widget.shape) {
      case PrimaryButtonShape.rounded:
        borderRadius = AppRadius.md;
      case PrimaryButtonShape.pill:
        borderRadius = AppRadius.pill;
      case PrimaryButtonShape.rectangle:
        borderRadius = 0;
    }

    Color bgColor;
    Color fgColor;
    Color? borderColor;
    Gradient? gradient;

    if (!enabled) {
      bgColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
      fgColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
      borderColor = isDark
          ? AppColors.darkMuted.withValues(alpha: 0.2)
          : AppColors.lightMuted.withValues(alpha: 0.2);
    } else {
      switch (widget.variant) {
        case PrimaryButtonVariant.filled:
          bgColor = AppColors.primary;
          fgColor = Colors.white;
        case PrimaryButtonVariant.gradient:
          bgColor = Colors.transparent;
          fgColor = Colors.white;
          gradient = const LinearGradient(
            colors: [AppColors.primary, Color(0xFF16A085)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          );
        case PrimaryButtonVariant.outlined:
          bgColor = Colors.transparent;
          fgColor = AppColors.primary;
          borderColor = AppColors.primary;
        case PrimaryButtonVariant.tonal:
          bgColor = AppColors.primary.withValues(alpha: 0.1);
          fgColor = AppColors.primary;
      }
    }

    if (_isHovered && enabled) {
      if (widget.variant == PrimaryButtonVariant.filled) {
        bgColor = bgColor.withValues(alpha: 0.9);
      } else if (widget.variant == PrimaryButtonVariant.tonal) {
        bgColor = bgColor.withValues(alpha: 0.15);
      }
    }

    return _ButtonConfig(
      height: height,
      iconSize: iconSize,
      padding: padding,
      textStyle: textStyle,
      borderRadius: borderRadius,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      borderColor: borderColor,
      gradient: gradient,
    );
  }
}

class _ButtonConfig {
  const _ButtonConfig({
    required this.height,
    required this.iconSize,
    required this.padding,
    required this.textStyle,
    required this.borderRadius,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
    this.gradient,
  });

  final double height;
  final double iconSize;
  final EdgeInsets padding;
  final TextStyle textStyle;
  final double borderRadius;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final Gradient? gradient;
}
