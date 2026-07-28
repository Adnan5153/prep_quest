import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../providers/widget_builder_provider.dart';

class SimulationControls extends StatelessWidget {
  const SimulationControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Simulation Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<String>(
          initialValue: provider.simulatedDevice,
          decoration: const InputDecoration(labelText: 'Target Device'),
          items: const [
            DropdownMenuItem(value: 'mobile', child: Text('Mobile (360x640)')),
            DropdownMenuItem(value: 'tablet', child: Text('Tablet (768x1024)')),
            DropdownMenuItem(
              value: 'desktop',
              child: Text('Desktop (1200x800)'),
            ),
            DropdownMenuItem(
              value: 'largeDesktop',
              child: Text('Large Desktop (1600x900)'),
            ),
          ],
          onChanged: (value) {
            if (value != null) provider.simulatedDevice = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Landscape Mode'),
          value: provider.isSimulatedLandscape,
          onChanged: (value) => provider.isSimulatedLandscape = value,
        ),
      ],
    );
  }
}
