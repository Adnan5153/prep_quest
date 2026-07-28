import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/decorations/tree.dart';
import '../../../providers/widget_builder_provider.dart';

class TreePreview extends StatelessWidget {
  const TreePreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tree = Tree(
      kind: _mapKind(provider.treeKind),
      scale: provider.treeScale,
      sway: provider.treeSway,
      swaySeed: provider.treeSwaySeed,
    );
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Tree', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            _ThemedTileRow(mode: provider.treeBrightness, child: tree),
            const SizedBox(height: AppSpacing.xxl),
            const _Section(
              title: 'Kind Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: [
                  _TreeTile(label: 'Oak', kind: TreeKind.oak),
                  _TreeTile(label: 'Pine', kind: TreeKind.pine),
                  _TreeTile(label: 'Palm', kind: TreeKind.palm),
                  _TreeTile(label: 'Blossom', kind: TreeKind.blossom),
                  _TreeTile(label: 'Autumn', kind: TreeKind.autumn),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const _Section(
              title: 'Size Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: [
                  _TreeTile(label: '0.6x', kind: TreeKind.oak, scale: 0.6),
                  _TreeTile(label: '0.8x', kind: TreeKind.oak, scale: 0.8),
                  _TreeTile(label: '1.0x', kind: TreeKind.oak, scale: 1.0),
                  _TreeTile(label: '1.4x', kind: TreeKind.oak, scale: 1.4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TreeTile extends StatelessWidget {
  const _TreeTile({required this.label, required this.kind, this.scale = 1.0});
  final String label;
  final TreeKind kind;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 180,
            child: Center(
              child: Tree(kind: kind, scale: scale, sway: false),
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

TreeKind _mapKind(String value) {
  switch (value) {
    case 'pine':
      return TreeKind.pine;
    case 'palm':
      return TreeKind.palm;
    case 'blossom':
      return TreeKind.blossom;
    case 'autumn':
      return TreeKind.autumn;
    default:
      return TreeKind.oak;
  }
}
