import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class LevelProgressCardControls extends StatelessWidget {
  const LevelProgressCardControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.xl),
        Text('Level Progress Card Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: provider.playgroundLevelProgressCardTitle,
          decoration: const InputDecoration(labelText: 'Title'),
          onChanged: (value) =>
              provider.playgroundLevelProgressCardTitle = value,
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: provider.playgroundLevelProgressCardSubtitle,
          decoration: const InputDecoration(labelText: 'Subtitle'),
          onChanged: (value) =>
              provider.playgroundLevelProgressCardSubtitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Level ${provider.playgroundLevelProgressCardLevel}'),
        Slider(
          min: 1,
          max: 50,
          divisions: 49,
          value: provider.playgroundLevelProgressCardLevel.toDouble().clamp(
            1,
            50,
          ),
          onChanged: (value) =>
              provider.playgroundLevelProgressCardLevel = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Total Stages ${provider.playgroundLevelProgressCardTotalStages}'),
        Slider(
          min: 1,
          max: 12,
          divisions: 11,
          value: provider.playgroundLevelProgressCardTotalStages
              .toDouble()
              .clamp(1, 12),
          onChanged: (value) =>
              provider.playgroundLevelProgressCardTotalStages = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Completed Stages ${provider.playgroundLevelProgressCardCompletedStages}',
        ),
        Slider(
          min: 0,
          max: 12,
          divisions: 12,
          value: provider.playgroundLevelProgressCardCompletedStages
              .toDouble()
              .clamp(0, 12),
          onChanged: (value) =>
              provider.playgroundLevelProgressCardCompletedStages = value
                  .round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Total Stars ${provider.playgroundLevelProgressCardTotalStars}'),
        Slider(
          min: 1,
          max: 5,
          divisions: 4,
          value: provider.playgroundLevelProgressCardTotalStars
              .toDouble()
              .clamp(1, 5),
          onChanged: (value) =>
              provider.playgroundLevelProgressCardTotalStars = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Earned Stars ${provider.playgroundLevelProgressCardEarnedStars}'),
        Slider(
          min: 0,
          max: 5,
          divisions: 5,
          value: provider.playgroundLevelProgressCardEarnedStars
              .toDouble()
              .clamp(0, 5),
          onChanged: (value) =>
              provider.playgroundLevelProgressCardEarnedStars = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Current XP ${provider.playgroundLevelProgressCardCurrentXP}'),
        Slider(
          min: 0,
          max: 1000,
          divisions: 100,
          value: provider.playgroundLevelProgressCardCurrentXP.toDouble().clamp(
            0,
            1000,
          ),
          onChanged: (value) =>
              provider.playgroundLevelProgressCardCurrentXP = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Required XP ${provider.playgroundLevelProgressCardRequiredXP}'),
        Slider(
          min: 1,
          max: 2000,
          divisions: 199,
          value: provider.playgroundLevelProgressCardRequiredXP
              .toDouble()
              .clamp(1, 2000),
          onChanged: (value) =>
              provider.playgroundLevelProgressCardRequiredXP = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Reward Amount ${provider.playgroundLevelProgressCardRewardAmount}',
        ),
        Slider(
          min: 0,
          max: 1000,
          divisions: 100,
          value: provider.playgroundLevelProgressCardRewardAmount
              .toDouble()
              .clamp(0, 1000),
          onChanged: (value) =>
              provider.playgroundLevelProgressCardRewardAmount = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('State ${provider.playgroundLevelProgressCardState}'),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: <Widget>[
            for (final option in const <String>[
              'current',
              'completed',
              'locked',
              'premium',
            ])
              ChoiceChip(
                label: Text(option),
                selected: provider.playgroundLevelProgressCardState == option,
                onSelected: (_) =>
                    provider.playgroundLevelProgressCardState = option,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Reward ${provider.playgroundLevelProgressCardRewardKind}'),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: <Widget>[
            for (final option in const <String>['xp', 'coin', 'gem', 'badge'])
              ChoiceChip(
                label: Text(option),
                selected:
                    provider.playgroundLevelProgressCardRewardKind == option,
                onSelected: (_) =>
                    provider.playgroundLevelProgressCardRewardKind = option,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Brightness ${provider.playgroundLevelProgressCardBrightness}'),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: <Widget>[
            for (final option in const <String>[
              'sideBySide',
              'lightOnly',
              'darkOnly',
            ])
              ChoiceChip(
                label: Text(option),
                selected:
                    provider.playgroundLevelProgressCardBrightness == option,
                onSelected: (_) =>
                    provider.playgroundLevelProgressCardBrightness = option,
              ),
          ],
        ),
      ],
    );
  }
}
