import 'package:flutter/material.dart';

import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/profile_avatar.dart';
import '../../../domain/entities/leaderboard_entry_entity.dart';

/// Shared avatar treatment for leaderboard entries.
class LeaderboardAvatar extends StatelessWidget {
  const LeaderboardAvatar({
    super.key,
    required this.entry,
    this.size = 52,
    this.showRank = false,
  });

  final LeaderboardEntryEntity entry;
  final double size;
  final bool showRank;

  @override
  Widget build(BuildContext context) {
    final Widget avatar = ProfileAvatar(
      size: size,
      name: entry.username,
      imageUrl: entry.avatarUrl.isEmpty ? null : entry.avatarUrl,
      showBorder: true,
      showShadow: false,
      showPremiumBadge: entry.isPremium,
      heroTag: 'leaderboard-avatar-${entry.userId}',
    );
    if (!showRank) return avatar;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          '#${entry.rank}',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(width: AppSpacing.sm),
        avatar,
        const SizedBox(width: AppSpacing.sm),
        if (entry.isPremium)
          Icon(AppIcons.crown, size: size * 0.28),
      ],
    );
  }
}
