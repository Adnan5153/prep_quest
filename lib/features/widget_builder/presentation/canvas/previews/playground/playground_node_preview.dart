import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/nodes/node_badge.dart';
import '../../../../../../../../features/playground/presentation/widgets/nodes/node_icon.dart';
import '../../../../../../../../features/playground/presentation/widgets/nodes/node_progress_indicator.dart';
import '../../../../../../../../features/playground/presentation/widgets/nodes/node_ring.dart';
import '../../../../../../../../features/playground/presentation/widgets/nodes/playground_node.dart';
import '../../../providers/widget_builder_provider.dart';

class PlaygroundNodePreview extends StatelessWidget {
  const PlaygroundNodePreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = _mapBrightness(provider.playgroundNodeBrightness);
    final diameter = provider.playgroundNodeDiameter;
    final visual = _buildVisual(provider);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Playground Node', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            _ThemedTileRow(
              brightness: brightness,
              child: PlaygroundNode(
                visual: visual,
                diameter: diameter,
                ringStyle: _mapRingStyle(provider.playgroundNodeRingKind),
                onTap: () {},
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'State Presets',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const [
                  _PresetTile(
                    title: 'Fractions Lab',
                    subtitle: 'Locked',
                    visual: _lockedVisual,
                  ),
                  _PresetTile(
                    title: 'Algebra Foundations',
                    subtitle: 'Available',
                    visual: _availableVisual,
                  ),
                  _PresetTile(
                    title: 'Algebra Foundations',
                    subtitle: '12 of 28 mastered',
                    visual: _currentVisual,
                  ),
                  _PresetTile(
                    title: 'Geometry Basics',
                    subtitle: 'Completed',
                    visual: _completedVisual,
                  ),
                  _PresetTile(
                    title: 'Perfect Run',
                    subtitle: 'No mistakes',
                    visual: _perfectVisual,
                  ),
                  _PresetTile(
                    title: 'Quadratic Boss Gate',
                    subtitle: '3 attempts left',
                    visual: _bossVisual,
                  ),
                  _PresetTile(
                    title: 'Statistics',
                    subtitle: 'Members only',
                    visual: _premiumVisual,
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
                  _SizedTile(diameter: 56),
                  _SizedTile(diameter: 80),
                  _SizedTile(diameter: 104),
                  _SizedTile(diameter: 128),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'XP & Badges',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const [
                  _XPGalleryItem(
                    title: '+60 XP',
                    subtitle: 'Daily Login',
                    badge: NodeBadgeKind.xp,
                  ),
                  _XPGalleryItem(
                    title: '+250 XP',
                    subtitle: 'Perfect Quiz',
                    badge: NodeBadgeKind.completed,
                  ),
                  _XPGalleryItem(
                    title: '+500 XP',
                    subtitle: 'Boss Defeated',
                    badge: NodeBadgeKind.boss,
                  ),
                  _XPGalleryItem(
                    title: 'NEW',
                    subtitle: 'Seasonal Event',
                    badge: NodeBadgeKind.newBadge,
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

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.md),
        child,
      ],
    );
  }
}

class _PresetTile extends StatelessWidget {
  const _PresetTile({
    required this.title,
    required this.subtitle,
    required this.visual,
  });

  final String title;
  final String subtitle;
  final NodeVisual visual;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 128,
            child: Center(child: PlaygroundNode(visual: visual)),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.labelSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SizedTile extends StatelessWidget {
  const _SizedTile({required this.diameter});
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: diameter + AppSpacing.lg * 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: PlaygroundNode(visual: _currentVisual, diameter: diameter),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${diameter.round()} px',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _XPGalleryItem extends StatelessWidget {
  const _XPGalleryItem({
    required this.title,
    required this.subtitle,
    required this.badge,
  });

  final String title;
  final String subtitle;
  final NodeBadgeKind badge;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 96,
            child: Center(
              child: PlaygroundNode(
                visual: NodeVisual(
                  kind: NodeIconKind.regular,
                  ringState: NodeRingState.unlocked,
                  iconKind: NodeIconKind.regular,
                  iconVariant: NodeIconVariant.filled,
                  progress: 1.0,
                  progressState: NodeProgressState.completed,
                  title: title,
                  subtitle: subtitle,
                  badgeKind: badge,
                  isInteractive: true,
                  showLabel: true,
                  showProgress: false,
                  showBadge: true,
                ),
                diameter: 80,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.labelSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ThemedTileRow extends StatelessWidget {
  const _ThemedTileRow({required this.brightness, required this.child});
  final _BrightnessMode brightness;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    switch (brightness) {
      case _BrightnessMode.light:
        return SizedBox(
          width: double.infinity,
          child: _ThemedTile(
            brightness: Brightness.light,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(child: child),
            ),
          ),
        );
      case _BrightnessMode.dark:
        return SizedBox(
          width: double.infinity,
          child: _ThemedTile(
            brightness: Brightness.dark,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(child: child),
            ),
          ),
        );
      case _BrightnessMode.sideBySide:
        return LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 480;
            final halfWidth = wide ? (constraints.maxWidth - 12) / 2 : null;
            final tiles = <Widget>[
              SizedBox(
                width: halfWidth,
                child: _ThemedTile(
                  brightness: Brightness.light,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Center(child: child),
                  ),
                ),
              ),
              SizedBox(
                width: halfWidth,
                child: _ThemedTile(
                  brightness: Brightness.dark,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Center(child: child),
                  ),
                ),
              ),
            ];
            return wide
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
}

class _ThemedTile extends StatelessWidget {
  const _ThemedTile({required this.brightness, required this.child});
  final Brightness brightness;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = brightness == Brightness.dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);
    return Container(
      decoration: BoxDecoration(
        color: brightness == Brightness.dark
            ? const Color(0xFF15151B)
            : const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(data: theme, child: child),
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

NodeIconKind _mapIconKind(String value) {
  switch (value) {
    case 'boss':
      return NodeIconKind.boss;
    case 'library':
      return NodeIconKind.library;
    case 'premium':
      return NodeIconKind.premium;
    case 'event':
      return NodeIconKind.event;
    case 'daily':
      return NodeIconKind.daily;
    case 'tournament':
      return NodeIconKind.tournament;
    case 'seasonal':
      return NodeIconKind.seasonal;
    case 'completed':
      return NodeIconKind.completed;
    case 'locked':
      return NodeIconKind.locked;
    case 'unknown':
      return NodeIconKind.unknown;
    default:
      return NodeIconKind.regular;
  }
}

NodeIconVariant _mapIconVariant(String value) {
  switch (value) {
    case 'outlined':
      return NodeIconVariant.outlined;
    case 'tonal':
      return NodeIconVariant.tonal;
    case 'glyph':
      return NodeIconVariant.glyph;
    default:
      return NodeIconVariant.filled;
  }
}

NodeProgressState _mapProgressState(String value) {
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

NodeBadgeKind? _mapBadgeKind(String value) {
  switch (value) {
    case 'boss':
      return NodeBadgeKind.boss;
    case 'library':
      return NodeBadgeKind.library;
    case 'premium':
      return NodeBadgeKind.premium;
    case 'event':
      return NodeBadgeKind.event;
    case 'daily':
      return NodeBadgeKind.daily;
    case 'tournament':
      return NodeBadgeKind.tournament;
    case 'seasonal':
      return NodeBadgeKind.seasonal;
    case 'xp':
      return NodeBadgeKind.xp;
    case 'completed':
      return NodeBadgeKind.completed;
    case 'newBadge':
      return NodeBadgeKind.newBadge;
    default:
      return null;
  }
}

NodeVisual _buildVisual(WidgetBuilderProvider provider) {
  return NodeVisual(
    kind: _mapIconKind(provider.playgroundNodeIconKind),
    ringState: _mapRingState(provider.playgroundNodeRingState),
    iconKind: _mapIconKind(provider.playgroundNodeIconKind),
    iconVariant: _mapIconVariant(provider.playgroundNodeIconVariant),
    progress: provider.playgroundNodeProgress,
    progressState: _mapProgressState(provider.playgroundNodeProgressState),
    title: provider.playgroundNodeTitle,
    subtitle: provider.playgroundNodeSubtitle,
    badgeKind: provider.playgroundNodeShowBadge
        ? _mapBadgeKind(provider.playgroundNodeBadgeKind)
        : null,
    isInteractive: provider.playgroundNodeIsInteractive,
    showLabel: provider.playgroundNodeShowLabel,
    showProgress: provider.playgroundNodeShowProgress,
    showBadge: provider.playgroundNodeShowBadge,
  );
}

const NodeVisual _lockedVisual = NodeVisual(
  kind: NodeIconKind.locked,
  ringState: NodeRingState.locked,
  iconKind: NodeIconKind.locked,
  iconVariant: NodeIconVariant.filled,
  progress: 0,
  progressState: NodeProgressState.empty,
  title: 'Fractions Lab',
  subtitle: 'Locked',
  badgeKind: null,
  isInteractive: false,
  showLabel: true,
  showProgress: false,
  showBadge: false,
);

const NodeVisual _availableVisual = NodeVisual(
  kind: NodeIconKind.regular,
  ringState: NodeRingState.unlocked,
  iconKind: NodeIconKind.regular,
  iconVariant: NodeIconVariant.filled,
  progress: 0,
  progressState: NodeProgressState.empty,
  title: 'Algebra Foundations',
  subtitle: 'Available',
  badgeKind: NodeBadgeKind.xp,
  isInteractive: true,
  showLabel: true,
  showProgress: false,
  showBadge: true,
);

const NodeVisual _currentVisual = NodeVisual(
  kind: NodeIconKind.regular,
  ringState: NodeRingState.inProgress,
  iconKind: NodeIconKind.regular,
  iconVariant: NodeIconVariant.filled,
  progress: 0.42,
  progressState: NodeProgressState.partial,
  title: 'Algebra Foundations',
  subtitle: '12 of 28 mastered',
  badgeKind: NodeBadgeKind.xp,
  isInteractive: true,
  showLabel: true,
  showProgress: true,
  showBadge: true,
);

const NodeVisual _completedVisual = NodeVisual(
  kind: NodeIconKind.completed,
  ringState: NodeRingState.completed,
  iconKind: NodeIconKind.completed,
  iconVariant: NodeIconVariant.filled,
  progress: 1,
  progressState: NodeProgressState.completed,
  title: 'Geometry Basics',
  subtitle: 'Completed',
  badgeKind: NodeBadgeKind.completed,
  isInteractive: true,
  showLabel: true,
  showProgress: true,
  showBadge: true,
);

const NodeVisual _perfectVisual = NodeVisual(
  kind: NodeIconKind.completed,
  ringState: NodeRingState.completed,
  iconKind: NodeIconKind.completed,
  iconVariant: NodeIconVariant.glyph,
  progress: 1,
  progressState: NodeProgressState.completed,
  title: 'Perfect Run',
  subtitle: 'No mistakes',
  badgeKind: NodeBadgeKind.completed,
  isInteractive: true,
  showLabel: true,
  showProgress: true,
  showBadge: true,
);

const NodeVisual _bossVisual = NodeVisual(
  kind: NodeIconKind.boss,
  ringState: NodeRingState.boss,
  iconKind: NodeIconKind.boss,
  iconVariant: NodeIconVariant.filled,
  progress: 0.66,
  progressState: NodeProgressState.partial,
  title: 'Quadratic Boss Gate',
  subtitle: '3 attempts left',
  badgeKind: NodeBadgeKind.boss,
  isInteractive: true,
  showLabel: true,
  showProgress: true,
  showBadge: true,
);

const NodeVisual _premiumVisual = NodeVisual(
  kind: NodeIconKind.premium,
  ringState: NodeRingState.premium,
  iconKind: NodeIconKind.premium,
  iconVariant: NodeIconVariant.filled,
  progress: 0,
  progressState: NodeProgressState.empty,
  title: 'Statistics',
  subtitle: 'Members only',
  badgeKind: NodeBadgeKind.premium,
  isInteractive: true,
  showLabel: true,
  showProgress: false,
  showBadge: true,
);
