import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../../../core/widgets/premium_badge.dart';
import '../../../domain/entities/subscription_entity.dart';
import '../billing_cycle_selector/billing_cycle_selector.dart';

/// Subscription plan card. Visually rich glassmorphic tile that
/// highlights the recommended plan, surfaces the cycle label and the
/// discount, and exposes a primary CTA. Used by the Plans screen.
class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.plan,
    required this.isCurrent,
    required this.isProcessing,
    required this.onChoose,
    this.cycle = BillingCycle.monthly,
    this.onCycleChanged,
  });

  final SubscriptionPlanEntity plan;
  final bool isCurrent;
  final bool isProcessing;
  final BillingCycle cycle;
  final ValueChanged<BillingCycle>? onCycleChanged;
  final VoidCallback onChoose;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String savings = plan.discountPercent > 0
        ? 'Save ${plan.discountPercent}%'
        : '';
    final bool showCycleSelector =
        onCycleChanged != null && plan.tier != SubscriptionTier.free;

    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      gradient: plan.recommended
          ? const LinearGradient(
              colors: <Color>[
                Color(0xFFF5A623),
                Color(0xFFF7B733),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      borderColor:
          plan.recommended ? AppColors.accent : theme.colorScheme.outline,
      onTap: isCurrent || isProcessing ? null : onChoose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  plan.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: plan.recommended ? Colors.white : null,
                  ),
                ),
              ),
              if (plan.recommended)
                const PremiumBadge(
                  label: 'BEST VALUE',
                  style: PremiumBadgeStyle.filled,
                )
              else if (savings.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    savings,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            plan.tagline,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: plan.recommended
                  ? Colors.white.withValues(alpha: 0.9)
                  : theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                plan.cycleLabel.split(' ').first,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: plan.recommended ? Colors.white : null,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  _cycleSuffix(plan),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: plan.recommended
                        ? Colors.white.withValues(alpha: 0.9)
                        : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
          if (showCycleSelector) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            BillingCycleSelector(
              selected: cycle,
              onChanged: onCycleChanged!,
              compact: true,
              inverseForeground: plan.recommended,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isCurrent || isProcessing ? null : onChoose,
              style: ElevatedButton.styleFrom(
                backgroundColor: plan.recommended
                    ? Colors.white
                    : theme.colorScheme.primary,
                foregroundColor: plan.recommended
                    ? AppColors.accent
                    : theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: Text(
                isCurrent
                    ? 'Your current plan'
                    : (plan.tier == SubscriptionTier.free
                        ? 'Stay on free'
                        : 'Choose plan'),
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _cycleSuffix(SubscriptionPlanEntity plan) {
    if (plan.tier == SubscriptionTier.free) return 'forever';
    if (plan.billingCycleMonths == 12) return '/ year';
    if (plan.billingCycleMonths == 3) return '/ quarter';
    if (plan.billingCycleMonths == 1) return '/ month';
    return plan.cycleLabel.replaceFirst(
      '${plan.currencyCode} ${plan.priceBdt.toStringAsFixed(0)}',
      '',
    );
  }
}