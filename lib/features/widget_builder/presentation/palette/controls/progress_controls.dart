import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../providers/widget_builder_provider.dart';

class XPProgressBarControls extends StatelessWidget {
  const XPProgressBarControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('XP Bar Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: provider.currentXPValue.toString(),
                decoration: const InputDecoration(labelText: 'Current XP'),
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    provider.currentXPValue = int.tryParse(value) ?? 0,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: TextFormField(
                initialValue: provider.requiredXPValue.toString(),
                decoration: const InputDecoration(labelText: 'Required XP'),
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    provider.requiredXPValue = int.tryParse(value) ?? 1000,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: provider.currentLevelValue.toString(),
                decoration: const InputDecoration(labelText: 'Lvl'),
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    provider.currentLevelValue = int.tryParse(value) ?? 1,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: provider.xpBarVariant,
                decoration: const InputDecoration(labelText: 'Variant'),
                items: const [
                  DropdownMenuItem(value: 'rounded', child: Text('Rounded')),
                  DropdownMenuItem(value: 'linear', child: Text('Linear')),
                  DropdownMenuItem(value: 'gradient', child: Text('Gradient')),
                  DropdownMenuItem(value: 'glass', child: Text('Glass')),
                  DropdownMenuItem(value: 'glowing', child: Text('Glowing')),
                  DropdownMenuItem(value: 'minimal', child: Text('Minimal')),
                  DropdownMenuItem(value: 'compact', child: Text('Compact')),
                ],
                onChanged: (value) {
                  if (value != null) provider.xpBarVariant = value;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Progress Override: ${(provider.xpBarProgressValue * 100).toInt()}%',
          style: theme.textTheme.labelMedium,
        ),
        Slider.adaptive(
          value: provider.xpBarProgressValue,
          onChanged: (value) => provider.xpBarProgressValue = value,
        ),
        const SizedBox(height: AppSpacing.sm),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Percentage'),
          value: provider.showXPPercentage,
          onChanged: (value) => provider.showXPPercentage = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Level Badge'),
          value: provider.showLevelBadge,
          onChanged: (value) => provider.showLevelBadge = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show XP Text'),
          value: provider.showXPText,
          onChanged: (value) => provider.showXPText = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Enable Animation'),
          value: provider.showXPBarAnimation,
          onChanged: (value) => provider.showXPBarAnimation = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Glow'),
          value: provider.showXPBarGlow,
          onChanged: (value) => provider.showXPBarGlow = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Icon'),
          value: provider.showXPBarIcon,
          onChanged: (value) => provider.showXPBarIcon = value,
        ),
      ],
    );
  }
}
