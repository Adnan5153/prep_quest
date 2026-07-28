import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/premium_badge.dart';

/// Feature-flavoured wrapper around the core `PremiumBadge` widget
/// that the comparison table, plan cards and current-plan banner all
/// share. Adds consistent sizing, padding and gradient.
class SubscriptionPremiumBadge extends StatelessWidget {
  const SubscriptionPremiumBadge({
    super.key,
    this.label = 'PREMIUM',
    this.style = PremiumBadgeStyle.gradient,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.xxs,
    ),
    this.icon = Icons.workspace_premium_rounded,
    this.animate = true,
  });

  final String label;
  final PremiumBadgeStyle style;
  final EdgeInsetsGeometry padding;
  final IconData icon;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return PremiumBadge(
      label: label,
      style: style,
      icon: icon,
      animate: animate,
      padding: padding,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      backgroundColor: style == PremiumBadgeStyle.filled
          ? AppColors.accent
          : null,
    );
  }
}
