import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class MissionCardControls extends StatelessWidget {
  const MissionCardControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.xl),
        Text('Mission Card Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: provider.playgroundMissionCardTitle,
          decoration: const InputDecoration(labelText: 'Title'),
          onChanged: (value) => provider.playgroundMissionCardTitle = value,
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: provider.playgroundMissionCardDescription,
          decoration: const InputDecoration(labelText: 'Description'),
          maxLines: 2,
          onChanged: (value) =>
              provider.playgroundMissionCardDescription = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Required ${provider.playgroundMissionCardRequired}'),
        Slider(
          min: 1,
          max: 50,
          divisions: 49,
          value: provider.playgroundMissionCardRequired.toDouble().clamp(1, 50),
          onChanged: (value) =>
              provider.playgroundMissionCardRequired = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Progress ${provider.playgroundMissionCardProgress}'),
        Slider(
          min: 0,
          max: 50,
          divisions: 50,
          value: provider.playgroundMissionCardProgress.toDouble().clamp(0, 50),
          onChanged: (value) =>
              provider.playgroundMissionCardProgress = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Reward Amount ${provider.playgroundMissionCardRewardAmount}'),
        Slider(
          min: 0,
          max: 1000,
          divisions: 100,
          value: provider.playgroundMissionCardRewardAmount.toDouble().clamp(
            0,
            1000,
          ),
          onChanged: (value) =>
              provider.playgroundMissionCardRewardAmount = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Timer Seconds ${provider.playgroundMissionCardTimerSeconds}'),
        Slider(
          min: 0,
          max: 86400,
          divisions: 96,
          value: provider.playgroundMissionCardTimerSeconds.toDouble().clamp(
            0,
            86400,
          ),
          onChanged: (value) =>
              provider.playgroundMissionCardTimerSeconds = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('State ${provider.playgroundMissionCardState}'),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: <Widget>[
            for (final option in const <String>[
              'active',
              'completed',
              'locked',
            ])
              ChoiceChip(
                label: Text(option),
                selected: provider.playgroundMissionCardState == option,
                onSelected: (_) => provider.playgroundMissionCardState = option,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Tag ${provider.playgroundMissionCardTag}'),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: <Widget>[
            for (final option in const <String>[
              'daily',
              'weekly',
              'premium',
              'special',
            ])
              ChoiceChip(
                label: Text(option),
                selected: provider.playgroundMissionCardTag == option,
                onSelected: (_) => provider.playgroundMissionCardTag = option,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Reward ${provider.playgroundMissionCardRewardKind}'),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: <Widget>[
            for (final option in const <String>['xp', 'coin', 'gem', 'badge'])
              ChoiceChip(
                label: Text(option),
                selected: provider.playgroundMissionCardRewardKind == option,
                onSelected: (_) =>
                    provider.playgroundMissionCardRewardKind = option,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Brightness ${provider.playgroundMissionCardBrightness}'),
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
                selected: provider.playgroundMissionCardBrightness == option,
                onSelected: (_) =>
                    provider.playgroundMissionCardBrightness = option,
              ),
          ],
        ),
      ],
    );
  }
}
