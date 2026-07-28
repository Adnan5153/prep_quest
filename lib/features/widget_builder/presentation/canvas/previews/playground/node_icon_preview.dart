import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/nodes/node_icon.dart';
import '../../../providers/widget_builder_provider.dart';

class NodeIconPreview extends StatelessWidget {
  const NodeIconPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = NodeIcon(
      kind: _mapKind(provider.nodeIconKind),
      variant: _mapVariant(provider.nodeIconVariant),
      size: provider.nodeIconSize,
      isEnabled: provider.nodeIconIsEnabled,
    );
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Node Icon', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            _ThemedIconRow(mode: provider.nodeIconBrightness, child: icon),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Kind Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: NodeIconKind.values
                    .map((kind) => _IconTile(label: kind.name, kind: kind))
                    .toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Variant Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: NodeIconVariant.values
                    .map(
                      (variant) => _IconTile(
                        label: variant.name,
                        kind: NodeIconKind.regular,
                        variant: variant,
                      ),
                    )
                    .toList(),
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
                  _IconTile(label: '16', kind: NodeIconKind.daily, size: 16),
                  _IconTile(label: '24', kind: NodeIconKind.daily, size: 24),
                  _IconTile(label: '28', kind: NodeIconKind.daily, size: 28),
                  _IconTile(label: '36', kind: NodeIconKind.daily, size: 36),
                  _IconTile(label: '48', kind: NodeIconKind.daily, size: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({
    required this.label,
    required this.kind,
    this.variant = NodeIconVariant.filled,
    this.size = 28,
  });
  final String label;
  final NodeIconKind kind;
  final NodeIconVariant variant;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 64,
            child: Center(
              child: NodeIcon(kind: kind, variant: variant, size: size),
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

class _ThemedIconRow extends StatelessWidget {
  const _ThemedIconRow({required this.mode, required this.child});
  final String mode;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (mode == 'lightOnly') return _tile(Brightness.light);
    if (mode == 'darkOnly') return _tile(Brightness.dark);
    return LayoutBuilder(
      builder: (context, constraints) {
        final half = constraints.maxWidth >= 480;
        final tiles = <Widget>[
          SizedBox(
            width: half ? (constraints.maxWidth - AppSpacing.lg) / 2 : null,
            child: _tile(Brightness.light),
          ),
          SizedBox(
            width: half ? (constraints.maxWidth - AppSpacing.lg) / 2 : null,
            child: _tile(Brightness.dark),
          ),
        ];
        return half
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

NodeIconKind _mapKind(String value) {
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

NodeIconVariant _mapVariant(String value) {
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
