// ignore_for_file: non_const_argument_for_const_parameter

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../domain/entities/subscription_entity.dart';
import '../../../../../core/constants/app_icons.dart';

/// Side-by-side feature comparison table used by the Plan Comparison
/// screen. Built from the full feature catalog so the table stays in
/// sync with the catalogue endpoint.
class ComparisonTable extends StatelessWidget {
  const ComparisonTable({
    super.key,
    required this.features,
    this.columns = const <SubscriptionTier>[
      SubscriptionTier.free,
      SubscriptionTier.monthly,
      SubscriptionTier.quarterly,
      SubscriptionTier.yearly,
    ],
  });

  final List<SubscriptionFeatureEntity> features;
  final List<SubscriptionTier> columns;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          _buildHeader(theme),
          const Divider(height: 1, thickness: 1),
          for (int i = 0; i < features.length; i++) ...<Widget>[
            _FeatureRow(
              feature: features[i],
              columns: columns,
              isAlternate: i.isOdd,
            ),
            if (i != features.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                color: theme.dividerColor.withValues(alpha: 0.4),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: <Widget>[
          const Expanded(
            flex: 4,
            child: Text(
              'Feature',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          for (final SubscriptionTier tier in columns)
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  _columnLabel(tier),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: tier == SubscriptionTier.yearly
                        ? AppColors.accent
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _columnLabel(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return 'Free';
      case SubscriptionTier.monthly:
        return 'Monthly';
      case SubscriptionTier.quarterly:
        return 'Quarterly';
      case SubscriptionTier.yearly:
        return 'Yearly';
    }
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.feature,
    required this.columns,
    required this.isAlternate,
  });

  final SubscriptionFeatureEntity feature;
  final List<SubscriptionTier> columns;
  final bool isAlternate;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      color: isAlternate
          ? theme.colorScheme.onSurface.withValues(alpha: 0.03)
          : null,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Row(
              children: <Widget>[
                Icon(
                  _iconFromCodePoint(feature.iconCodePoint),
                  size: AppSizes.iconMd,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    feature.title,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          for (final SubscriptionTier tier in columns)
            Expanded(
              flex: 2,
              child: Center(
                child: _CellIndicator(
                  tier: tier,
                  feature: feature,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CellIndicator extends StatelessWidget {
  const _CellIndicator({required this.tier, required this.feature});

  final SubscriptionTier tier;
  final SubscriptionFeatureEntity feature;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool available = _isAvailable(tier);
    final Color color = available
        ? AppColors.success
        : theme.colorScheme.onSurface.withValues(alpha: 0.3);
    return Container(
      width: AppSizes.iconMd,
      height: AppSizes.iconMd,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: available ? 0.15 : 0.08),
      ),
      alignment: Alignment.center,
      child: Icon(
        available ? AppIcons.checkCircle : Icons.remove_rounded,
        size: AppSizes.iconSm,
        color: color,
      ),
    );
  }

  bool _isAvailable(SubscriptionTier tier) {
    if (tier == SubscriptionTier.free) return feature.freeAvailable;
    return feature.premiumAvailable;
  }
}

IconData _iconFromCodePoint(int codePoint) =>
    IconData(codePoint, fontFamily: 'MaterialIcons');