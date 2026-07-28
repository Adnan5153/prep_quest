import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../providers/widget_builder_provider.dart';

class StreakCardControls extends StatelessWidget {
  const StreakCardControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Streak Card Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Current Streak: ${provider.currentStreakValue}',
          style: theme.textTheme.labelMedium,
        ),
        Slider.adaptive(
          value: provider.currentStreakValue.toDouble(),
          min: 0,
          max: 100,
          onChanged: (value) => provider.currentStreakValue = value.toInt(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Longest Streak: ${provider.longestStreakValue}',
          style: theme.textTheme.labelMedium,
        ),
        Slider.adaptive(
          value: provider.longestStreakValue.toDouble(),
          min: 0,
          max: 365,
          onChanged: (value) => provider.longestStreakValue = value.toInt(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Daily Progress: ${(provider.streakProgressValue * 100).toInt()}%',
          style: theme.textTheme.labelMedium,
        ),
        Slider.adaptive(
          value: provider.streakProgressValue,
          onChanged: (value) => provider.streakProgressValue = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Weekly Progress'),
          value: provider.showWeeklyStreak,
          onChanged: (value) => provider.showWeeklyStreak = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Reward Section'),
          value: provider.showStreakReward,
          onChanged: (value) => provider.showStreakReward = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Milestone Badge'),
          value: provider.showStreakMilestone,
          onChanged: (value) => provider.showStreakMilestone = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Fire Animation'),
          value: provider.enableStreakAnimation,
          onChanged: (value) => provider.enableStreakAnimation = value,
        ),
      ],
    );
  }
}
