import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../domain/entities/user_profile.dart';
import '../../constants/profile_strings.dart';

/// Surfaces the user's energy / hearts pool with a progress bar.
class ProfileEnergyCard extends StatelessWidget {
  const ProfileEnergyCard({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ProgressionEntity progression = profile.progression;
    final double progress = progression.energyProgress;
    final bool isAtRisk =
        progression.energy > 0 && progression.energy <= progression.maxEnergy ~/ 4;
    final bool isDepleted = progression.energy <= 0;

    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: AppSizes.iconXl,
                height: AppSizes.iconXl,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: const Icon(
                  AppIcons.heart,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      ProfileStrings.energySectionTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '${progression.energy} / ${progression.maxEnergy}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: isDepleted
                            ? AppColors.error
                            : isAtRisk
                                ? AppColors.warning
                                : AppColors.success,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDepleted
                    ? AppColors.error
                    : isAtRisk
                        ? AppColors.warning
                        : AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }
}