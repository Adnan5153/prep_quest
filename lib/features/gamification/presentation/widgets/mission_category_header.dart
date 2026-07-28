import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../constants/mission_strings.dart';
import '../../domain/enums/mission_enums.dart';
import 'mission_timer.dart';

/// Section header for a single cadence bucket (daily / weekly / monthly).
class MissionCategoryHeader extends StatelessWidget {
  const MissionCategoryHeader({
    super.key,
    required this.cadence,
    required this.count,
    required this.completedCount,
    this.nextReset,
    this.isDark = false,
  });

  final MissionCadence cadence;
  final int count;
  final int completedCount;
  final DateTime? nextReset;
  final bool isDark;

  ({IconData icon, String title}) _resolve() {
    switch (cadence) {
      case MissionCadence.daily:
        return (icon: AppIcons.calendar, title: MissionStrings.sectionDaily);
      case MissionCadence.weekly:
        return (icon: AppIcons.star, title: MissionStrings.sectionWeekly);
      case MissionCadence.monthly:
        return (icon: AppIcons.crown, title: MissionStrings.sectionMonthly);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolved = _resolve();
    final String countText = MissionStrings.sectionCountTemplate
        .replaceAll('%d', '$count');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(resolved.icon, size: 22, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  resolved.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '$countText · $completedCount done',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (nextReset != null)
            MissionTimer(
              expiresAt: nextReset!,
              label: MissionStrings.sectionResetTemplate.replaceFirst(
                '%s',
                '',
              ),
              compact: true,
            ),
        ],
      ),
    );
  }
}