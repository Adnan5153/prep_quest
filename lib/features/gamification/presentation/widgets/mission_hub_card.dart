import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/glass_card.dart';
import '../constants/mission_strings.dart';
import '../../domain/enums/mission_enums.dart';

/// Vertical navigation card used by [MissionsHubScreen] to dispatch
/// into one of the per-cadence mission screens.
class MissionHubCard extends StatelessWidget {
  const MissionHubCard({
    super.key,
    required this.cadence,
    required this.title,
    required this.subtitle,
    required this.completedCount,
    required this.totalCount,
    required this.totalRewardXp,
    required this.totalRewardCoins,
    required this.onTap,
    this.isDark = false,
  });

  final MissionCadence cadence;
  final String title;
  final String subtitle;
  final int completedCount;
  final int totalCount;
  final int totalRewardXp;
  final int totalRewardCoins;
  final VoidCallback onTap;
  final bool isDark;

  ({IconData icon, Color tint}) _resolve() {
    switch (cadence) {
      case MissionCadence.daily:
        return (icon: AppIcons.calendar, tint: AppColors.primary);
      case MissionCadence.weekly:
        return (icon: AppIcons.star, tint: AppColors.accent);
      case MissionCadence.monthly:
        return (icon: AppIcons.crown, tint: AppColors.warning);
    }
  }

  double get _ratio =>
      totalCount <= 0 ? 0 : (completedCount / totalCount).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolved = _resolve();
    final String progressText = MissionStrings.hubProgressTemplate
        .replaceAll('%d', '$completedCount')
        .replaceFirst('%d', '$totalCount');
    final String rewardPreview = MissionStrings.hubRewardPreviewTemplate
        .replaceAll('%d', '$totalRewardXp')
        .replaceFirst('%d', '$totalRewardCoins');

    return GlassCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: resolved.tint.withValues(alpha: isDark ? 0.20 : 0.14),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(resolved.icon, color: resolved.tint, size: 28),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: LinearProgressIndicator(
                    value: _ratio,
                    minHeight: 6,
                    backgroundColor: resolved.tint.withValues(alpha: 0.18),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(resolved.tint),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        progressText,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                          fontFeatures: const <FontFeature>[
                            FontFeature.tabularFigures(),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      rewardPreview,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: resolved.tint,
                        fontWeight: FontWeight.w800,
                        fontFeatures: const <FontFeature>[
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Icon(
            AppIcons.chevronRight,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}