import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/constants/playground_sizes.dart';
import '../../../providers/widget_builder_provider.dart';
import 'playground_control_dropdown.dart';

class PlaygroundCameraControls extends StatelessWidget {
  const PlaygroundCameraControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.xl),
        Text('Map Camera Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'The Playground Camera applies a Matrix4 transformation. '
          'Pick a focus target to recenter the viewport at a mock landmark.',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Zoom ${provider.playgroundCameraZoom.toStringAsFixed(2)}'),
        Slider(
          min: PlaygroundSizes.mapCameraMinScale,
          max: PlaygroundSizes.mapCameraMaxScale,
          value: provider.playgroundCameraZoom.clamp(
            PlaygroundSizes.mapCameraMinScale,
            PlaygroundSizes.mapCameraMaxScale,
          ),
          onChanged: (value) => provider.playgroundCameraZoom = value,
        ),
        const SizedBox(height: AppSpacing.md),
        PlaygroundControlDropdown(
          label: 'Focus Target',
          value: provider.playgroundCameraFocusTarget,
          values: const <String, String>{
            'center': 'Center',
            'start': 'Start',
            'end': 'End',
          },
          onChanged: (value) => provider.playgroundCameraFocusTarget = value,
        ),
        const SizedBox(height: AppSpacing.md),
        PlaygroundControlDropdown(
          label: 'Theme Preview',
          value: provider.playgroundCameraBrightness,
          values: const <String, String>{
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.playgroundCameraBrightness = value,
        ),
      ],
    );
  }
}
