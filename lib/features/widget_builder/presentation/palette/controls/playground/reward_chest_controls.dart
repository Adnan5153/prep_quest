import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class RewardChestControls extends StatelessWidget {
  const RewardChestControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.xl),
        Text('Reward Chest Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Text('State ${provider.playgroundRewardChestState}'),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: <Widget>[
            for (final option in const <String>[
              'closed',
              'opening',
              'opened',
              'locked',
            ])
              ChoiceChip(
                label: Text(option),
                selected: provider.playgroundRewardChestState == option,
                onSelected: (_) => provider.playgroundRewardChestState = option,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Size ${provider.playgroundRewardChestSize}'),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: <Widget>[
            for (final option in const <String>['compact', 'standard', 'large'])
              ChoiceChip(
                label: Text(option),
                selected: provider.playgroundRewardChestSize == option,
                onSelected: (_) => provider.playgroundRewardChestSize = option,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Rarity ${provider.playgroundRewardChestRarity}'),
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
                selected: provider.playgroundRewardChestRarity == option,
                onSelected: (_) =>
                    provider.playgroundRewardChestRarity = option,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Dark surface'),
          value: provider.playgroundRewardChestIsDark,
          onChanged: (value) => provider.playgroundRewardChestIsDark = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show glow'),
          value: provider.playgroundRewardChestShowGlow,
          onChanged: (value) => provider.playgroundRewardChestShowGlow = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Auto open'),
          value: provider.playgroundRewardChestAutoOpen,
          onChanged: (value) => provider.playgroundRewardChestAutoOpen = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Brightness ${provider.playgroundRewardChestBrightness}'),
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
                selected: provider.playgroundRewardChestBrightness == option,
                onSelected: (_) =>
                    provider.playgroundRewardChestBrightness = option,
              ),
          ],
        ),
      ],
    );
  }
}
