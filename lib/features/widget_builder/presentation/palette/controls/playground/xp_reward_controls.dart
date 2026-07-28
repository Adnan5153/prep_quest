import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class XpRewardControls extends StatelessWidget {
  const XpRewardControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.xl),
        Text('XP Reward Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Text('Amount ${provider.playgroundXpRewardAmount}'),
        Slider(
          min: 0,
          max: 10000,
          divisions: 100,
          value: provider.playgroundXpRewardAmount.toDouble().clamp(0, 10000),
          onChanged: (value) =>
              provider.playgroundXpRewardAmount = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.playgroundXpRewardLabel,
          decoration: const InputDecoration(labelText: 'Label'),
          onChanged: (value) => provider.playgroundXpRewardLabel = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Size ${provider.playgroundXpRewardSize}'),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: <Widget>[
            for (final option in const <String>['compact', 'standard', 'large'])
              ChoiceChip(
                label: Text(option),
                selected: provider.playgroundXpRewardSize == option,
                onSelected: (_) => provider.playgroundXpRewardSize = option,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Layout ${provider.playgroundXpRewardLayout}'),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: <Widget>[
            for (final option in const <String>[
              'iconOnly',
              'compact',
              'detailed',
            ])
              ChoiceChip(
                label: Text(option),
                selected: provider.playgroundXpRewardLayout == option,
                onSelected: (_) => provider.playgroundXpRewardLayout = option,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Rarity ${provider.playgroundXpRewardRarity}'),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: <Widget>[
            for (final option in const <String>[
              'common',
              'rare',
              'epic',
              'legendary',
            ])
              ChoiceChip(
                label: Text(option),
                selected: provider.playgroundXpRewardRarity == option,
                onSelected: (_) => provider.playgroundXpRewardRarity = option,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Dark surface'),
          value: provider.playgroundXpRewardIsDark,
          onChanged: (value) => provider.playgroundXpRewardIsDark = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show glow'),
          value: provider.playgroundXpRewardShowGlow,
          onChanged: (value) => provider.playgroundXpRewardShowGlow = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show sparkle'),
          value: provider.playgroundXpRewardShowSparkle,
          onChanged: (value) => provider.playgroundXpRewardShowSparkle = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Animate'),
          value: provider.playgroundXpRewardIsAnimating,
          onChanged: (value) => provider.playgroundXpRewardIsAnimating = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Level Up badge'),
          value: provider.playgroundXpRewardIsLevelUp,
          onChanged: (value) => provider.playgroundXpRewardIsLevelUp = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Brightness ${provider.playgroundXpRewardBrightness}'),
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
                selected: provider.playgroundXpRewardBrightness == option,
                onSelected: (_) =>
                    provider.playgroundXpRewardBrightness = option,
              ),
          ],
        ),
      ],
    );
  }
}
