import 'package:flutter/material.dart';

import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../domain/entities/leaderboard_entry_entity.dart';
import '../../constants/leaderboard_strings.dart' as strings;
import '../leaderboard_avatar/leaderboard_avatar.dart';
import '../leaderboard_rank_badge/leaderboard_rank_badge.dart';

/// Sticky summary at the bottom of the leaderboard list that pins the
/// current user's row in view as the list scrolls.
class LeaderboardCurrentUserCard extends StatelessWidget {
  const LeaderboardCurrentUserCard({
    super.key,
    required this.entry,
    this.aboveXp = 0,
  });

  final LeaderboardEntryEntity entry;
  final int aboveXp;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      margin: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: <Widget>[
          LeaderboardRankBadge(entry: entry),
          const SizedBox(width: AppSpacing.md),
          LeaderboardAvatar(entry: entry, size: 44),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  strings.LeaderboardStrings.currentUserHeadline,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${strings.LeaderboardStrings.currentUserRankLabel} #${entry.rank}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (aboveXp > 0)
                  Text(
                    '$aboveXp ${strings.LeaderboardStrings.currentUserXpLabel}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(AppIcons.xp,
                      size: 14, color: theme.colorScheme.primary),
                  const SizedBox(width: 2),
                  Text(
                    '${entry.xp}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(AppIcons.coinIcon,
                      size: 14, color: theme.colorScheme.tertiary),
                  const SizedBox(width: 2),
                  Text(
                    '${entry.coins}',
                    style: theme.textTheme.labelMedium,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}