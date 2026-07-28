import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/path/animated_path.dart';
import '../../../../../../../../features/playground/presentation/widgets/path/completed_path.dart';
import '../../../../../../../../features/playground/presentation/widgets/path/path_segment.dart';
import '../../../providers/widget_builder_provider.dart';
import 'playground_preview_tile.dart';

class PathPreview extends StatelessWidget {
  const PathPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Path', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            PlaygroundPreviewTile(
              mode: provider.pathBrightness,
              child: const _PathStage(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PathStage extends StatelessWidget {
  const _PathStage();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 360,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          CompletedPath(
            start: const Offset(40, 60),
            end: const Offset(280, 60),
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
          AnimatedPath(
            start: const Offset(40, 180),
            end: const Offset(280, 180),
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
          PathSegment(
            start: const Offset(40, 300),
            end: const Offset(280, 300),
            state: PlaygroundPathSegmentState.locked,
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
        ],
      ),
    );
  }
}
