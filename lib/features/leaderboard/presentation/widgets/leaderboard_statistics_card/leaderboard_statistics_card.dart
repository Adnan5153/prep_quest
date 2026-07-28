import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../domain/entities/leaderboard_entry_entity.dart';
import '../../constants/leaderboard_strings.dart' as strings;

/// Shows the current user's snapshot stats: total XP, coins, longest
/// streak, highest level, and badge count.
class LeaderboardStatisticsCard extends StatelessWidget {
  const LeaderboardStatisticsCard({
    super.key,
    required this.entries,
  });

  final List<LeaderboardEntryEntity> entries;

  LeaderboardEntryEntity? _findCurrentUser() {
    for (final LeaderboardEntryEntity e in entries) {
      if (e.isCurrentUser) return e;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LeaderboardEntryEntity? current = _findCurrentUser();
    if (current == null) return const SizedBox.shrink();
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            strings.LeaderboardStrings.statsTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: _statTile(
                  theme,
                  '${current.xp}',
                  strings.LeaderboardStrings.statsTotalXp,
                  Icons.bolt_rounded,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _statTile(
                  theme,
                  '${current.coins}',
                  strings.LeaderboardStrings.statsTotalCoins,
                  Icons.monetization_on_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: _statTile(
                  theme,
                  '${current.streakDays}d',
                  strings.LeaderboardStrings.statsLongestStreak,
                  Icons.local_fire_department_rounded,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _statTile(
                  theme,
                  '${current.level}',
                  strings.LeaderboardStrings.statsHighestLevel,
                  Icons.military_tech_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: _statTile(
                  theme,
                  '${current.badges.length}',
                  strings.LeaderboardStrings.statsBadgeCount,
                  Icons.workspace_premium_rounded,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statTile(
    ThemeData theme,
    String value,
    String label,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}