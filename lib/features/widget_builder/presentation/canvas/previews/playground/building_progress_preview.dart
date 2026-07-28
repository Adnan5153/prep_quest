import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/buildings/building_progress.dart';
import '../../../providers/widget_builder_provider.dart';

class BuildingProgressPreview extends StatelessWidget {
  const BuildingProgressPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = _mapBrightness(provider.buildingProgressBrightness);
    final controlled = BuildingProgress(
      progress: provider.buildingProgressValue,
      kind: _mapProgressKind(provider.buildingProgressKind),
      level: provider.buildingProgressLevel,
      size: provider.buildingProgressSize,
    );

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Building Progress', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            _ThemedTileRow(brightness: brightness, child: controlled),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Kind Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const [
                  _KindTile(
                    kind: BuildingProgressKind.percent,
                    title: 'Percent',
                    subtitle: 'Percentage arc',
                  ),
                  _KindTile(
                    kind: BuildingProgressKind.level,
                    title: 'Level',
                    subtitle: 'Level number',
                  ),
                  _KindTile(
                    kind: BuildingProgressKind.levelUp,
                    title: 'Level Up',
                    subtitle: 'Level up ring',
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
                  _ProgressTile(progress: 0.0),
                  _ProgressTile(progress: 0.25),
                  _ProgressTile(progress: 0.5),
                  _ProgressTile(progress: 0.75),
                  _ProgressTile(progress: 1.0),
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
                  _SizeTile(size: 40),
                  _SizeTile(size: 56),
                  _SizeTile(size: 72),
                  _SizeTile(size: 96),
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

class _KindTile extends StatelessWidget {
  const _KindTile({
    required this.kind,
    required this.title,
    required this.subtitle,
  });

  final BuildingProgressKind kind;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 110,
            child: Center(
              child: BuildingProgress(
                progress: 0.65,
                kind: kind,
                level: 4,
                size: 72,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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

class _ProgressTile extends StatelessWidget {
  const _ProgressTile({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 100,
            child: Center(
              child: BuildingProgress(
                progress: progress,
                kind: BuildingProgressKind.percent,
                size: 64,
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

class _SizeTile extends StatelessWidget {
  const _SizeTile({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 120,
            child: Center(
              child: BuildingProgress(
                progress: 0.6,
                kind: BuildingProgressKind.percent,
                size: size,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${size.round()} px',
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
