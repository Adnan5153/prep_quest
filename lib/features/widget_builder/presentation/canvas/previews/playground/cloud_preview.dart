import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/decorations/cloud.dart';
import '../../../providers/widget_builder_provider.dart';

class CloudPreview extends StatelessWidget {
  const CloudPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cloud = Cloud(
      kind: _mapKind(provider.cloudKind),
      scale: provider.cloudScale,
      seed: provider.cloudSeed,
    );
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Cloud', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            _ThemedTileRow(mode: provider.cloudBrightness, child: cloud),
            const SizedBox(height: AppSpacing.xxl),
            const _Section(
              title: 'Kind Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: [
                  _CloudTile(label: 'Fluffy', kind: CloudKind.fluffy),
                  _CloudTile(label: 'Thin', kind: CloudKind.thin),
                  _CloudTile(label: 'Storm', kind: CloudKind.storm),
                  _CloudTile(label: 'Golden', kind: CloudKind.golden),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CloudTile extends StatelessWidget {
  const _CloudTile({required this.label, required this.kind});
  final String label;
  final CloudKind kind;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 130,
            child: Center(child: Cloud(kind: kind)),
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

CloudKind _mapKind(String value) {
  switch (value) {
    case 'thin':
      return CloudKind.thin;
    case 'storm':
      return CloudKind.storm;
    case 'golden':
      return CloudKind.golden;
    default:
      return CloudKind.fluffy;
  }
}
