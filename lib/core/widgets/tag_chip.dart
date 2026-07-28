import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';

/// Predefined visual variants for [TagChip].
enum TagChipVariant { filled, outlined, soft, gradient, glass, tonal }

/// Predefined sizes for [TagChip].
enum TagChipSize { small, medium, large }

/// Predefined shapes for [TagChip].
enum TagChipShape { rounded, pill, rectangle }

/// A highly reusable, responsive tag chip widget.
///
/// Displays tags, categories, labels, or filters with multiple styles.
class TagChip extends StatefulWidget {
  const TagChip({
    super.key,
    required this.label,
    this.icon,
    this.trailingIcon,
    this.variant = TagChipVariant.soft,
    this.size = TagChipSize.medium,
    this.shape = TagChipShape.pill,
    this.selected = false,
    this.enabled = true,
    this.closable = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.gradient,
    this.glass = false,
    this.padding,
    this.margin,
    this.borderRadius,
    this.textStyle,
    this.tooltip,
    this.semanticLabel,
    this.onTap,
    this.onSelected,
    this.onDeleted,
  });

  final String label;
  final IconData? icon;
  final IconData? trailingIcon;
  final TagChipVariant variant;
  final TagChipSize size;
  final TagChipShape shape;
  final bool selected;
  final bool enabled;
  final bool closable;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final Gradient? gradient;
  final bool glass;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final TextStyle? textStyle;
  final String? tooltip;
  final String? semanticLabel;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onSelected;
  final VoidCallback? onDeleted;

  @override
  State<TagChip> createState() => _TagChipState();
}

class _TagChipState extends State<TagChip> {
  bool _isHovered = false;
  bool _isPressed = false;

  void _onHoverChanged(bool value) {
    if (widget.enabled) {
      setState(() => _isHovered = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final config = _getChipConfig(theme, isDark);

    final double scale = _isPressed ? 0.96 : (_isHovered ? 1.04 : 1.0);

    Widget chip = MouseRegion(
      onEnter: (_) => _onHoverChanged(true),
      onExit: (_) => _onHoverChanged(false),
      cursor:
          widget.enabled && (widget.onTap != null || widget.onSelected != null)
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: (_) =>
            widget.enabled ? setState(() => _isPressed = true) : null,
        onTapUp: (_) =>
            widget.enabled ? setState(() => _isPressed = false) : null,
        onTapCancel: () =>
            widget.enabled ? setState(() => _isPressed = false) : null,
        onTap: widget.enabled
            ? () {
                widget.onTap?.call();
                widget.onSelected?.call(!widget.selected);
              }
            : null,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 150),
          child: Container(
            margin: widget.margin,
            child: _buildBody(theme, config),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      chip = Tooltip(message: widget.tooltip!, child: chip);
    }

    if (widget.semanticLabel != null || widget.label.isNotEmpty) {
      chip = Semantics(
        label: widget.semanticLabel ?? widget.label,
        selected: widget.selected,
        enabled: widget.enabled,
        child: chip,
      );
    }

    return chip;
  }

  Widget _buildBody(ThemeData theme, _ChipConfig config) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: widget.padding ?? config.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? config.backgroundColor,
        gradient: (widget.variant == TagChipVariant.gradient || widget.selected)
            ? (widget.gradient ?? config.gradient)
            : null,
        borderRadius: BorderRadius.circular(
          widget.borderRadius ?? config.borderRadius,
        ),
        border:
            (widget.variant == TagChipVariant.outlined || config.forceOutline)
            ? Border.all(
                color: widget.borderColor ?? config.borderColor!,
                width: widget.borderWidth ?? 1.0,
              )
            : null,
        boxShadow: _isHovered && widget.enabled
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null || widget.selected) ...[
            Icon(
              widget.selected ? Icons.check_rounded : widget.icon,
              size: config.iconSize,
              color: widget.foregroundColor ?? config.foregroundColor,
            ),
            const SizedBox(width: AppSpacing.xxs),
          ],
          Text(
            widget.label,
            style:
                widget.textStyle ??
                config.textStyle.copyWith(
                  color: widget.foregroundColor ?? config.foregroundColor,
                ),
          ),
          if (widget.trailingIcon != null && !widget.closable) ...[
            const SizedBox(width: AppSpacing.xxs),
            Icon(
              widget.trailingIcon,
              size: config.iconSize,
              color: widget.foregroundColor ?? config.foregroundColor,
            ),
          ],
          if (widget.closable) ...[
            const SizedBox(width: AppSpacing.xxs),
            GestureDetector(
              onTap: widget.enabled ? widget.onDeleted : null,
              child: Icon(
                Icons.close_rounded,
                size: config.iconSize,
                color: (widget.foregroundColor ?? config.foregroundColor)
                    .withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  _ChipConfig _getChipConfig(ThemeData theme, bool isDark) {
    Color baseColor = theme.colorScheme.primary;
    Color bgColor;
    Color fgColor;
    Color? borderColor;
    Gradient? gradient;
    bool forceOutline = false;

    if (!widget.enabled) {
      bgColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
      fgColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
      borderColor = isDark
          ? AppColors.darkMuted.withValues(alpha: 0.2)
          : AppColors.lightMuted.withValues(alpha: 0.2);
      forceOutline = widget.variant == TagChipVariant.outlined;
    } else if (widget.selected) {
      bgColor = baseColor;
      fgColor = Colors.white;
      gradient = LinearGradient(
        colors: [baseColor, baseColor.withValues(alpha: 0.8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      switch (widget.variant) {
        case TagChipVariant.filled:
          bgColor = baseColor;
          fgColor = Colors.white;
        case TagChipVariant.outlined:
          bgColor = Colors.transparent;
          fgColor = baseColor;
          borderColor = baseColor;
        case TagChipVariant.soft:
          bgColor = baseColor.withValues(alpha: 0.1);
          fgColor = baseColor;
        case TagChipVariant.gradient:
          bgColor = Colors.transparent;
          fgColor = Colors.white;
          gradient = const LinearGradient(
            colors: [AppColors.primary, Color(0xFF16A085)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
        case TagChipVariant.glass:
          bgColor = (isDark ? Colors.white : Colors.black).withValues(
            alpha: 0.05,
          );
          fgColor = isDark ? Colors.white : Colors.black87;
          borderColor = (isDark ? Colors.white : Colors.black).withValues(
            alpha: 0.1,
          );
          forceOutline = true;
        case TagChipVariant.tonal:
          bgColor = theme.colorScheme.secondaryContainer.withValues(alpha: 0.5);
          fgColor = theme.colorScheme.onSecondaryContainer;
      }
    }

    double iconSize;
    EdgeInsets padding;
    TextStyle textStyle;
    double radius;

    switch (widget.shape) {
      case TagChipShape.rounded:
        radius = AppRadius.xs;
      case TagChipShape.pill:
        radius = AppRadius.pill;
      case TagChipShape.rectangle:
        radius = 0;
    }

    switch (widget.size) {
      case TagChipSize.small:
        iconSize = 12;
        padding = const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: 2,
        );
        textStyle = theme.textTheme.labelSmall!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 10,
        );
      case TagChipSize.medium:
        iconSize = 14;
        padding = const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 4,
        );
        textStyle = theme.textTheme.labelMedium!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        );
      case TagChipSize.large:
        iconSize = 18;
        padding = const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 6,
        );
        textStyle = theme.textTheme.titleSmall!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        );
    }

    return _ChipConfig(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      borderColor: borderColor,
      gradient: gradient,
      borderRadius: radius,
      padding: padding,
      textStyle: textStyle,
      iconSize: iconSize,
      forceOutline: forceOutline,
    );
  }
}

class _ChipConfig {
  const _ChipConfig({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
    this.gradient,
    required this.borderRadius,
    required this.padding,
    required this.textStyle,
    required this.iconSize,
    this.forceOutline = false,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final Gradient? gradient;
  final double borderRadius;
  final EdgeInsets padding;
  final TextStyle textStyle;
  final double iconSize;
  final bool forceOutline;
}
