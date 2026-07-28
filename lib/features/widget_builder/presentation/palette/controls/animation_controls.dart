import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../providers/widget_builder_provider.dart';

class AnimatedCardControls extends StatelessWidget {
  const AnimatedCardControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Animated Card Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: provider.cardTitle,
          decoration: const InputDecoration(labelText: 'Title'),
          onChanged: (value) => provider.cardTitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.cardSubtitle,
          decoration: const InputDecoration(labelText: 'Subtitle'),
          onChanged: (value) => provider.cardSubtitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.cardVariant,
          decoration: const InputDecoration(labelText: 'Variant'),
          items: const [
            DropdownMenuItem(value: 'filled', child: Text('Filled')),
            DropdownMenuItem(value: 'outlined', child: Text('Outlined')),
            DropdownMenuItem(value: 'glass', child: Text('Glass')),
            DropdownMenuItem(value: 'gradient', child: Text('Gradient')),
          ],
          onChanged: (value) {
            if (value != null) provider.cardVariant = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.cardAnimationType,
          decoration: const InputDecoration(labelText: 'Animation Type'),
          items: const [
            DropdownMenuItem(value: 'scale', child: Text('Scale')),
            DropdownMenuItem(value: 'fade', child: Text('Fade')),
            DropdownMenuItem(value: 'slide', child: Text('Slide')),
            DropdownMenuItem(value: 'none', child: Text('None')),
          ],
          onChanged: (value) {
            if (value != null) provider.cardAnimationType = value;
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Hover Scaling'),
          value: provider.enableCardHover,
          onChanged: (value) => provider.enableCardHover = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Glow on Hover'),
          value: provider.enableCardGlow,
          onChanged: (value) => provider.enableCardGlow = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Force Glass Effect'),
          value: provider.enableCardGlass,
          onChanged: (value) => provider.enableCardGlass = value,
        ),
      ],
    );
  }
}
