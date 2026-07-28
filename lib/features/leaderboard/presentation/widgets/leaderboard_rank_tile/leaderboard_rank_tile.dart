import 'package:flutter/material.dart';

import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../domain/entities/leaderboard_entry_entity.dart';
import '../../constants/leaderboard_strings.dart' as strings;
import '../leaderboard_avatar/leaderboard_avatar.dart';
import '../leaderboard_rank_badge/leaderboard_rank_badge.dart';

/// One row in the leaderboard list — avatar, name, university,
/// score chip, XP / coins / streak stat chips, and rank change.
class LeaderboardRankTile extends StatelessWidget {
  const LeaderboardRankTile({
    super.key,
    required this.entry,
    this.onTap,
    this.dense = false,
  });

  final LeaderboardEntryEntity entry;
  final VoidCallback? onTap;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isCurrent = entry.isCurrentUser;
    return Material(
      color: isCurrent
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.45)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: dense ? AppSpacing.sm : AppSpacing.md,
          ),
          child: Row(
            children: <Widget>[
              LeaderboardRankBadge(entry: entry, compact: dense),
              const SizedBox(width: AppSpacing.md),
              LeaderboardAvatar(entry: entry, size: dense ? 40 : 52),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            entry.username,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (entry.isPremium) ...<Widget>[
                          const SizedBox(width: AppSpacing.xs),
                          Icon(
                            AppIcons.crown,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${strings.LeaderboardStrings.rankLevel} ${entry.level} • ${entry.university}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _stat(theme, '${entry.xp}', 'XP'),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        AppIcons.streak,
                        size: 12,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${entry.streakDays}d',
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(ThemeData theme, String value, String unit) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          unit,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}