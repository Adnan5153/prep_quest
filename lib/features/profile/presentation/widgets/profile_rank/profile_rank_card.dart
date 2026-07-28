import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../domain/entities/user_profile.dart';
import '../../constants/profile_strings.dart';

/// Card showing the learner's current rank tier and progress.
class ProfileRankCard extends StatelessWidget {
  const ProfileRankCard({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ProfileRank rank = profile.progression.rank;
    final Color accent = _colorFor(rank);
    final int nextRankIndex = (ProfileRank.values.indexOf(rank) + 1)
        .clamp(0, ProfileRank.values.length - 1);
    final ProfileRank nextRank = ProfileRank.values[nextRankIndex];

    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: <Widget>[
          Container(
            width: AppSizes.iconXl,
            height: AppSizes.iconXl,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  accent,
                  accent.withValues(alpha: 0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Icon(
              AppIcons.crown,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  ProfileStrings.rankSectionTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  rank.displayName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (rank != ProfileRank.diamond) ...<Widget>[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'Next: ${nextRank.displayName}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _colorFor(ProfileRank rank) {
    switch (rank) {
      case ProfileRank.bronze:
        return const Color(0xFFCD7F32);
      case ProfileRank.silver:
        return AppColors.lightMuted;
      case ProfileRank.gold:
        return AppColors.accent;
      case ProfileRank.platinum:
        return AppColors.info;
      case ProfileRank.diamond:
        return AppColors.primary;
    }
  }
}