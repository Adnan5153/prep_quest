import 'package:flutter/material.dart';

import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';

/// Animated unread-count badge that overlays a small circular surface.
///
/// Designed to sit on the top-right corner of any icon (bell, profile
/// avatar, list row, etc.). When [count] is `0` the badge hides itself
/// without taking layout space. Updates animate in with a subtle
/// scale-and-fade so consumers don't have to wire a Tween manually.
class NotificationBadge extends StatelessWidget {
  const NotificationBadge({
    super.key,
    required this.count,
    this.maxCount = 99,
    this.color,
    this.textColor,
    this.size = AppSizes.minTapTarget * 0.45,
    this.showZero = false,
  });

  final int count;
  final int maxCount;
  final Color? color;
  final Color? textColor;
  final double size;
  final bool showZero;

  bool get _isVisible => showZero ? count >= 0 : count > 0;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();
    final ThemeData theme = Theme.of(context);
    final Color effectiveColor = color ?? theme.colorScheme.error;
    final Color effectiveTextColor =
        textColor ?? theme.colorScheme.onPrimary;
    final String label = count > maxCount ? '$maxCount+' : '$count';

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.6, end: 1),
      duration: const Duration(milliseconds: 280),
      curve: Curves.elasticOut,
      builder: (BuildContext context, double value, Widget? child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        constraints: BoxConstraints(
          minWidth: size,
          minHeight: size,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: effectiveColor,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: theme.colorScheme.surface,
            width: AppSizes.borderThin,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: effectiveTextColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}