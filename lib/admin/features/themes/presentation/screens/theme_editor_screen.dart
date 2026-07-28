import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/admin_palette.dart';
import '../../../../core/theme/admin_radius.dart';
import '../../../../core/theme/admin_spacing.dart';
import '../../domain/entities/theme_entity.dart';
import '../providers/themes_provider.dart';

class ThemeEditorScreen extends ConsumerWidget {
  const ThemeEditorScreen({required this.themeId, super.key});

  final String? themeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (themeId == null) {
      return const Scaffold(body: Center(child: Text('No theme selected')));
    }
    final AsyncValue<ThemeEntity> theme = ref.watch(themeByIdProvider(themeId!));
    return Scaffold(
      body: theme.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object e, _) => Center(child: Text('Failed: $e')),
        data: (ThemeEntity t) => _ThemeEditorBody(themeEntity: t),
      ),
    );
  }
}

class _ThemeEditorBody extends StatelessWidget {
  const _ThemeEditorBody({required this.themeEntity});

  final ThemeEntity themeEntity;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AdminSpacing.xl),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(AdminSpacing.lg),
              decoration: BoxDecoration(
                color: themeData.colorScheme.surface,
                borderRadius: BorderRadius.circular(AdminRadius.lg),
                border: Border.all(color: themeData.colorScheme.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(themeEntity.displayName,
                      style: themeData.textTheme.displayMedium),
                  const SizedBox(height: AdminSpacing.sm),
                  Text(
                    'Slug: ${themeEntity.slug} · Weather: ${themeEntity.weather.wire} · Status: ${themeEntity.status.wire}',
                    style: themeData.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AdminSpacing.xl),
                  Text('Tokens', style: themeData.textTheme.titleMedium),
                  const SizedBox(height: AdminSpacing.sm),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: AdminSpacing.md,
                      mainAxisSpacing: AdminSpacing.md,
                      childAspectRatio: 3.5,
                      children: <Widget>[
                        _TokenTile(
                            label: 'Sky top', value: themeEntity.tokens.skyTop),
                        _TokenTile(
                            label: 'Sky bottom',
                            value: themeEntity.tokens.skyBottom),
                        _TokenTile(
                            label: 'Ground', value: themeEntity.tokens.ground),
                        _TokenTile(
                            label: 'Path primary',
                            value: themeEntity.tokens.pathPrimary),
                        _TokenTile(
                            label: 'Path shadow',
                            value: themeEntity.tokens.pathShadow),
                        _TokenTile(
                            label: 'Building primary',
                            value: themeEntity.tokens.buildingPrimary),
                        _TokenTile(
                            label: 'Building secondary',
                            value: themeEntity.tokens.buildingSecondary),
                        _TokenTile(
                            label: 'Node locked',
                            value: themeEntity.tokens.nodeLocked),
                        _TokenTile(
                            label: 'Node available',
                            value: themeEntity.tokens.nodeAvailable),
                        _TokenTile(
                            label: 'Node completed',
                            value: themeEntity.tokens.nodeCompleted),
                        _TokenTile(
                            label: 'Boss gate',
                            value: themeEntity.tokens.bossGate),
                        _TokenTile(
                            label: 'Particle',
                            value: themeEntity.tokens.particleColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AdminSpacing.lg),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(AdminSpacing.lg),
              decoration: BoxDecoration(
                color: themeData.colorScheme.surface,
                borderRadius: BorderRadius.circular(AdminRadius.lg),
                border: Border.all(color: themeData.colorScheme.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Preview', style: themeData.textTheme.titleMedium),
                  const SizedBox(height: AdminSpacing.md),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          _hex(themeEntity.tokens.skyTop),
                          _hex(themeEntity.tokens.skyBottom),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  const SizedBox(height: AdminSpacing.md),
                  Container(
                    height: 80,
                    color: _hex(themeEntity.tokens.ground),
                  ),
                  const SizedBox(height: AdminSpacing.md),
                  Wrap(
                    spacing: AdminSpacing.sm,
                    runSpacing: AdminSpacing.sm,
                    children: <Widget>[
                      _Chip(
                          label: 'Node available',
                          color: _hex(themeEntity.tokens.nodeAvailable)),
                      _Chip(
                          label: 'Boss gate',
                          color: _hex(themeEntity.tokens.bossGate)),
                      _Chip(
                          label: 'Path',
                          color: _hex(themeEntity.tokens.pathPrimary)),
                      _Chip(
                          label: 'Building',
                          color: _hex(themeEntity.tokens.buildingPrimary)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _hex(String value) {
    final String v = value.replaceFirst('#', '');
    final int a = v.length == 8 ? int.parse(v.substring(0, 2), radix: 16) : 255;
    final int r = int.parse(v.substring(v.length - 6, v.length - 4), radix: 16);
    final int g = int.parse(v.substring(v.length - 4, v.length - 2), radix: 16);
    final int b = int.parse(v.substring(v.length - 2), radix: 16);
    return Color.fromARGB(a, r, g, b);
  }
}

class _TokenTile extends StatelessWidget {
  const _TokenTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AdminSpacing.md),
      decoration: BoxDecoration(
        color: themeData.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AdminRadius.md),
        border: Border.all(color: themeData.colorScheme.outline),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: _hex(value),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AdminPalette.hairline),
            ),
          ),
          const SizedBox(width: AdminSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(label, style: themeData.textTheme.labelSmall),
                Text(value, style: themeData.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _hex(String value) {
    final String v = value.replaceFirst('#', '');
    final int a = v.length == 8 ? int.parse(v.substring(0, 2), radix: 16) : 255;
    final int r = int.parse(v.substring(v.length - 6, v.length - 4), radix: 16);
    final int g = int.parse(v.substring(v.length - 4, v.length - 2), radix: 16);
    final int b = int.parse(v.substring(v.length - 2), radix: 16);
    return Color.fromARGB(a, r, g, b);
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AdminSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AdminRadius.pill),
        border: Border.all(color: color),
      ),
      child: Text(label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: color)),
    );
  }
}
