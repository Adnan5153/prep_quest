import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../../../core/widgets/premium_badge.dart';
import '../../../domain/entities/subscription_entity.dart';
import '../premium_badge/premium_badge_widget.dart';

/// Banner shown at the top of the Plans screen, summarising the
/// user's current subscription state.
class CurrentPlanBanner extends StatelessWidget {
  const CurrentPlanBanner({
    super.key,
    required this.subscription,
    this.onManage,
  });

  final SubscriptionEntity subscription;
  final VoidCallback? onManage;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isPremium = subscription.isPremium;
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      gradient: isPremium
          ? const LinearGradient(
              colors: <Color>[AppColors.accent, AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isPremium
                      ? Colors.white.withValues(alpha: 0.18)
                      : theme.colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  isPremium
                      ? Icons.workspace_premium_rounded
                      : Icons.lock_outline_rounded,
                  color: isPremium ? Colors.white : theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            isPremium
                                ? 'Prep Quest Premium'
                                : 'Free plan',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: isPremium ? Colors.white : null,
                            ),
                          ),
                        ),
                        if (isPremium) ...<Widget>[
                          const SizedBox(width: AppSpacing.sm),
                          const SubscriptionPremiumBadge(
                            label: 'ACTIVE',
                            style: PremiumBadgeStyle.filled,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      isPremium
                          ? (subscription.autoRenews
                              ? 'Renews automatically. Cancel anytime.'
                              : 'Active until period end. Does not renew.')
                          : 'You are on the free tier. Upgrade to unlock '
                              'unlimited AI tutor, mock tests and more.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isPremium
                            ? Colors.white.withValues(alpha: 0.85)
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (onManage != null) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onManage,
                icon: Icon(
                  Icons.tune_rounded,
                  color: isPremium ? Colors.white : theme.colorScheme.primary,
                  size: 18,
                ),
                label: Text(
                  'Manage subscription',
                  style: TextStyle(
                    color:
                        isPremium ? Colors.white : theme.colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
