import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class CoinRewardControls extends StatelessWidget {
  const CoinRewardControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.xl),
        Text('Coin Reward Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Text('Amount ${provider.playgroundCoinRewardAmount}'),
        Slider(
          min: 0,
          max: 50000,
          divisions: 100,
          value: provider.playgroundCoinRewardAmount.toDouble().clamp(0, 50000),
          onChanged: (value) =>
              provider.playgroundCoinRewardAmount = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.playgroundCoinRewardLabel,
          decoration: const InputDecoration(labelText: 'Label'),
          onChanged: (value) => provider.playgroundCoinRewardLabel = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Size ${provider.playgroundCoinRewardSize}'),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: <Widget>[
            for (final option in const <String>['compact', 'standard', 'large'])
              ChoiceChip(
                label: Text(option),
                selected: provider.playgroundCoinRewardSize == option,
                onSelected: (_) => provider.playgroundCoinRewardSize = option,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Layout ${provider.playgroundCoinRewardLayout}'),
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
                selected: provider.playgroundCoinRewardLayout == option,
                onSelected: (_) => provider.playgroundCoinRewardLayout = option,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Rarity ${provider.playgroundCoinRewardRarity}'),
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
                selected: provider.playgroundCoinRewardRarity == option,
                onSelected: (_) => provider.playgroundCoinRewardRarity = option,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Dark surface'),
          value: provider.playgroundCoinRewardIsDark,
          onChanged: (value) => provider.playgroundCoinRewardIsDark = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show glow'),
          value: provider.playgroundCoinRewardShowGlow,
          onChanged: (value) => provider.playgroundCoinRewardShowGlow = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show sparkle'),
          value: provider.playgroundCoinRewardShowSparkle,
          onChanged: (value) =>
              provider.playgroundCoinRewardShowSparkle = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Animate'),
          value: provider.playgroundCoinRewardIsAnimating,
          onChanged: (value) =>
              provider.playgroundCoinRewardIsAnimating = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Brightness ${provider.playgroundCoinRewardBrightness}'),
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
                selected: provider.playgroundCoinRewardBrightness == option,
                onSelected: (_) =>
                    provider.playgroundCoinRewardBrightness = option,
              ),
          ],
        ),
      ],
    );
  }
}
