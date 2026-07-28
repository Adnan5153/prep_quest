import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../domain/enums/leaderboard_enums.dart';
import '../../constants/leaderboard_strings.dart' as strings;

/// Bottom sheet that lets the user pick a sort order.
class LeaderboardSortSheet extends StatelessWidget {
  const LeaderboardSortSheet({
    super.key,
    required this.active,
    required this.onSelected,
  });

  final LeaderboardSort active;
  final ValueChanged<LeaderboardSort> onSelected;

  static Future<void> show(
    BuildContext context, {
    required LeaderboardSort active,
    required ValueChanged<LeaderboardSort> onSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => LeaderboardSortSheet(
        active: active,
        onSelected: onSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              strings.LeaderboardStrings.sortTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final LeaderboardSort sort in LeaderboardSort.values)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  sort == active
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: sort == active
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                ),
                title: Text(_labelFor(sort)),
                onTap: () {
                  Navigator.of(context).pop();
                  onSelected(sort);
                },
              ),
          ],
        ),
      ),
    );
  }

  String _labelFor(LeaderboardSort sort) {
    switch (sort) {
      case LeaderboardSort.rank:
        return strings.LeaderboardStrings.sortRank;
      case LeaderboardSort.xp:
        return strings.LeaderboardStrings.sortXp;
      case LeaderboardSort.coins:
        return strings.LeaderboardStrings.sortCoins;
      case LeaderboardSort.streak:
        return strings.LeaderboardStrings.sortStreak;
      case LeaderboardSort.level:
        return strings.LeaderboardStrings.sortLevel;
    }
  }
}
