import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/decorations/river.dart';
import '../../../providers/widget_builder_provider.dart';

class RiverPreview extends StatelessWidget {
  const RiverPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final river = SizedBox(
      width: 320,
      child: River(
        curve: _mapCurve(provider.riverCurve),
        height: provider.riverHeight,
        seed: provider.riverSeed,
      ),
    );
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('River', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            _ThemedTileRow(mode: provider.riverBrightness, child: river),
            const SizedBox(height: AppSpacing.xxl),
            const _Section(
              title: 'Curve Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: [
                  _RiverTile(label: 'Straight', curve: RiverCurve.straight),
                  _RiverTile(label: 'Meander', curve: RiverCurve.meander),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiverTile extends StatelessWidget {
  const _RiverTile({required this.label, required this.curve});
  final String label;
  final RiverCurve curve;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 100,
            child: Center(child: River(curve: curve, height: 80)),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
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

class _ThemedTileRow extends StatelessWidget {
  const _ThemedTileRow({required this.mode, required this.child});
  final String mode;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (mode == 'lightOnly') return _tile(Brightness.light);
    if (mode == 'darkOnly') return _tile(Brightness.dark);
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 480;
        final halfWidth = wide
            ? (constraints.maxWidth - AppSpacing.lg) / 2
            : null;
        final tiles = <Widget>[
          SizedBox(width: halfWidth, child: _tile(Brightness.light)),
          SizedBox(width: halfWidth, child: _tile(Brightness.dark)),
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

  Widget _tile(Brightness brightness) {
    final theme = brightness == Brightness.dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
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

RiverCurve _mapCurve(String value) {
  switch (value) {
    case 'meander':
      return RiverCurve.meander;
    default:
      return RiverCurve.straight;
  }
}
