import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../constants/leaderboard_strings.dart' as strings;

/// Compact linear progress bar showing the user's progress toward the
/// next rank — accepts a 0..1 fraction and the delta to the rank above.
class LeaderboardProgressIndicator extends StatelessWidget {
  const LeaderboardProgressIndicator({
    super.key,
    required this.fraction,
    required this.xpToNextRank,
  });

  final double fraction;
  final int xpToNextRank;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double clamped = fraction.clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                strings.LeaderboardStrings.progressToNext,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '$xpToNextRank XP',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: clamped,
              minHeight: 8,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor:
                  AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}