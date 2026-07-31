import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../domain/entities/subscription_entity.dart';

/// Compact, accessible list of the features unlocked by a plan. Used
/// both as a preview on plan cards and as the body of the comparison
/// table.
class PlanFeatureList extends StatelessWidget {
  const PlanFeatureList({
    super.key,
    required this.features,
    this.dense = false,
    this.tint = AppColors.primary,
  });

  final List<SubscriptionFeatureEntity> features;
  final bool dense;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (features.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Text(
          'Core study experience with limited daily AI usage.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final SubscriptionFeatureEntity feature in features)
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: dense ? AppSpacing.xxs : AppSpacing.xs,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  AppIcons.subscriptionFeatureIcons[feature.icon]!,
                  size: dense ? AppSizes.iconSm : AppSizes.iconMd,
                  color: tint,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        feature.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (!dense && feature.description.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 2),
                        Text(
                          feature.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.65,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
