import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/nodes/node_label.dart';
import '../../../providers/widget_builder_provider.dart';

class NodeLabelPreview extends StatelessWidget {
  const NodeLabelPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = _LabelDemo(
      title: provider.nodeLabelTitle,
      subtitle: provider.nodeLabelSubtitle,
      placement: _mapPlacement(provider.nodeLabelPlacement),
      emphasis: _mapEmphasis(provider.nodeLabelEmphasis),
      maxWidth: provider.nodeLabelMaxWidth,
      isVisible: provider.nodeLabelIsVisible,
    );
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Node Label', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            _ThemedLabelRow(mode: provider.nodeLabelBrightness, child: label),
            const SizedBox(height: AppSpacing.xxl),
            const _Section(
              title: 'Emphasis Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: [
                  _LabelTile(
                    label: 'Normal',
                    emphasis: NodeLabelEmphasis.normal,
                  ),
                  _LabelTile(
                    label: 'Strong',
                    emphasis: NodeLabelEmphasis.strong,
                  ),
                  _LabelTile(
                    label: 'Subtle',
                    emphasis: NodeLabelEmphasis.subtle,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const _Section(
              title: 'Content Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: [
                  _LabelTile(
                    label: 'Title Only',
                    title: 'Geometry Basics',
                    subtitle: '',
                  ),
                  _LabelTile(
                    label: 'Progress',
                    title: 'Algebra Foundations',
                    subtitle: '12 of 28 mastered',
                  ),
                  _LabelTile(
                    label: 'Long Text',
                    title: 'Advanced Probability and Statistics',
                    subtitle: 'Complete the current unit to continue',
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

class _LabelDemo extends StatelessWidget {
  const _LabelDemo({
    required this.title,
    required this.subtitle,
    required this.placement,
    required this.emphasis,
    required this.maxWidth,
    required this.isVisible,
  });

  final String title;
  final String subtitle;
  final NodeLabelPlacement placement;
  final NodeLabelEmphasis emphasis;
  final double maxWidth;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth + AppSpacing.xl,
      height: 96,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Align(
              alignment: placement == NodeLabelPlacement.above
                  ? Alignment.bottomCenter
                  : Alignment.topCenter,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          NodeLabel(
            title: title,
            subtitle: subtitle,
            placement: placement,
            emphasis: emphasis,
            maxWidth: maxWidth,
            isVisible: isVisible,
          ),
        ],
      ),
    );
  }
}

class _LabelTile extends StatelessWidget {
  const _LabelTile({
    required this.label,
    this.title = 'Algebra Foundations',
    this.subtitle = '12 of 28 mastered',
    this.emphasis = NodeLabelEmphasis.normal,
  });
  final String label;
  final String title;
  final String subtitle;
  final NodeLabelEmphasis emphasis;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LabelDemo(
            title: title,
            subtitle: subtitle,
            placement: NodeLabelPlacement.below,
            emphasis: emphasis,
            maxWidth: 150,
            isVisible: true,
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

class _ThemedLabelRow extends StatelessWidget {
  const _ThemedLabelRow({required this.mode, required this.child});
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

NodeLabelPlacement _mapPlacement(String value) {
  return value == 'above' ? NodeLabelPlacement.above : NodeLabelPlacement.below;
}

NodeLabelEmphasis _mapEmphasis(String value) {
  switch (value) {
    case 'strong':
      return NodeLabelEmphasis.strong;
    case 'subtle':
      return NodeLabelEmphasis.subtle;
    default:
      return NodeLabelEmphasis.normal;
  }
}
