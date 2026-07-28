import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';

/// Predefined styles for the [PremiumBadge].
enum PremiumBadgeStyle {
  gold,
  amber,
  gradient,
  outlined,
  filled,
  glass,
  pill,
  compact,
}

/// A premium badge widget inspired by modern SaaS applications.
///
/// Communicates premium content, subscriptions, VIP features, or achievements.
/// Highly customizable and responsive across all screen sizes.
class PremiumBadge extends StatefulWidget {
  const PremiumBadge({
    super.key,
    this.label = 'PREMIUM',
    this.icon = Icons.workspace_premium_rounded,
    this.iconSize,
    this.showIcon = true,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.gradient,
    this.padding,
    this.margin,
    this.borderRadius,
    this.style = PremiumBadgeStyle.gradient,
    this.animate = true,
    this.shadow = true,
    this.outlined = false,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final double? iconSize;
  final bool showIcon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final PremiumBadgeStyle style;
  final bool animate;
  final bool shadow;
  final bool outlined;
  final VoidCallback? onTap;

  @override
  State<PremiumBadge> createState() => _PremiumBadgeState();
}

class _PremiumBadgeState extends State<PremiumBadge> {
  bool _isHovered = false;
  bool _isPressed = false;

  void _handleHover(bool isHovered) {
    if (widget.animate && widget.onTap != null) {
      setState(() => _isHovered = isHovered);
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.animate && widget.onTap != null) {
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.animate && widget.onTap != null) {
      setState(() => _isPressed = false);
    }
  }

  void _handleTapCancel() {
    if (widget.animate && widget.onTap != null) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final double scale = _isPressed ? 0.95 : (_isHovered ? 1.05 : 1.0);

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
          scale: widget.animate ? scale : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            margin: widget.margin,
            child: _buildBadge(theme, isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(ThemeData theme, bool isDark) {
    final styleConfig = _getStyleConfig(theme, isDark);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding:
          widget.padding ??
          EdgeInsets.symmetric(
            horizontal: widget.style == PremiumBadgeStyle.compact
                ? AppSpacing.xs
                : AppSpacing.sm,
            vertical: AppSpacing.xxs,
          ),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? styleConfig.backgroundColor,
        gradient: widget.gradient ?? styleConfig.gradient,
        borderRadius: widget.borderRadius ?? styleConfig.borderRadius,
        border: (widget.outlined || styleConfig.forceOutline)
            ? Border.all(
                color: widget.borderColor ?? styleConfig.borderColor,
                width: 1.0,
              )
            : null,
        boxShadow: (widget.shadow && styleConfig.showShadow)
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showIcon) ...[
            Icon(
              widget.icon,
              size:
                  widget.iconSize ??
                  (widget.style == PremiumBadgeStyle.compact ? 12 : 14),
              color: widget.textColor ?? styleConfig.textColor,
            ),
            const SizedBox(width: AppSpacing.xxs),
          ],
          Text(
            widget.label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: widget.textColor ?? styleConfig.textColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              fontSize: widget.style == PremiumBadgeStyle.compact ? 9 : 10,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeStyleConfig _getStyleConfig(ThemeData theme, bool isDark) {
    switch (widget.style) {
      case PremiumBadgeStyle.gold:
        return _BadgeStyleConfig(
          backgroundColor: const Color(0xFFFFD700),
          textColor: Colors.black87,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        );
      case PremiumBadgeStyle.amber:
        return _BadgeStyleConfig(
          backgroundColor: AppColors.accent,
          textColor: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        );
      case PremiumBadgeStyle.gradient:
        return _BadgeStyleConfig(
          gradient: const LinearGradient(
            colors: [Color(0xFFF5A623), Color(0xFFF7B733)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          textColor: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        );
      case PremiumBadgeStyle.outlined:
        return _BadgeStyleConfig(
          backgroundColor: Colors.transparent,
          borderColor: isDark ? AppColors.accent : AppColors.primary,
          textColor: isDark ? AppColors.accent : AppColors.primary,
          forceOutline: true,
          showShadow: false,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        );
      case PremiumBadgeStyle.filled:
        return _BadgeStyleConfig(
          backgroundColor: theme.colorScheme.primary,
          textColor: theme.colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        );
      case PremiumBadgeStyle.glass:
        return _BadgeStyleConfig(
          backgroundColor: (isDark ? Colors.white : Colors.black).withValues(
            alpha: 0.1,
          ),
          textColor: isDark ? Colors.white : Colors.black87,
          borderColor: (isDark ? Colors.white : Colors.black).withValues(
            alpha: 0.2,
          ),
          forceOutline: true,
          showShadow: false,
          borderRadius: BorderRadius.circular(AppRadius.md),
        );
      case PremiumBadgeStyle.pill:
        return _BadgeStyleConfig(
          backgroundColor: AppColors.accent,
          textColor: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        );
      case PremiumBadgeStyle.compact:
        return _BadgeStyleConfig(
          backgroundColor: AppColors.accent.withValues(alpha: 0.9),
          textColor: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xs),
          showShadow: false,
        );
    }
  }
}

class _BadgeStyleConfig {
  const _BadgeStyleConfig({
    this.backgroundColor,
    this.gradient,
    this.textColor = Colors.black,
    this.borderColor = Colors.transparent,
    this.forceOutline = false,
    this.showShadow = true,
    required this.borderRadius,
  });

  final Color? backgroundColor;
  final Gradient? gradient;
  final Color textColor;
  final Color borderColor;
  final bool forceOutline;
  final bool showShadow;
  final BorderRadiusGeometry borderRadius;
}
