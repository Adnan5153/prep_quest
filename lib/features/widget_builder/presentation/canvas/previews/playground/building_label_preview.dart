import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/buildings/building_label.dart';
import '../../../providers/widget_builder_provider.dart';

class BuildingLabelPreview extends StatelessWidget {
  const BuildingLabelPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = _mapBrightness(provider.buildingLabelBrightness);
    final label = BuildingLabel(
      title: provider.buildingLabelTitle,
      subtitle: provider.buildingLabelSubtitle,
      placement: _mapLabelPlacement(provider.buildingLabelPlacement),
      emphasis: _mapLabelEmphasis(provider.buildingLabelEmphasis),
      maxWidth: provider.buildingLabelMaxWidth,
      isVisible: provider.buildingLabelIsVisible,
    );

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Building Label', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            _ThemedTileRow(
              brightness: brightness,
              child: _LabelStage(
                placement: _mapLabelPlacement(provider.buildingLabelPlacement),
                child: label,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Emphasis Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const [
                  _EmphasisTile(emphasis: BuildingLabelEmphasis.normal),
                  _EmphasisTile(emphasis: BuildingLabelEmphasis.strong),
                  _EmphasisTile(emphasis: BuildingLabelEmphasis.subtle),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Long-text Variants',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const [
                  _LongTextTile(
                    title: 'Algebra Foundations',
                    subtitle: '12 of 28 mastered',
                  ),
                  _LongTextTile(
                    title: 'Quadratic Equations & Polynomials',
                    subtitle: 'Master the quadratic formula',
                  ),
                  _LongTextTile(title: 'Statistics', subtitle: 'Members only'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LabelStage extends StatelessWidget {
  const _LabelStage({required this.placement, required this.child});
  final BuildingLabelPlacement placement;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 180,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 70,
            right: 70,
            top: 70,
            child: Container(
              width: 80,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFE6C58F),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          child,
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

class _EmphasisTile extends StatelessWidget {
  const _EmphasisTile({required this.emphasis});
  final BuildingLabelEmphasis emphasis;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 140,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 60,
                  right: 60,
                  top: 50,
                  child: Container(
                    width: 60,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6FA8D6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                BuildingLabel(
                  title: 'Algebra',
                  subtitle: 'Theory',
                  emphasis: emphasis,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(_label(emphasis), style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }

  String _label(BuildingLabelEmphasis emphasis) {
    switch (emphasis) {
      case BuildingLabelEmphasis.normal:
        return 'Normal';
      case BuildingLabelEmphasis.strong:
        return 'Strong';
      case BuildingLabelEmphasis.subtle:
        return 'Subtle';
    }
  }
}

class _LongTextTile extends StatelessWidget {
  const _LongTextTile({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 140,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 70,
                  right: 70,
                  top: 50,
                  child: Container(
                    width: 60,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6FA8D6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                BuildingLabel(title: title, subtitle: subtitle),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
