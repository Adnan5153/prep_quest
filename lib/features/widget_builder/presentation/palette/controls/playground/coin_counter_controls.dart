import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class CoinCounterControls extends StatelessWidget {
  const CoinCounterControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.xl),
        Text('Coin Counter Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Text('Balance ${provider.playgroundCoinCounterBalance}'),
        Slider(
          min: 0,
          max: 50000,
          divisions: 100,
          value: provider.playgroundCoinCounterBalance.toDouble().clamp(
            0,
            50000,
          ),
          onChanged: (value) =>
              provider.playgroundCoinCounterBalance = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Gain Delta +${provider.playgroundCoinCounterGainDelta}'),
        Slider(
          min: 0,
          max: 1000,
          divisions: 100,
          value: provider.playgroundCoinCounterGainDelta.toDouble().clamp(
            0,
            1000,
          ),
          onChanged: (value) =>
              provider.playgroundCoinCounterGainDelta = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Animate Gain'),
          value: provider.playgroundCoinCounterIsAnimatingGain,
          onChanged: (value) =>
              provider.playgroundCoinCounterIsAnimatingGain = value,
        ),
      ],
    );
  }
}
