import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/custom_sliver_appbar.dart';
import '../../constants/leaderboard_strings.dart' as strings;

/// Sticky sliver header used at the top of the leaderboard detail.
class LeaderboardHeader extends StatelessWidget {
  const LeaderboardHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.lastUpdatedIso,
    this.participantCount,
    this.onBack,
  });

  final String title;
  final String subtitle;
  final String? lastUpdatedIso;
  final int? participantCount;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return CustomSliverAppBar(
      title: title,
      subtitle: subtitle,
      leading: onBack == null
          ? null
          : IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: onBack,
            ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            children: <Widget>[
              if (participantCount != null)
                Text(
                  '$participantCount ${strings.LeaderboardStrings.detailParticipants}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              const Spacer(),
              if (lastUpdatedIso != null)
                Text(
                  '${strings.LeaderboardStrings.detailLastUpdated} • $lastUpdatedIso',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}