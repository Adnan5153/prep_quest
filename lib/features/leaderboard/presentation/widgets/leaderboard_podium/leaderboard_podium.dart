import 'package:flutter/material.dart';

import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../domain/entities/leaderboard_entry_entity.dart';
import '../../constants/leaderboard_strings.dart' as strings;
import '../leaderboard_avatar/leaderboard_avatar.dart';

/// Visualises the top-three users with a podium-style layout:
/// rank 2 on the left, rank 1 in the centre (tallest), rank 3 on the right.
class LeaderboardPodium extends StatelessWidget {
  const LeaderboardPodium({
    super.key,
    required this.entries,
    this.onTap,
  });

  final List<LeaderboardEntryEntity> entries;
  final ValueChanged<LeaderboardEntryEntity>? onTap;

  @override
  Widget build(BuildContext context) {
    final Map<int, LeaderboardEntryEntity> byRank = <int, LeaderboardEntryEntity>{};
    for (final LeaderboardEntryEntity e in entries) {
      byRank[e.rank] = e;
    }
    final ThemeData theme = Theme.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          height: 220,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              _slot(context, byRank[2], _PodiumSlot.second, theme, constraints),
              _slot(context, byRank[1], _PodiumSlot.first, theme, constraints),
              _slot(context, byRank[3], _PodiumSlot.third, theme, constraints),
            ],
          ),
        );
      },
    );
  }

  Widget _slot(
    BuildContext context,
    LeaderboardEntryEntity? entry,
    _PodiumSlot slot,
    ThemeData theme,
    BoxConstraints constraints,
  ) {
    if (entry == null) return const SizedBox.shrink();
    final double barHeight = switch (slot) {
      _PodiumSlot.first => 110,
      _PodiumSlot.second => 80,
      _PodiumSlot.third => 60,
    };
    final double avatarSize = switch (slot) {
      _PodiumSlot.first => 84,
      _PodiumSlot.second => 64,
      _PodiumSlot.third => 56,
    };
    final String trophyLabel = switch (slot) {
      _PodiumSlot.first => strings.LeaderboardStrings.podiumFirst,
      _PodiumSlot.second => strings.LeaderboardStrings.podiumSecond,
      _PodiumSlot.third => strings.LeaderboardStrings.podiumThird,
    };
    final Color barColor = switch (slot) {
      _PodiumSlot.first => const Color(0xFFFFD700),
      _PodiumSlot.second => const Color(0xFFC0C0C0),
      _PodiumSlot.third => const Color(0xFFCD7F32),
    };
    return Expanded(
      child: GestureDetector(
        onTap: onTap == null ? null : () => onTap!(entry),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            LeaderboardAvatar(entry: entry, size: avatarSize),
            const SizedBox(height: AppSpacing.xs),
            Text(
              entry.username,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Text(
              '${entry.xp} XP',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              height: barHeight,
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.md),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: barColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Column(
                children: <Widget>[
                  Icon(AppIcons.trophy, color: Colors.black87, size: 22),
                  Text(
                    '#${entry.rank}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    trophyLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _PodiumSlot { first, second, third }
