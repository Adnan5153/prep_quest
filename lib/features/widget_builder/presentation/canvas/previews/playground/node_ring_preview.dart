import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/nodes/node_ring.dart';
import '../../../providers/widget_builder_provider.dart';

class NodeRingPreview extends StatelessWidget {
  const NodeRingPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = _mapBrightness(provider.nodeRingBrightness);
    final diameter = provider.nodeRingDiameter;
    final style = _mapRingStyle(provider.nodeRingKind);
    final state = _mapRingState(provider.nodeRingState);
    final stroke = provider.nodeRingStrokeWidth;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Node Ring', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            _ThemedRow(
              brightness: brightness,
              child: NodeRing(
                state: state,
                diameter: diameter,
                strokeWidth: stroke,
                style: style,
                glow: provider.nodeRingGlow,
                isAnimated: provider.nodeRingIsAnimated,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'State Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const [
                  _RingTile(label: 'Locked', state: NodeRingState.locked),
                  _RingTile(label: 'Unlocked', state: NodeRingState.unlocked),
                  _RingTile(
                    label: 'In Progress',
                    state: NodeRingState.inProgress,
                  ),
                  _RingTile(label: 'Completed', state: NodeRingState.completed),
                  _RingTile(label: 'Boss', state: NodeRingState.boss),
                  _RingTile(label: 'Premium', state: NodeRingState.premium),
                  _RingTile(label: 'Seasonal', state: NodeRingState.seasonal),
                  _RingTile(label: 'Event', state: NodeRingState.event),
                  _RingTile(label: 'Disabled', state: NodeRingState.disabled),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Style Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const [
                  _RingTile(
                    label: 'Solid',
                    state: NodeRingState.unlocked,
                    style: NodeRingStyle.solid,
                  ),
                  _RingTile(
                    label: 'Gradient',
                    state: NodeRingState.unlocked,
                    style: NodeRingStyle.gradient,
                  ),
                  _RingTile(
                    label: 'Dashed',
                    state: NodeRingState.unlocked,
                    style: NodeRingStyle.dashed,
                  ),
                  _RingTile(
                    label: 'Glowing',
                    state: NodeRingState.unlocked,
                    style: NodeRingStyle.glowing,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Size Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const [
                  _RingTile(
                    label: '56',
                    state: NodeRingState.unlocked,
                    diameter: 56,
                  ),
                  _RingTile(
                    label: '80',
                    state: NodeRingState.unlocked,
                    diameter: 80,
                  ),
                  _RingTile(
                    label: '104',
                    state: NodeRingState.unlocked,
                    diameter: 104,
                  ),
                  _RingTile(
                    label: '128',
                    state: NodeRingState.unlocked,
                    diameter: 128,
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

class _RingTile extends StatelessWidget {
  const _RingTile({
    required this.label,
    required this.state,
    this.style = NodeRingStyle.gradient,
    this.diameter = 80,
  });

  final String label;
  final NodeRingState state;
  final NodeRingStyle style;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: diameter + AppSpacing.lg * 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: diameter + 8,
            child: Center(
              child: NodeRing(state: state, style: style, diameter: diameter),
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
  const _ThemedRow({required this.brightness, required this.child});
  final _BrightnessMode brightness;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    switch (brightness) {
      case _BrightnessMode.light:
        return _tile(Brightness.light, child);
      case _BrightnessMode.dark:
        return _tile(Brightness.dark, child);
      case _BrightnessMode.sideBySide:
        return LayoutBuilder(
          builder: (context, constraints) {
            final half = constraints.maxWidth >= 480;
            final tiles = <Widget>[
              SizedBox(
                width: half ? (constraints.maxWidth - AppSpacing.lg) / 2 : null,
                child: _tile(Brightness.light, child),
              ),
              SizedBox(
                width: half ? (constraints.maxWidth - AppSpacing.lg) / 2 : null,
                child: _tile(Brightness.dark, child),
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
  }

  Widget _tile(Brightness b, Widget child) {
    final theme = b == Brightness.dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);
    return Container(
      decoration: BoxDecoration(
        color: b == Brightness.dark
            ? const Color(0xFF15151B)
            : const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: theme,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(child: child),
        ),
      ),
    );
  }
}

enum _BrightnessMode { light, dark, sideBySide }

_BrightnessMode _mapBrightness(String value) {
  switch (value) {
    case 'lightOnly':
      return _BrightnessMode.light;
    case 'darkOnly':
      return _BrightnessMode.dark;
    default:
      return _BrightnessMode.sideBySide;
  }
}

NodeRingState _mapRingState(String value) {
  switch (value) {
    case 'locked':
      return NodeRingState.locked;
    case 'inProgress':
      return NodeRingState.inProgress;
    case 'completed':
      return NodeRingState.completed;
    case 'boss':
      return NodeRingState.boss;
    case 'premium':
      return NodeRingState.premium;
    case 'seasonal':
      return NodeRingState.seasonal;
    case 'event':
      return NodeRingState.event;
    case 'disabled':
      return NodeRingState.disabled;
    case 'unknown':
      return NodeRingState.unknown;
    default:
      return NodeRingState.unlocked;
  }
}

NodeRingStyle _mapRingStyle(String value) {
  switch (value) {
    case 'solid':
      return NodeRingStyle.solid;
    case 'dashed':
      return NodeRingStyle.dashed;
    case 'glowing':
      return NodeRingStyle.glowing;
    default:
      return NodeRingStyle.gradient;
  }
}
