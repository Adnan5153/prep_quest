import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../../../core/widgets/xp_progress_bar.dart';
import '../../../domain/entities/user_profile.dart';
import '../../constants/profile_strings.dart';

/// XP progress card — shows the level progress bar and totals.
class ProfileXpProgressCard extends StatelessWidget {
  const ProfileXpProgressCard({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ProgressionEntity progression = profile.progression;
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                ProfileStrings.progressionSectionTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                '${progression.totalXp} ${ProfileStrings.xpLabel}',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          XPProgressBar(
            currentXP: progression.xpInLevel,
            requiredXP: progression.xpForNextLevel,
            currentLevel: progression.level,
            nextLevel: progression.level + 1,
            progress: progression.xpProgress,
            variant: XPProgressBarVariant.gradient,
            showLevel: true,
            showXPText: true,
            showPercentage: true,
            showIcon: true,
            showGlow: false,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              _Pill(
                label: ProfileStrings.streakLabel,
                value: '${progression.streakDays}d',
                icon: Icons.local_fire_department_rounded,
              ),
              const SizedBox(width: AppSpacing.sm),
              _Pill(
                label: ProfileStrings.longestStreakLabel,
                value: '${profile.studyStats.longestStreakDays}d',
                icon: Icons.emoji_events_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: AppSizes.iconSm, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '$label • ',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}