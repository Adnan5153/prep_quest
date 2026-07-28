import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/ai/ai_avatar_constants.dart';
import '../../providers/widget_builder_provider.dart';

/// Customization controls for the [AiAvatarAnimation] preview inside the
/// Widget Builder.
///
/// Exposes the knobs that genuinely change the widget's rendered output:
/// status preset, size slider, motion speed, motion intensity, layer
/// visibility toggles (glow / halo / particles), shadow toggle, and an
/// optional border stroke.
class AiAvatarAnimationControls extends StatelessWidget {
  const AiAvatarAnimationControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.xl),
        Text('AI Avatar Animation Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<String>(
          initialValue: provider.state.aiAvatarStatus,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Status'),
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(value: 'idle', child: Text('Idle')),
            DropdownMenuItem<String>(
              value: 'listening',
              child: Text('Listening'),
            ),
            DropdownMenuItem<String>(
              value: 'thinking',
              child: Text('Thinking'),
            ),
            DropdownMenuItem<String>(
              value: 'generating',
              child: Text('Generating'),
            ),
            DropdownMenuItem<String>(value: 'typing', child: Text('Typing')),
            DropdownMenuItem<String>(
              value: 'speaking',
              child: Text('Speaking'),
            ),
            DropdownMenuItem<String>(value: 'success', child: Text('Success')),
            DropdownMenuItem<String>(value: 'warning', child: Text('Warning')),
            DropdownMenuItem<String>(value: 'error', child: Text('Error')),
            DropdownMenuItem<String>(value: 'offline', child: Text('Offline')),
          ],
          onChanged: (value) {
            if (value != null) provider.controller.setAiAvatarStatus(value);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.state.aiAvatarSpeed,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Animation speed'),
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(value: 'none', child: Text('Paused')),
            DropdownMenuItem<String>(value: 'slow', child: Text('Slow')),
            DropdownMenuItem<String>(value: 'normal', child: Text('Normal')),
            DropdownMenuItem<String>(value: 'fast', child: Text('Fast')),
          ],
          onChanged: (value) {
            if (value != null) provider.controller.setAiAvatarSpeed(value);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.state.aiAvatarIntensity,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Intensity'),
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(value: 'subtle', child: Text('Subtle')),
            DropdownMenuItem<String>(value: 'normal', child: Text('Normal')),
            DropdownMenuItem<String>(value: 'bold', child: Text('Bold')),
          ],
          onChanged: (value) {
            if (value != null) provider.controller.setAiAvatarIntensity(value);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Size: ${provider.state.aiAvatarSize.toInt()} px',
          style: theme.textTheme.labelMedium,
        ),
        Slider.adaptive(
          value: provider.state.aiAvatarSize,
          min: AiAvatarConstants.minSize,
          max: AiAvatarConstants.maxSize,
          divisions:
              ((AiAvatarConstants.maxSize - AiAvatarConstants.minSize) / 4)
                  .round(),
          label: '${provider.state.aiAvatarSize.toInt()} px',
          onChanged: (value) => provider.controller.setAiAvatarSize(value),
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Glow enabled'),
          value: provider.state.aiAvatarGlowEnabled,
          onChanged: (value) =>
              provider.controller.setAiAvatarGlowEnabled(value),
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Halo enabled'),
          value: provider.state.aiAvatarHaloEnabled,
          onChanged: (value) =>
              provider.controller.setAiAvatarHaloEnabled(value),
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Particles enabled'),
          value: provider.state.aiAvatarParticlesEnabled,
          onChanged: (value) =>
              provider.controller.setAiAvatarParticlesEnabled(value),
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Drop shadow'),
          value: provider.state.aiAvatarShadowEnabled,
          onChanged: (value) =>
              provider.controller.setAiAvatarShadowEnabled(value),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Border width: ${provider.state.aiAvatarBorderWidth.toStringAsFixed(1)} px',
          style: theme.textTheme.labelMedium,
        ),
        Slider.adaptive(
          value: provider.state.aiAvatarBorderWidth.clamp(0.0, 6.0),
          min: 0,
          max: 6,
          divisions: 12,
          label: '${provider.state.aiAvatarBorderWidth.toStringAsFixed(1)} px',
          onChanged: (value) =>
              provider.controller.setAiAvatarBorderWidth(value),
        ),
      ],
    );
  }
}
