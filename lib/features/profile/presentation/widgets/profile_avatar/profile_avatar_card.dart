import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/profile_avatar.dart';
import '../../../../../core/widgets/responsive_builder.dart';
import '../../../../../core/widgets/widget_constants.dart';
import '../../../domain/entities/user_profile.dart';
import '../../constants/profile_strings.dart';

/// Avatar card — circular photo with a level badge and a verified
/// ring (when applicable).
///
/// Designed for the top of the Profile screen. Uses the shared
/// [ProfileAvatar] core widget so the same visuals power the
/// Playground HUD and the Profile screen.
class ProfileAvatarCard extends StatelessWidget {
  const ProfileAvatarCard({
    super.key,
    required this.profile,
    this.onEditTap,
    this.heroTag,
  });

  final UserProfile profile;
  final VoidCallback? onEditTap;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double scale = ResponsiveBuilder.value<double>(
      context,
      mobile: 1.0,
      tablet: 1.15,
      desktop: 1.25,
    );

    return Semantics(
      label: '${ProfileStrings.screenTitle}: ${profile.displayName}',
      container: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ProfileAvatar(
            heroTag: heroTag,
            size: AppSizes.iconXl * 2 * scale,
            imageUrl: profile.photoUrl.isEmpty ? null : profile.photoUrl,
            initials: profile.initials,
            name: profile.displayName,
            showOnlineIndicator: true,
            isOnline: true,
            showPremiumBadge: profile.role == 'premium',
            showVerifiedBadge: profile.emailVerified,
            showEditButton: true,
            onEdit: onEditTap,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            profile.displayName.isEmpty
                ? ProfileStrings.profileIncompleteLabel
                : profile.displayName,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          if (profile.university.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.school_outlined,
                  size: AppSizes.iconSm,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    profile.university,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          const SizedBox(height: AppSpacing.xs),
          _LevelChip(
            level: profile.progression.level,
            rank: profile.progression.rank,
          ),
        ],
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({required this.level, required this.rank});

  final int level;
  final ProfileRank rank;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = _colorFor(rank);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: color.withValues(alpha: WidgetConstants.outlineThickness),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.bolt_rounded, size: AppSizes.iconSm, color: color),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            '${ProfileStrings.levelLabel} $level • ${rank.displayName}',
            style: theme.textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
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