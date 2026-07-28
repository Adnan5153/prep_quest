import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/decorations/mountain.dart'
    show Mountain, MountainLayer, MountainKind;
import '../../../providers/widget_builder_provider.dart';

class MountainPreview extends StatelessWidget {
  const MountainPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mountain = Mountain(
      layer: _mapLayer(provider.mountainLayer),
      kind: _mapKind(provider.mountainKind),
      scale: provider.mountainScale,
    );
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Mountain', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            _ThemedTileRow(mode: provider.mountainBrightness, child: mountain),
            const SizedBox(height: AppSpacing.xxl),
            const _Section(
              title: 'Kind Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: [
                  _MountainTile(
                    label: 'Rocky',
                    kind: MountainKind.rocky,
                    layer: MountainLayer.mid,
                  ),
                  _MountainTile(
                    label: 'Snowy',
                    kind: MountainKind.snowy,
                    layer: MountainLayer.mid,
                  ),
                  _MountainTile(
                    label: 'Sandy',
                    kind: MountainKind.sandy,
                    layer: MountainLayer.mid,
                  ),
                  _MountainTile(
                    label: 'Volcanic',
                    kind: MountainKind.volcanic,
                    layer: MountainLayer.mid,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const _Section(
              title: 'Layered Composition',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: [
                  _MountainTile(
                    label: 'Back',
                    kind: MountainKind.rocky,
                    layer: MountainLayer.back,
                  ),
                  _MountainTile(
                    label: 'Mid',
                    kind: MountainKind.rocky,
                    layer: MountainLayer.mid,
                  ),
                  _MountainTile(
                    label: 'Front',
                    kind: MountainKind.rocky,
                    layer: MountainLayer.front,
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

class _MountainTile extends StatelessWidget {
  const _MountainTile({
    required this.label,
    required this.kind,
    required this.layer,
  });
  final String label;
  final MountainKind kind;
  final MountainLayer layer;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 160,
            child: Center(
              child: Mountain(layer: layer, kind: kind),
            ),
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

MountainLayer _mapLayer(String value) {
  switch (value) {
    case 'back':
      return MountainLayer.back;
    case 'front':
      return MountainLayer.front;
    default:
      return MountainLayer.mid;
  }
}

MountainKind _mapKind(String value) {
  switch (value) {
    case 'snowy':
      return MountainKind.snowy;
    case 'sandy':
      return MountainKind.sandy;
    case 'volcanic':
      return MountainKind.volcanic;
    default:
      return MountainKind.rocky;
  }
}
