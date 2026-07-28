import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/buildings/building_label.dart';
import '../../../../../../../../features/playground/presentation/widgets/buildings/building_progress.dart';
import '../../../../../../../../features/playground/presentation/widgets/buildings/playground_building.dart';
import '../../../providers/widget_builder_provider.dart';

class PlaygroundBuildingPreview extends StatelessWidget {
  const PlaygroundBuildingPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = _mapBrightness(provider.playgroundBuildingBrightness);
    final visual = _buildVisual(provider);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Playground Building', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            _ThemedTileRow(
              brightness: brightness,
              child: PlaygroundBuilding(
                visual: visual,
                sprite: _SampleBuildingSprite(
                  scale: provider.playgroundBuildingScale,
                ),
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
                    title: 'Knowledge Hub',
                    subtitle: 'Locked',
                    visual: _lockedVisual,
                  ),
                  _PresetTile(
                    title: 'Knowledge Hub',
                    subtitle: 'Unlocked',
                    visual: _unlockedVisual,
                  ),
                  _PresetTile(
                    title: 'Knowledge Hub',
                    subtitle: 'In progress',
                    visual: _currentVisual,
                  ),
                  _PresetTile(
                    title: 'Knowledge Hub',
                    subtitle: 'Completed',
                    visual: _completedVisual,
                  ),
                  _PresetTile(
                    title: 'Knowledge Hub',
                    subtitle: 'Premium',
                    visual: _premiumVisual,
                  ),
                  _PresetTile(
                    title: 'Knowledge Hub',
                    subtitle: 'Selected',
                    visual: _selectedVisual,
                  ),
                  _PresetTile(
                    title: 'Knowledge Hub',
                    subtitle: 'Disabled',
                    visual: _disabledVisual,
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
                  _SizedTile(scale: 0.7),
                  _SizedTile(scale: 1.0),
                  _SizedTile(scale: 1.3),
                  _SizedTile(scale: 1.6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SampleBuildingSprite extends StatelessWidget {
  const _SampleBuildingSprite({required this.scale});
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120 * scale,
      height: 96 * scale,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFB4D8F0), Color(0xFF6FA8D6)],
        ),
        borderRadius: BorderRadius.circular(8 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 80 * scale,
        height: 30 * scale,
        decoration: BoxDecoration(
          color: const Color(0xFFE6C58F),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40 * scale),
            topRight: Radius.circular(40 * scale),
          ),
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
  final BuildingVisual visual;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 160,
            child: Center(
              child: PlaygroundBuilding(
                visual: visual,
                sprite: _SampleBuildingSprite(scale: 1),
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

class _SizedTile extends StatelessWidget {
  const _SizedTile({required this.scale});
  final double scale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 200,
            child: Center(
              child: PlaygroundBuilding(
                visual: _currentVisual,
                sprite: _SampleBuildingSprite(scale: scale),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${(scale * 100).round()}%',
            style: Theme.of(context).textTheme.labelSmall,
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

BuildingState _mapBuildingState(String value) {
  switch (value) {
    case 'locked':
      return BuildingState.locked;
    case 'current':
      return BuildingState.current;
    case 'completed':
      return BuildingState.completed;
    case 'premium':
      return BuildingState.premium;
    default:
      return BuildingState.unlocked;
  }
}

BuildingLabelPlacement _mapLabelPlacement(String value) {
  switch (value) {
    case 'above':
      return BuildingLabelPlacement.above;
    default:
      return BuildingLabelPlacement.below;
  }
}

BuildingLabelEmphasis _mapLabelEmphasis(String value) {
  switch (value) {
    case 'strong':
      return BuildingLabelEmphasis.strong;
    case 'subtle':
      return BuildingLabelEmphasis.subtle;
    default:
      return BuildingLabelEmphasis.normal;
  }
}

BuildingProgressKind _mapProgressKind(String value) {
  switch (value) {
    case 'level':
      return BuildingProgressKind.level;
    case 'levelUp':
      return BuildingProgressKind.levelUp;
    default:
      return BuildingProgressKind.percent;
  }
}

BuildingVisual _buildVisual(WidgetBuilderProvider provider) {
  return BuildingVisual(
    state: _mapBuildingState(provider.playgroundBuildingState),
    title: provider.playgroundBuildingTitle,
    subtitle: provider.playgroundBuildingSubtitle,
    progress: provider.playgroundBuildingProgress,
    level: provider.playgroundBuildingLevel,
    isInteractive: provider.playgroundBuildingIsInteractive,
    showLabel: provider.playgroundBuildingShowLabel,
    showProgress: provider.playgroundBuildingShowProgress,
    labelPlacement: _mapLabelPlacement(
      provider.playgroundBuildingLabelPlacement,
    ),
    labelEmphasis: _mapLabelEmphasis(provider.playgroundBuildingLabelEmphasis),
    progressKind: _mapProgressKind(provider.playgroundBuildingProgressKind),
  );
}

const BuildingVisual _lockedVisual = BuildingVisual(
  state: BuildingState.locked,
  title: 'Knowledge Hub',
  subtitle: 'Locked',
  progress: 0,
  level: 1,
  isInteractive: false,
  showLabel: true,
  showProgress: false,
  labelPlacement: BuildingLabelPlacement.below,
  labelEmphasis: BuildingLabelEmphasis.normal,
  progressKind: BuildingProgressKind.percent,
);

const BuildingVisual _unlockedVisual = BuildingVisual(
  state: BuildingState.unlocked,
  title: 'Knowledge Hub',
  subtitle: 'Unlocked',
  progress: 0,
  level: 1,
  isInteractive: true,
  showLabel: true,
  showProgress: false,
  labelPlacement: BuildingLabelPlacement.below,
  labelEmphasis: BuildingLabelEmphasis.normal,
  progressKind: BuildingProgressKind.percent,
);

const BuildingVisual _currentVisual = BuildingVisual(
  state: BuildingState.current,
  title: 'Knowledge Hub',
  subtitle: 'Tap to enter',
  progress: 0.45,
  level: 2,
  isInteractive: true,
  showLabel: true,
  showProgress: true,
  labelPlacement: BuildingLabelPlacement.below,
  labelEmphasis: BuildingLabelEmphasis.normal,
  progressKind: BuildingProgressKind.percent,
);

const BuildingVisual _completedVisual = BuildingVisual(
  state: BuildingState.completed,
  title: 'Knowledge Hub',
  subtitle: 'Completed',
  progress: 1,
  level: 3,
  isInteractive: true,
  showLabel: true,
  showProgress: true,
  labelPlacement: BuildingLabelPlacement.below,
  labelEmphasis: BuildingLabelEmphasis.normal,
  progressKind: BuildingProgressKind.percent,
);

const BuildingVisual _premiumVisual = BuildingVisual(
  state: BuildingState.premium,
  title: 'Knowledge Hub',
  subtitle: 'Members only',
  progress: 0,
  level: 1,
  isInteractive: true,
  showLabel: true,
  showProgress: false,
  labelPlacement: BuildingLabelPlacement.below,
  labelEmphasis: BuildingLabelEmphasis.strong,
  progressKind: BuildingProgressKind.percent,
);

const BuildingVisual _selectedVisual = BuildingVisual(
  state: BuildingState.current,
  title: 'Knowledge Hub',
  subtitle: 'Selected',
  progress: 0.45,
  level: 2,
  isInteractive: true,
  showLabel: true,
  showProgress: true,
  labelPlacement: BuildingLabelPlacement.below,
  labelEmphasis: BuildingLabelEmphasis.strong,
  progressKind: BuildingProgressKind.percent,
);

const BuildingVisual _disabledVisual = BuildingVisual(
  state: BuildingState.locked,
  title: 'Knowledge Hub',
  subtitle: 'Disabled',
  progress: 0,
  level: 1,
  isInteractive: false,
  showLabel: true,
  showProgress: false,
  labelPlacement: BuildingLabelPlacement.below,
  labelEmphasis: BuildingLabelEmphasis.subtle,
  progressKind: BuildingProgressKind.percent,
);
