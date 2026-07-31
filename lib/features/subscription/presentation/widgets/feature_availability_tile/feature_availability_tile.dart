import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../domain/entities/subscription_entity.dart';

/// Single row in the comparison table. Encapsulates the locked/
/// unlocked visual treatment so the table layout stays in one place.
class FeatureAvailabilityTile extends StatelessWidget {
  const FeatureAvailabilityTile({
    super.key,
    required this.feature,
    required this.tier,
    this.showDescription = false,
  });

  final SubscriptionFeatureEntity feature;
  final SubscriptionTier tier;
  final bool showDescription;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool available = _isAvailable(tier);
    final Color tint = available ? AppColors.success : AppColors.lightMuted;
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: <Widget>[
          Container(
            width: AppSizes.iconLg,
            height: AppSizes.iconLg,
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            alignment: Alignment.center,
            child: Icon(
              AppIcons.subscriptionFeatureIcons[feature.icon]!,
              color: tint,
              size: AppSizes.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  feature.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: available
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                if (showDescription &&
                    feature.description.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 2),
                  Text(
                    feature.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            available ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
            color: tint,
            size: AppSizes.iconMd,
          ),
        ],
      ),
    );
  }

  bool _isAvailable(SubscriptionTier tier) {
    if (tier == SubscriptionTier.free) return feature.freeAvailable;
    return feature.premiumAvailable;
  }
}
