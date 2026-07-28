import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/buildings/building_label.dart';
import '../../../../../../../../features/playground/presentation/widgets/buildings/building_progress.dart';
import '../../../../../../../../features/playground/presentation/widgets/buildings/library_building.dart';
import '../../../../../../../../features/playground/presentation/widgets/buildings/playground_building.dart';
import '../../../providers/widget_builder_provider.dart';

class LibraryBuildingPreview extends StatelessWidget {
  const LibraryBuildingPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = _mapBrightness(provider.libraryBuildingBrightness);
    final controlled = _buildLibrary(provider);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Library Building', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            _ThemedTileRow(brightness: brightness, child: controlled),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'State Presets',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const [
                  _LibraryPresetTile(
                    title: 'Library',
                    subtitle: 'Locked',
                    state: BuildingState.locked,
                  ),
                  _LibraryPresetTile(
                    title: 'Library',
                    subtitle: 'Unlocked',
                    state: BuildingState.unlocked,
                  ),
                  _LibraryPresetTile(
                    title: 'Library',
                    subtitle: 'Current',
                    state: BuildingState.current,
                  ),
                  _LibraryPresetTile(
                    title: 'Library',
                    subtitle: 'Completed',
                    state: BuildingState.completed,
                  ),
                  _LibraryPresetTile(
                    title: 'Library',
                    subtitle: 'Premium',
                    state: BuildingState.premium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Label Placement',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const [
                  _LibraryLabelTile(
                    title: 'Library',
                    subtitle: 'Below',
                    placement: BuildingLabelPlacement.below,
                  ),
                  _LibraryLabelTile(
                    title: 'Library',
                    subtitle: 'Above',
                    placement: BuildingLabelPlacement.above,
                  ),
                  _LibraryLabelTile(
                    title: 'Library',
                    subtitle: 'Strong',
                    placement: BuildingLabelPlacement.below,
                    emphasis: BuildingLabelEmphasis.strong,
                  ),
                  _LibraryLabelTile(
                    title: 'Library',
                    subtitle: 'Subtle',
                    placement: BuildingLabelPlacement.below,
                    emphasis: BuildingLabelEmphasis.subtle,
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

LibraryBuilding _buildLibrary(WidgetBuilderProvider provider) {
  return LibraryBuilding(
    state: _mapBuildingState(provider.libraryBuildingState),
    progress: provider.libraryBuildingProgress,
    level: provider.libraryBuildingLevel,
    showLabel: provider.libraryBuildingShowLabel,
    showProgress: provider.libraryBuildingShowProgress,
    labelPlacement: _mapLabelPlacement(provider.libraryBuildingLabelPlacement),
    labelEmphasis: _mapLabelEmphasis(provider.libraryBuildingLabelEmphasis),
    progressKind: _mapProgressKind(provider.libraryBuildingProgressKind),
    scale: provider.libraryBuildingScale,
  );
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

class _LibraryPresetTile extends StatelessWidget {
  const _LibraryPresetTile({
    required this.title,
    required this.subtitle,
    required this.state,
  });

  final String title;
  final String subtitle;
  final BuildingState state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 160,
            child: Center(child: LibraryBuilding(state: state)),
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

class _LibraryLabelTile extends StatelessWidget {
  const _LibraryLabelTile({
    required this.title,
    required this.subtitle,
    required this.placement,
    this.emphasis = BuildingLabelEmphasis.normal,
  });

  final String title;
  final String subtitle;
  final BuildingLabelPlacement placement;
  final BuildingLabelEmphasis emphasis;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 200,
            child: Center(
              child: LibraryBuilding(
                state: BuildingState.current,
                showProgress: false,
                labelPlacement: placement,
                labelEmphasis: emphasis,
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
