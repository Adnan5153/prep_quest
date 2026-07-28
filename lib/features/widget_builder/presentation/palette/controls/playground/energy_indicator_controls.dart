import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class EnergyIndicatorControls extends StatelessWidget {
  const EnergyIndicatorControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.xl),
        Text('Energy Indicator Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Remaining ${provider.playgroundEnergyIndicatorRemaining} / ${provider.playgroundEnergyIndicatorMax}',
        ),
        Slider(
          min: 0,
          max: provider.playgroundEnergyIndicatorMax.toDouble().clamp(1, 50),
          divisions: provider.playgroundEnergyIndicatorMax.clamp(1, 50) - 1,
          value: provider.playgroundEnergyIndicatorRemaining.toDouble().clamp(
            0,
            provider.playgroundEnergyIndicatorMax.toDouble(),
          ),
          onChanged: (value) =>
              provider.playgroundEnergyIndicatorRemaining = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Max ${provider.playgroundEnergyIndicatorMax}'),
        Slider(
          min: 1,
          max: 20,
          divisions: 19,
          value: provider.playgroundEnergyIndicatorMax.toDouble().clamp(1, 20),
          onChanged: (value) =>
              provider.playgroundEnergyIndicatorMax = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Recharge Seconds ${provider.playgroundEnergyIndicatorRechargeSeconds}',
        ),
        Slider(
          min: 0,
          max: 7200,
          divisions: 72,
          value: provider.playgroundEnergyIndicatorRechargeSeconds
              .toDouble()
              .clamp(0, 7200),
          onChanged: (value) =>
              provider.playgroundEnergyIndicatorRechargeSeconds = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Animate Refill'),
          value: provider.playgroundEnergyIndicatorIsAnimatingRefill,
          onChanged: (value) =>
              provider.playgroundEnergyIndicatorIsAnimatingRefill = value,
        ),
      ],
    );
  }
}
