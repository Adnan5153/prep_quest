import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/nodes/node_progress_indicator.dart';
import '../../../providers/widget_builder_provider.dart';

class NodeProgressIndicatorPreview extends StatelessWidget {
  const NodeProgressIndicatorPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicator = NodeProgressIndicator(
      progress: provider.nodeProgressValue,
      state: _mapState(provider.nodeProgressState),
      diameter: provider.nodeProgressDiameter,
      strokeWidth: provider.nodeProgressStrokeWidth,
      showLabel: provider.nodeProgressShowLabel,
      completedLabel: provider.nodeProgressCompletedLabel,
    );
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Node Progress Indicator', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            _ThemedRow(mode: provider.nodeProgressBrightness, child: indicator),
            const SizedBox(height: AppSpacing.xxl),
            const _Section(
              title: 'State Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: [
                  _ProgressTile(
                    label: 'Indeterminate',
                    state: NodeProgressState.indeterminate,
                    progress: 0.3,
                  ),
                  _ProgressTile(
                    label: 'Empty',
                    state: NodeProgressState.empty,
                    progress: 0,
                  ),
                  _ProgressTile(
                    label: 'Partial',
                    state: NodeProgressState.partial,
                    progress: 0.5,
                  ),
                  _ProgressTile(
                    label: 'Completed',
                    state: NodeProgressState.completed,
                    progress: 1,
                  ),
                  _ProgressTile(
                    label: 'Failed',
                    state: NodeProgressState.failed,
                    progress: 0.4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const _Section(
              title: 'Progress Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: [
                  _ProgressTile(
                    label: '0%',
                    state: NodeProgressState.partial,
                    progress: 0,
                  ),
                  _ProgressTile(
                    label: '25%',
                    state: NodeProgressState.partial,
                    progress: 0.25,
                  ),
                  _ProgressTile(
                    label: '50%',
                    state: NodeProgressState.partial,
                    progress: 0.5,
                  ),
                  _ProgressTile(
                    label: '75%',
                    state: NodeProgressState.partial,
                    progress: 0.75,
                  ),
                  _ProgressTile(
                    label: '100%',
                    state: NodeProgressState.completed,
                    progress: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const _Section(
              title: 'Size Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: [
                  _ProgressTile(
                    label: '48',
                    state: NodeProgressState.partial,
                    progress: 0.5,
                    diameter: 48,
                  ),
                  _ProgressTile(
                    label: '64',
                    state: NodeProgressState.partial,
                    progress: 0.5,
                    diameter: 64,
                  ),
                  _ProgressTile(
                    label: '96',
                    state: NodeProgressState.partial,
                    progress: 0.5,
                    diameter: 96,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressTile extends StatelessWidget {
  const _ProgressTile({
    required this.label,
    required this.state,
    required this.progress,
    this.diameter = 64,
  });
  final String label;
  final NodeProgressState state;
  final double progress;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: diameter + 16,
            child: Center(
              child: NodeProgressIndicator(
                progress: progress,
                state: state,
                diameter: diameter,
                showLabel: false,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpacing.md),
        child,
      ],
    );
  }
}

class _ThemedRow extends StatelessWidget {
  const _ThemedRow({required this.mode, required this.child});
  final String mode;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (mode == 'lightOnly') return _tile(Brightness.light);
    if (mode == 'darkOnly') return _tile(Brightness.dark);
    return LayoutBuilder(
      builder: (context, constraints) {
        final half = constraints.maxWidth >= 480;
        final tiles = <Widget>[
          SizedBox(
            width: half ? (constraints.maxWidth - AppSpacing.lg) / 2 : null,
            child: _tile(Brightness.light),
          ),
          SizedBox(
            width: half ? (constraints.maxWidth - AppSpacing.lg) / 2 : null,
            child: _tile(Brightness.dark),
          ),
        ];
        return half
            ? Row(children: tiles)
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  tiles[0],
                  const SizedBox(height: AppSpacing.lg),
                  tiles[1],
                ],
              );
      },
    );
  }

  Widget _tile(Brightness brightness) {
    final theme = brightness == Brightness.dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: brightness == Brightness.dark
            ? const Color(0xFF15151B)
            : const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: theme,
        child: Center(child: child),
      ),
    );
  }
}

NodeProgressState _mapState(String value) {
  switch (value) {
    case 'indeterminate':
      return NodeProgressState.indeterminate;
    case 'empty':
      return NodeProgressState.empty;
    case 'completed':
      return NodeProgressState.completed;
    case 'failed':
      return NodeProgressState.failed;
    default:
      return NodeProgressState.partial;
  }
}
