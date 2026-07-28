import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/buildings/academy_building.dart';
import '../../../../../../../../features/playground/presentation/widgets/buildings/building_label.dart';
import '../../../../../../../../features/playground/presentation/widgets/buildings/building_progress.dart';
import '../../../../../../../../features/playground/presentation/widgets/buildings/playground_building.dart';
import '../../../providers/widget_builder_provider.dart';

class AcademyBuildingPreview extends StatelessWidget {
  const AcademyBuildingPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = _mapBrightness(provider.academyBuildingBrightness);
    final controlled = _buildAcademy(provider);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Academy Building', style: theme.textTheme.titleMedium),
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
                  _AcademyPresetTile(
                    title: 'Academy',
                    subtitle: 'Locked',
                    state: BuildingState.locked,
                  ),
                  _AcademyPresetTile(
                    title: 'Academy',
                    subtitle: 'Unlocked',
                    state: BuildingState.unlocked,
                  ),
                  _AcademyPresetTile(
                    title: 'Academy',
                    subtitle: 'Current',
                    state: BuildingState.current,
                  ),
                  _AcademyPresetTile(
                    title: 'Academy',
                    subtitle: 'Completed',
                    state: BuildingState.completed,
                  ),
                  _AcademyPresetTile(
                    title: 'Academy',
                    subtitle: 'Premium',
                    state: BuildingState.premium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Progress Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const [
                  _AcademyProgressTile(progress: 0.0),
                  _AcademyProgressTile(progress: 0.25),
                  _AcademyProgressTile(progress: 0.5),
                  _AcademyProgressTile(progress: 0.75),
                  _AcademyProgressTile(progress: 1.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

AcademyBuilding _buildAcademy(WidgetBuilderProvider provider) {
  return AcademyBuilding(
    state: _mapBuildingState(provider.academyBuildingState),
    progress: provider.academyBuildingProgress,
    level: provider.academyBuildingLevel,
    showLabel: provider.academyBuildingShowLabel,
    showProgress: provider.academyBuildingShowProgress,
    labelPlacement: _mapLabelPlacement(provider.academyBuildingLabelPlacement),
    labelEmphasis: _mapLabelEmphasis(provider.academyBuildingLabelEmphasis),
    progressKind: _mapProgressKind(provider.academyBuildingProgressKind),
    scale: provider.academyBuildingScale,
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

class _AcademyPresetTile extends StatelessWidget {
  const _AcademyPresetTile({
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
            child: Center(child: AcademyBuilding(state: state)),
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

class _AcademyProgressTile extends StatelessWidget {
  const _AcademyProgressTile({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 160,
            child: Center(
              child: AcademyBuilding(
                state: BuildingState.current,
                progress: progress,
                showLabel: false,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${(progress * 100).round()}%',
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
