import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class XpIndicatorControls extends StatelessWidget {
  const XpIndicatorControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.xl),
        Text('XP Indicator Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Text('User Level ${provider.playgroundXpIndicatorUserLevel}'),
        Slider(
          min: 1,
          max: 50,
          divisions: 49,
          value: provider.playgroundXpIndicatorUserLevel.toDouble().clamp(
            1,
            50,
          ),
          onChanged: (value) =>
              provider.playgroundXpIndicatorUserLevel = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Total XP ${provider.playgroundXpIndicatorTotalXp}'),
        Slider(
          min: 0,
          max: 50000,
          divisions: 100,
          value: provider.playgroundXpIndicatorTotalXp.toDouble().clamp(
            0,
            50000,
          ),
          onChanged: (value) =>
              provider.playgroundXpIndicatorTotalXp = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'XP in Level ${provider.playgroundXpIndicatorXpInLevel} / ${provider.playgroundXpIndicatorXpForNextLevel}',
        ),
        Slider(
          min: 0,
          max: 1000,
          divisions: 100,
          value: provider.playgroundXpIndicatorXpInLevel.toDouble().clamp(
            0,
            1000,
          ),
          onChanged: (value) =>
              provider.playgroundXpIndicatorXpInLevel = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'XP for Next Level ${provider.playgroundXpIndicatorXpForNextLevel}',
        ),
        Slider(
          min: 1,
          max: 2000,
          divisions: 199,
          value: provider.playgroundXpIndicatorXpForNextLevel.toDouble().clamp(
            1,
            2000,
          ),
          onChanged: (value) =>
              provider.playgroundXpIndicatorXpForNextLevel = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Gain Delta +${provider.playgroundXpIndicatorGainDelta}'),
        Slider(
          min: 0,
          max: 500,
          divisions: 50,
          value: provider.playgroundXpIndicatorGainDelta.toDouble().clamp(
            0,
            500,
          ),
          onChanged: (value) =>
              provider.playgroundXpIndicatorGainDelta = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Animate Gain'),
          value: provider.playgroundXpIndicatorIsAnimatingGain,
          onChanged: (value) =>
              provider.playgroundXpIndicatorIsAnimatingGain = value,
        ),
      ],
    );
  }
}
