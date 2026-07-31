import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../domain/entities/subscription_entity.dart';

/// Marketing card that lists the top benefits unlocked by Premium.
/// Reused by the Plans screen and the Profile subscription tab.
class SubscriptionBenefitsCard extends StatelessWidget {
  const SubscriptionBenefitsCard({
    super.key,
    required this.benefits,
    this.title = 'Why go Premium',
  });

  final List<SubscriptionFeatureEntity> benefits;
  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final SubscriptionFeatureEntity benefit in benefits)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: AppSizes.iconLg,
                    height: AppSizes.iconLg,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      AppIcons.subscriptionFeatureIcons[benefit.icon]!,
                      size: AppSizes.iconMd,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          benefit.title,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          benefit.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
