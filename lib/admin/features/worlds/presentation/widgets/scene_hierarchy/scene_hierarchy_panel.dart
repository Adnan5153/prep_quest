import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/admin_palette.dart';
import '../../../../../core/theme/admin_spacing.dart';
import '../../../domain/entities/building_entity.dart';
import '../../../domain/entities/decoration_entity.dart';
import '../../../domain/entities/node_entity.dart';
import '../../../domain/entities/world_draft_entity.dart';
import '../../providers/world_editor_provider.dart';

class SceneHierarchyPanel extends ConsumerWidget {
  const SceneHierarchyPanel({
    required this.controller,
    required this.draft,
    super.key,
  });

  final ValueNotifier<WorldEditorState> controller;
  final WorldDraftEntity draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WorldEditorState s = controller.value;
    final ThemeData theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: AdminSpacing.sceneHierarchyWidth),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(right: BorderSide(color: theme.colorScheme.outline)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(AdminSpacing.md),
            child: Text('Hierarchy', style: theme.textTheme.titleSmall),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AdminSpacing.sm),
              children: <Widget>[
                if (draft.nodes.isNotEmpty) ...<Widget>[
                  _GroupHeader(label: 'Nodes (${draft.nodes.length})'),
                  for (final NodeEntity n in draft.nodes)
                    _Row(
                      label: '${n.kind.wire}${n.levelNumber != null ? ' ${n.levelNumber}' : ''}',
                      selected: s.selection.kind == SelectionKind.node && s.selection.id == n.id,
                      onTap: () {
                        ref.read(worldEditorControllerProvider(draft).notifier).select(
                              EditorSelection(kind: SelectionKind.node, id: n.id),
                            );
                        controller.value = ref.read(worldEditorControllerProvider(draft));
                      },
                    ),
                ],
                if (draft.buildings.isNotEmpty) ...<Widget>[
                  _GroupHeader(label: 'Buildings (${draft.buildings.length})'),
                  for (final BuildingEntity b in draft.buildings)
                    _Row(
                      label: b.kind,
                      selected: s.selection.kind == SelectionKind.building && s.selection.id == b.id,
                      onTap: () {
                        ref.read(worldEditorControllerProvider(draft).notifier).select(
                              EditorSelection(kind: SelectionKind.building, id: b.id),
                            );
                        controller.value = ref.read(worldEditorControllerProvider(draft));
                      },
                    ),
                ],
                if (draft.decorations.isNotEmpty) ...<Widget>[
                  _GroupHeader(label: 'Decorations (${draft.decorations.length})'),
                  for (final DecorationEntity d in draft.decorations)
                    _Row(
                      label: d.kind.wire,
                      selected: s.selection.kind == SelectionKind.decoration && s.selection.id == d.id,
                      onTap: () {
                        ref.read(worldEditorControllerProvider(draft).notifier).select(
                              EditorSelection(kind: SelectionKind.decoration, id: d.id),
                            );
                        controller.value = ref.read(worldEditorControllerProvider(draft));
                      },
                    ),
                ],
                if (draft.paths.isNotEmpty) ...<Widget>[
                  _GroupHeader(label: 'Paths (${draft.paths.length})'),
                  for (final p in draft.paths)
                    _Row(
                      label: '${p.fromNodeId.substring(p.fromNodeId.length - 4)} → ${p.toNodeId.substring(p.toNodeId.length - 4)}',
                      selected: s.selection.kind == SelectionKind.path && s.selection.id == p.id,
                      onTap: () {
                        ref.read(worldEditorControllerProvider(draft).notifier).select(
                              EditorSelection(kind: SelectionKind.path, id: p.id),
                            );
                        controller.value = ref.read(worldEditorControllerProvider(draft));
                      },
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AdminSpacing.md,
        vertical: AdminSpacing.sm,
      ),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: AdminPalette.ash,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.onTap,
    required this.selected,
  });

  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AdminSpacing.md,
          vertical: AdminSpacing.sm,
        ),
        color: selected
            ? theme.colorScheme.primary.withValues(alpha: 0.12)
            : Colors.transparent,
        child: Row(
          children: <Widget>[
            const SizedBox(width: AdminSpacing.sm),
            Expanded(
              child: Text(label, style: theme.textTheme.bodyMedium),
            ),
            if (selected)
              Icon(Icons.chevron_right, size: 14, color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
