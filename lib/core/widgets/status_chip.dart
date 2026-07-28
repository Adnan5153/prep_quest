import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';

/// Predefined status types for [StatusChip].
enum StatusChipStatus {
  success,
  warning,
  error,
  info,
  premium,
  locked,
  completed,
  pending,
  inProgress,
  newStatus,
  live,
  offline,
  online,
  expired,
}

/// Predefined visual variants for [StatusChip].
enum StatusChipVariant { filled, outlined, glass, gradient, soft, pill }

/// Predefined sizes for [StatusChip].
enum StatusChipSize { small, medium, large }

/// A highly reusable, responsive status chip widget.
///
/// Displays the current state of content, users, or tasks.
class StatusChip extends StatefulWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.status = StatusChipStatus.info,
    this.variant = StatusChipVariant.soft,
    this.size = StatusChipSize.medium,
    this.icon,
    this.showIcon = true,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.gradient,
    this.padding,
    this.margin,
    this.borderRadius,
    this.textStyle,
    this.animate = true,
    this.pulse = false,
    this.onTap,
    this.tooltip,
    this.semanticLabel,
  });

  final String label;
  final StatusChipStatus status;
  final StatusChipVariant variant;
  final StatusChipSize size;
  final IconData? icon;
  final bool showIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final TextStyle? textStyle;
  final bool animate;
  final bool pulse;
  final VoidCallback? onTap;
  final String? tooltip;
  final String? semanticLabel;

  @override
  State<StatusChip> createState() => _StatusChipState();
}

class _StatusChipState extends State<StatusChip>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late AnimationController? _pulseController;

  @override
  void initState() {
    super.initState();
    if (widget.pulse) {
      _pulseController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      )..repeat(reverse: true);
    } else {
      _pulseController = null;
    }
  }

  @override
  void dispose() {
    _pulseController?.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool value) {
    if (widget.animate && widget.onTap != null) {
      setState(() => _isHovered = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final config = _getChipConfig(theme, isDark);

    final double scale = _isPressed ? 0.95 : (_isHovered ? 1.05 : 1.0);

    Widget chip = MouseRegion(
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
          scale: widget.animate ? scale : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            margin: widget.margin,
            child: _buildBody(theme, config),
          ),
        ),
      ),
    );

    if (widget.pulse && _pulseController != null) {
      chip = AnimatedBuilder(
        animation: _pulseController!,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                widget.borderRadius ?? config.borderRadius,
              ),
              boxShadow: [
                BoxShadow(
                  color: config.backgroundColor.withValues(
                    alpha: 0.4 * (1 - _pulseController!.value),
                  ),
                  blurRadius: 8 * _pulseController!.value,
                  spreadRadius: 4 * _pulseController!.value,
                ),
              ],
            ),
            child: child,
          );
        },
        child: chip,
      );
    }

    if (widget.tooltip != null) {
      chip = Tooltip(message: widget.tooltip!, child: chip);
    }

    if (widget.semanticLabel != null) {
      chip = Semantics(label: widget.semanticLabel, child: chip);
    }

    return chip;
  }

  Widget _buildBody(ThemeData theme, _ChipConfig config) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: widget.padding ?? config.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? config.backgroundColor,
        gradient: widget.variant == StatusChipVariant.gradient
            ? (widget.gradient ?? config.gradient)
            : null,
        borderRadius: BorderRadius.circular(
          widget.borderRadius ?? config.borderRadius,
        ),
        border:
            (widget.variant == StatusChipVariant.outlined ||
                config.forceOutline)
            ? Border.all(
                color: widget.borderColor ?? config.borderColor!,
                width: widget.borderWidth ?? 1.0,
              )
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showIcon) ...[
            Icon(
              widget.icon ?? config.icon,
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
        ],
      ),
    );
  }

  _ChipConfig _getChipConfig(ThemeData theme, bool isDark) {
    Color baseColor = _getStatusColor(widget.status, isDark);
    Color bgColor;
    Color fgColor;
    Color? borderColor;
    Gradient? gradient;
    bool forceOutline = false;

    switch (widget.variant) {
      case StatusChipVariant.filled:
        bgColor = baseColor;
        fgColor = Colors.white;
      case StatusChipVariant.outlined:
        bgColor = Colors.transparent;
        fgColor = baseColor;
        borderColor = baseColor;
      case StatusChipVariant.glass:
        bgColor = baseColor.withValues(alpha: 0.1);
        fgColor = isDark ? Colors.white : baseColor;
        borderColor = baseColor.withValues(alpha: 0.2);
        forceOutline = true;
      case StatusChipVariant.gradient:
        bgColor = Colors.transparent;
        fgColor = Colors.white;
        gradient = LinearGradient(
          colors: [baseColor, baseColor.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case StatusChipVariant.soft:
        bgColor = baseColor.withValues(alpha: 0.12);
        fgColor = baseColor;
      case StatusChipVariant.pill:
        bgColor = baseColor;
        fgColor = Colors.white;
    }

    double iconSize;
    EdgeInsets padding;
    TextStyle textStyle;
    double radius = widget.variant == StatusChipVariant.pill
        ? AppRadius.pill
        : AppRadius.xs;

    switch (widget.size) {
      case StatusChipSize.small:
        iconSize = 12;
        padding = const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: 2,
        );
        textStyle = theme.textTheme.labelSmall!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 10,
        );
      case StatusChipSize.medium:
        iconSize = 14;
        padding = const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 4,
        );
        textStyle = theme.textTheme.labelMedium!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        );
      case StatusChipSize.large:
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
      icon: _getStatusIcon(widget.status),
      iconSize: iconSize,
      forceOutline: forceOutline,
    );
  }

  Color _getStatusColor(StatusChipStatus status, bool isDark) {
    switch (status) {
      case StatusChipStatus.success:
      case StatusChipStatus.completed:
      case StatusChipStatus.online:
        return AppColors.success;
      case StatusChipStatus.warning:
      case StatusChipStatus.pending:
        return AppColors.warning;
      case StatusChipStatus.error:
      case StatusChipStatus.expired:
      case StatusChipStatus.offline:
        return AppColors.error;
      case StatusChipStatus.info:
      case StatusChipStatus.inProgress:
        return AppColors.info;
      case StatusChipStatus.premium:
        return AppColors.accent;
      case StatusChipStatus.locked:
        return isDark ? AppColors.darkMuted : AppColors.lightMuted;
      case StatusChipStatus.newStatus:
      case StatusChipStatus.live:
        return AppColors.primary;
    }
  }

  IconData _getStatusIcon(StatusChipStatus status) {
    switch (status) {
      case StatusChipStatus.success:
      case StatusChipStatus.completed:
        return Icons.check_circle_rounded;
      case StatusChipStatus.warning:
        return Icons.warning_amber_rounded;
      case StatusChipStatus.error:
      case StatusChipStatus.expired:
        return Icons.error_outline_rounded;
      case StatusChipStatus.info:
        return Icons.info_outline_rounded;
      case StatusChipStatus.premium:
        return Icons.workspace_premium_rounded;
      case StatusChipStatus.locked:
        return Icons.lock_outline_rounded;
      case StatusChipStatus.pending:
        return Icons.history_rounded;
      case StatusChipStatus.inProgress:
        return Icons.sync_rounded;
      case StatusChipStatus.newStatus:
        return Icons.fiber_new_rounded;
      case StatusChipStatus.live:
        return Icons.sensors_rounded;
      case StatusChipStatus.online:
        return Icons.circle;
      case StatusChipStatus.offline:
        return Icons.circle_outlined;
    }
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
    required this.icon,
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
  final IconData icon;
  final double iconSize;
  final bool forceOutline;
}
