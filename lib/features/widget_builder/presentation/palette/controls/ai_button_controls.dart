import 'package:flutter/material.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../providers/widget_builder_provider.dart';

class AiActionButtonControls extends StatelessWidget {
  const AiActionButtonControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('AI Button Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<String>(
          initialValue: provider.state.aiButtonVariant,
          decoration: const InputDecoration(labelText: 'Variant'),
          items: const [
            DropdownMenuItem(value: 'filled', child: Text('Filled')),
            DropdownMenuItem(value: 'outlined', child: Text('Outlined')),
            DropdownMenuItem(value: 'gradient', child: Text('Gradient')),
            DropdownMenuItem(value: 'glass', child: Text('Glass')),
            DropdownMenuItem(value: 'elevated', child: Text('Elevated')),
            DropdownMenuItem(value: 'minimal', child: Text('Minimal')),
            DropdownMenuItem(value: 'floating', child: Text('Floating')),
            DropdownMenuItem(value: 'iconOnly', child: Text('Icon Only')),
          ],
          onChanged: (value) {
            if (value != null) provider.controller.setAiButtonVariant(value);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.state.aiButtonSize,
          decoration: const InputDecoration(labelText: 'Size'),
          items: const [
            DropdownMenuItem(value: 'small', child: Text('Small')),
            DropdownMenuItem(value: 'medium', child: Text('Medium')),
            DropdownMenuItem(value: 'large', child: Text('Large')),
          ],
          onChanged: (value) {
            if (value != null) provider.controller.setAiButtonSize(value);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.state.aiButtonState,
          decoration: const InputDecoration(labelText: 'State'),
          items: const [
            DropdownMenuItem(value: 'enabled', child: Text('Enabled')),
            DropdownMenuItem(value: 'disabled', child: Text('Disabled')),
            DropdownMenuItem(value: 'loading', child: Text('Loading')),
            DropdownMenuItem(value: 'processing', child: Text('Processing')),
            DropdownMenuItem(value: 'success', child: Text('Success')),
            DropdownMenuItem(value: 'error', child: Text('Error')),
            DropdownMenuItem(
              value: 'premiumLocked',
              child: Text('Premium Locked'),
            ),
          ],
          onChanged: (value) {
            if (value != null) provider.controller.setAiButtonState(value);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.state.aiButtonAnimation,
          decoration: const InputDecoration(labelText: 'Animation'),
          items: const [
            DropdownMenuItem(value: 'none', child: Text('None')),
            DropdownMenuItem(value: 'pulse', child: Text('Pulse')),
            DropdownMenuItem(value: 'breathing', child: Text('Breathing')),
            DropdownMenuItem(value: 'fade', child: Text('Fade')),
          ],
          onChanged: (value) {
            if (value != null) provider.controller.setAiButtonAnimation(value);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show AI Icon'),
          value: provider.state.showAiIcon,
          onChanged: (value) => provider.controller.setShowAiIcon(value),
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Full Width'),
          value: provider.state.isButtonFullWidth,
          onChanged: (value) => provider.controller.setIsButtonFullWidth(value),
        ),
      ],
    );
  }
}
