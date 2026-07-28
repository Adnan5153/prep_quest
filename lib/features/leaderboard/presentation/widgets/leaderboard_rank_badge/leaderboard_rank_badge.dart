import 'package:flutter/material.dart';

import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../domain/entities/leaderboard_entry_entity.dart';
import '../../../domain/enums/leaderboard_enums.dart';

/// Colored rank pill with rank-change arrow.
class LeaderboardRankBadge extends StatelessWidget {
  const LeaderboardRankBadge({
    super.key,
    required this.entry,
    this.compact = false,
  });

  final LeaderboardEntryEntity entry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color background = _backgroundFor(entry.rank, theme);
    final Color foreground = _foregroundFor(entry.rank, theme);
    return Container(
      width: compact ? 36 : 44,
      height: compact ? 36 : 44,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: entry.isCurrentUser
            ? Border.all(
                color: theme.colorScheme.primary,
                width: 2,
              )
            : null,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '${entry.rank}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: foreground,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
          ),
          if (!compact)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: _changeIcon(theme, entry),
            ),
        ],
      ),
    );
  }

  Widget _changeIcon(ThemeData theme, LeaderboardEntryEntity e) {
    final IconData iconData;
    final Color color;
    switch (e.rankChange) {
      case RankChange.up:
        iconData = AppIcons.arrowForward;
        color = Colors.green;
      case RankChange.down:
        iconData = AppIcons.arrowForward;
        color = theme.colorScheme.error;
      case RankChange.unchanged:
        iconData = AppIcons.success;
        color = theme.colorScheme.outline;
    }
    return Icon(iconData, size: 12, color: color);
  }

  Color _backgroundFor(int rank, ThemeData theme) {
    if (rank == 1) return const Color(0xFFFFD700);
    if (rank == 2) return const Color(0xFFC0C0C0);
    if (rank == 3) return const Color(0xFFCD7F32);
    return theme.colorScheme.surfaceContainerHighest;
  }

  Color _foregroundFor(int rank, ThemeData theme) {
    if (rank >= 1 && rank <= 3) return Colors.black87;
    return theme.colorScheme.onSurface;
  }
}