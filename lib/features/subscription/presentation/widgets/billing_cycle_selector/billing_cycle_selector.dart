import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';

/// User-selectable billing cycles. Mirrors the values that the
/// SubscriptionPlanEntity encodes as `billingCycleMonths`.
enum BillingCycle { monthly, quarterly, yearly }

extension BillingCycleX on BillingCycle {
  int get months {
    switch (this) {
      case BillingCycle.monthly:
        return 1;
      case BillingCycle.quarterly:
        return 3;
      case BillingCycle.yearly:
        return 12;
    }
  }

  String get label {
    switch (this) {
      case BillingCycle.monthly:
        return 'Monthly';
      case BillingCycle.quarterly:
        return 'Quarterly';
      case BillingCycle.yearly:
        return 'Yearly';
    }
  }
}

/// Three-segment billing cycle selector. When `compact` is true the
/// widget collapses to an inline pill row that can sit inside a plan
/// card without dominating the layout.
class BillingCycleSelector extends StatelessWidget {
  const BillingCycleSelector({
    super.key,
    required this.selected,
    required this.onChanged,
    this.compact = false,
    this.inverseForeground = false,
  });

  final BillingCycle selected;
  final ValueChanged<BillingCycle> onChanged;
  final bool compact;
  final bool inverseForeground;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final BillingCycle cycle in BillingCycle.values)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: _Pill(
                label: cycle.label,
                selected: cycle == selected,
                onTap: () => onChanged(cycle),
                inverse: inverseForeground,
              ),
            ),
        ],
      );
    }
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final BillingCycle cycle in BillingCycle.values)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(cycle),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: cycle == selected
                        ? (inverseForeground ? Colors.white : theme.colorScheme.primary)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    cycle.label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: cycle == selected
                          ? (inverseForeground ? AppColors.accent : theme.colorScheme.onPrimary)
                          : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.inverse,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool inverse;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected
              ? (inverse ? Colors.white : theme.colorScheme.primary)
              : theme.colorScheme.onSurface.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: selected
                ? (inverse ? AppColors.accent : theme.colorScheme.onPrimary)
                : theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
