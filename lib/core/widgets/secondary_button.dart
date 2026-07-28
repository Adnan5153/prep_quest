import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';

/// Predefined variants for the [SecondaryButton].
enum SecondaryButtonVariant { outlined, tonal, text, glass }

/// Predefined sizes for the [SecondaryButton].
enum SecondaryButtonSize { small, medium, large }

/// Predefined shapes for the [SecondaryButton].
enum SecondaryButtonShape { rounded, pill, rectangle }

/// A reusable responsive secondary button widget.
///
/// Designed to complement the [PrimaryButton] for secondary actions
/// like Cancel, Skip, Back, or alternative navigation.
class SecondaryButton extends StatefulWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = SecondaryButtonVariant.outlined,
    this.size = SecondaryButtonSize.medium,
    this.shape = SecondaryButtonShape.rounded,
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
    this.borderWidth,
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
  final SecondaryButtonVariant variant;
  final SecondaryButtonSize size;
  final SecondaryButtonShape shape;
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
  final double? borderWidth;
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
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
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
        scale: _isPressed && effectivelyEnabled ? 0.97 : 1.0,
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
                gradient: widget.gradient ?? config.gradient,
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? config.borderRadius,
                ),
                border: config.borderColor != null
                    ? Border.all(
                        color: widget.borderColor ?? config.borderColor!,
                        width: widget.borderWidth ?? 1.0,
                      )
                    : null,
                boxShadow: widget.elevation > 0 && effectivelyEnabled
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
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
                  splashColor: config.foregroundColor.withValues(alpha: 0.1),
                  highlightColor: config.foregroundColor.withValues(
                    alpha: 0.05,
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
      width: 18,
      height: 18,
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
      case SecondaryButtonSize.small:
        height = 32;
        iconSize = 14;
        padding = const EdgeInsets.symmetric(horizontal: AppSpacing.sm);
        textStyle = theme.textTheme.labelLarge!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        );
      case SecondaryButtonSize.medium:
        height = 44;
        iconSize = 18;
        padding = const EdgeInsets.symmetric(horizontal: AppSpacing.md);
        textStyle = theme.textTheme.titleSmall!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        );
      case SecondaryButtonSize.large:
        height = 52;
        iconSize = 22;
        padding = const EdgeInsets.symmetric(horizontal: AppSpacing.lg);
        textStyle = theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 16,
        );
    }

    double borderRadius;
    switch (widget.shape) {
      case SecondaryButtonShape.rounded:
        borderRadius = AppRadius.sm;
      case SecondaryButtonShape.pill:
        borderRadius = AppRadius.pill;
      case SecondaryButtonShape.rectangle:
        borderRadius = 0;
    }

    Color bgColor;
    Color fgColor;
    Color? borderColor;
    Gradient? gradient;

    if (!enabled) {
      bgColor = Colors.transparent;
      fgColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
      borderColor = isDark
          ? AppColors.darkMuted.withValues(alpha: 0.15)
          : AppColors.lightMuted.withValues(alpha: 0.15);
    } else {
      switch (widget.variant) {
        case SecondaryButtonVariant.outlined:
          bgColor = Colors.transparent;
          fgColor = theme.colorScheme.secondary;
          borderColor = theme.colorScheme.secondary.withValues(alpha: 0.5);
        case SecondaryButtonVariant.tonal:
          bgColor = theme.colorScheme.secondaryContainer.withValues(alpha: 0.3);
          fgColor = theme.colorScheme.onSecondaryContainer;
        case SecondaryButtonVariant.text:
          bgColor = Colors.transparent;
          fgColor = theme.colorScheme.secondary;
        case SecondaryButtonVariant.glass:
          bgColor = (isDark ? Colors.white : Colors.black).withValues(
            alpha: 0.05,
          );
          fgColor = isDark ? Colors.white : Colors.black87;
          borderColor = (isDark ? Colors.white : Colors.black).withValues(
            alpha: 0.1,
          );
      }
    }

    if (_isHovered && enabled) {
      if (widget.variant == SecondaryButtonVariant.tonal) {
        bgColor = bgColor.withValues(alpha: 0.4);
      } else if (widget.variant == SecondaryButtonVariant.text ||
          widget.variant == SecondaryButtonVariant.outlined) {
        bgColor = theme.colorScheme.secondary.withValues(alpha: 0.05);
      } else if (widget.variant == SecondaryButtonVariant.glass) {
        bgColor = bgColor.withValues(alpha: 0.08);
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
