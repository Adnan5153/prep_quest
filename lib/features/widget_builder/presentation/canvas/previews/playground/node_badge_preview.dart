import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../../features/playground/presentation/widgets/nodes/node_badge.dart';
import '../../../providers/widget_builder_provider.dart';

class NodeBadgePreview extends StatelessWidget {
  const NodeBadgePreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badge = _BadgeDemo(
      kind: _mapKind(provider.nodeBadgeKind),
      size: provider.nodeBadgeSize,
      offset: provider.nodeBadgeOffset,
    );
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Node Badge', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            _ThemedBadgeRow(mode: provider.nodeBadgeBrightness, child: badge),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Kind Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: NodeBadgeKind.values
                    .map((kind) => _BadgeTile(label: kind.name, kind: kind))
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
                  _BadgeTile(label: '20 px', kind: NodeBadgeKind.xp, size: 20),
                  _BadgeTile(label: '28 px', kind: NodeBadgeKind.xp, size: 28),
                  _BadgeTile(label: '36 px', kind: NodeBadgeKind.xp, size: 36),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeDemo extends StatelessWidget {
  const _BadgeDemo({
    required this.kind,
    required this.size,
    required this.offset,
  });
  final NodeBadgeKind kind;
  final double size;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          NodeBadge(kind: kind, size: size, offset: offset),
        ],
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.label, required this.kind, this.size = 24});
  final String label;
  final NodeBadgeKind kind;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 104,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BadgeDemo(kind: kind, size: size, offset: 4),
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

class _ThemedBadgeRow extends StatelessWidget {
  const _ThemedBadgeRow({required this.mode, required this.child});
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
      padding: const EdgeInsets.all(AppSpacing.lg),
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

NodeBadgeKind _mapKind(String value) {
  switch (value) {
    case 'boss':
      return NodeBadgeKind.boss;
    case 'library':
      return NodeBadgeKind.library;
    case 'premium':
      return NodeBadgeKind.premium;
    case 'event':
      return NodeBadgeKind.event;
    case 'daily':
      return NodeBadgeKind.daily;
    case 'tournament':
      return NodeBadgeKind.tournament;
    case 'seasonal':
      return NodeBadgeKind.seasonal;
    case 'completed':
      return NodeBadgeKind.completed;
    case 'newBadge':
      return NodeBadgeKind.newBadge;
    default:
      return NodeBadgeKind.xp;
  }
}
