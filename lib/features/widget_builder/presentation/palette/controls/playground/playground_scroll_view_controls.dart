import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/constants/playground_sizes.dart';
import '../../../providers/widget_builder_provider.dart';
import 'playground_control_dropdown.dart';

class PlaygroundScrollViewControls extends StatelessWidget {
  const PlaygroundScrollViewControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.xl),
        Text('Map Scroll View Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'The Playground Scroll View wraps an InteractiveViewer and syncs '
          'with the Playground Camera. Drag inside the preview to pan.',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Zoom ${provider.playgroundScrollViewZoom.toStringAsFixed(2)}'),
        Slider(
          min: PlaygroundSizes.mapCameraMinScale,
          max: PlaygroundSizes.mapCameraMaxScale,
          value: provider.playgroundScrollViewZoom.clamp(
            PlaygroundSizes.mapCameraMinScale,
            PlaygroundSizes.mapCameraMaxScale,
          ),
          onChanged: (value) => provider.playgroundScrollViewZoom = value,
        ),
        const SizedBox(height: AppSpacing.md),
        PlaygroundControlDropdown(
          label: 'Focus Target',
          value: provider.playgroundScrollViewFocusTarget,
          values: const <String, String>{
            'none': 'None',
            'start': 'Start',
            'center': 'Center',
            'end': 'End',
          },
          onChanged: (value) =>
              provider.playgroundScrollViewFocusTarget = value,
        ),
        const SizedBox(height: AppSpacing.md),
        PlaygroundControlDropdown(
          label: 'Theme Preview',
          value: provider.playgroundScrollViewBrightness,
          values: const <String, String>{
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.playgroundScrollViewBrightness = value,
        ),
      ],
    );
  }
}
