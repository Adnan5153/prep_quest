import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/admin_strings.dart';
import '../../../../core/theme/admin_palette.dart';
import '../../../../core/theme/admin_spacing.dart';
import '../../../../shared/enums/workflow_state.dart';
import '../../data/repositories/world_repository_impl.dart';
import '../../domain/entities/building_entity.dart';
import '../../domain/entities/coordinate_entity.dart';
import '../../domain/entities/decoration_entity.dart';
import '../../domain/entities/node_entity.dart';
import '../../domain/entities/world_draft_entity.dart';
import '../providers/world_editor_provider.dart';
import '../widgets/assets/asset_browser_panel.dart';
import '../widgets/console/console_panel.dart';
import '../widgets/history/history_panel.dart';
import '../widgets/inspector/inspector_panel.dart';
import '../widgets/preview/preview_panel.dart';
import '../widgets/scene_hierarchy/scene_hierarchy_panel.dart';
import '../widgets/toolbar/editor_toolbar.dart';
import '../widgets/viewport/world_viewport.dart';

final _draftByWorldIdProvider =
    FutureProvider.family<WorldDraftEntity, String>((Ref ref, String worldId) async {
  final repo = ref.watch(worldRepositoryProvider);
  final List<WorldDraftEntity> drafts = await repo.listDrafts(worldId);
  if (drafts.isNotEmpty) return drafts.first;
  await ref.watch(_ensureWorldExistsProvider(worldId).future);
  final List<WorldDraftEntity> after = await repo.listDrafts(worldId);
  if (after.isNotEmpty) return after.first;
  return repo.openDraft(
    worldId: worldId,
    branchName: 'main',
    ownerId: 'usr_admin',
  );
});

final _ensureWorldExistsProvider =
    FutureProvider.family<void, String>((Ref ref, String worldId) async {
  try {
    await ref.watch(worldRepositoryProvider).getWorld(worldId);
  } catch (_) {
    // World not in local seed; nothing to do — the editor will display an error.
  }
});

class WorldEditorScreen extends ConsumerWidget {
  const WorldEditorScreen({required this.worldId, super.key});

  final String? worldId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (worldId == null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AdminSpacing.xl),
            child: Text(
              'Specify a worldId in the URL or create one from the Worlds list.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      );
    }
    final AsyncValue<WorldDraftEntity> asyncDraft =
        ref.watch(_draftByWorldIdProvider(worldId!));

    return asyncDraft.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (Object e, _) => Scaffold(
        body: Center(child: Text('Failed to load: $e')),
      ),
      data: (WorldDraftEntity draft) => _EditorShell(draft: draft),
    );
  }
}

class _EditorShell extends ConsumerWidget {
  const _EditorShell({required this.draft});

  final WorldDraftEntity draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WorldEditorState state =
        ref.watch(worldEditorControllerProvider(draft));
    final WorldEditorController controller =
        ref.read(worldEditorControllerProvider(draft).notifier);
    final ValueNotifier<WorldEditorState> notifier =
        ValueNotifier<WorldEditorState>(state);

    ref.listen<WorldEditorState>(worldEditorControllerProvider(draft),
        (WorldEditorState? previous, WorldEditorState next) {
      notifier.value = next;
    });

    return Scaffold(
      body: CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.keyZ, control: true):
              () => _undo(ref, draft, notifier),
          const SingleActivator(
              LogicalKeyboardKey.keyZ, control: true, shift: true):
              () => _redo(ref, draft, notifier),
          const SingleActivator(LogicalKeyboardKey.keyS, control: true):
              () => _save(ref, draft, notifier),
          const SingleActivator(LogicalKeyboardKey.keyD, control: true):
              () => _duplicate(ref, draft, notifier),
          const SingleActivator(LogicalKeyboardKey.delete):
              () => _delete(ref, draft, notifier),
          const SingleActivator(LogicalKeyboardKey.keyV):
              () => controller.setMode(EditorMode.select),
          const SingleActivator(LogicalKeyboardKey.keyN):
              () => controller.setMode(EditorMode.placeNode),
          const SingleActivator(LogicalKeyboardKey.keyB):
              () => controller.setMode(EditorMode.placeBuilding),
        },
        child: Focus(
          autofocus: true,
          child: Column(
            children: <Widget>[
              EditorToolbar(controller: notifier, draft: draft),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      fit: FlexFit.loose,
                      child: SceneHierarchyPanel(controller: notifier, draft: draft),
                    ),
                    Expanded(
                      flex: 7,
                      child: Column(
                        children: <Widget>[
                          _ModeBar(controller: controller, state: state),
                          Expanded(
                            child: WorldViewport(
                              controller: notifier,
                              onTap: (Offset worldPos) => _onCanvasTap(
                                ref,
                                draft,
                                controller,
                                notifier,
                                state,
                                worldPos,
                              ),
                              onAssetDrop: (String assetId, Offset worldPos) =>
                                  _onAssetDrop(
                                ref,
                                draft,
                                controller,
                                notifier,
                                worldPos,
                                assetId,
                              ),
                              onObjectDrag: (
                                EditorSelection selection,
                                Offset worldPos,
                              ) =>
                                  _onObjectDrag(
                                ref,
                                draft,
                                controller,
                                notifier,
                                selection,
                                worldPos,
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: HistoryPanel(controller: notifier, draft: draft),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      fit: FlexFit.loose,
                      child: const AssetBrowserPanel(),
                    ),
                    Flexible(
                      flex: 4,
                      fit: FlexFit.loose,
                      child: InspectorPanel(controller: notifier, draft: draft),
                    ),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: PreviewPanel(controller: notifier, draft: draft),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: ConsolePanel(controller: notifier, draft: draft),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCanvasTap(
    WidgetRef ref,
    WorldDraftEntity draft,
    WorldEditorController controller,
    ValueNotifier<WorldEditorState> notifier,
    WorldEditorState state,
    Offset worldPos,
  ) {
    final CoordinateEntity coord =
        CoordinateEntity(x: worldPos.dx, y: worldPos.dy);
    switch (state.mode) {
      case EditorMode.select:
        _pick(ref, draft, worldPos);
        notifier.value = ref.read(worldEditorControllerProvider(draft));
        break;
      case EditorMode.placeNode:
        controller.addNode(WorldObjectKind.lessonNode, coord);
        notifier.value = ref.read(worldEditorControllerProvider(draft));
        break;
      case EditorMode.placeBuilding:
        controller.addBuilding('academy', coord);
        notifier.value = ref.read(worldEditorControllerProvider(draft));
        break;
      case EditorMode.placeDecoration:
        controller.addDecoration(WorldObjectKind.tree, coord);
        notifier.value = ref.read(worldEditorControllerProvider(draft));
        break;
      case EditorMode.paintPath:
        controller.autoConnectNodes();
        notifier.value = ref.read(worldEditorControllerProvider(draft));
        break;
      case EditorMode.measure:
        break;
    }
  }

  void _pick(
    WidgetRef ref,
    WorldDraftEntity draft,
    Offset worldPos,
  ) {
    final WorldEditorController notifier =
        ref.read(worldEditorControllerProvider(draft).notifier);
    bool took = false;
    for (final NodeEntity n in draft.nodes) {
      if ((worldPos - Offset(n.coordinate.x, n.coordinate.y)).distance < 24) {
        notifier.select(EditorSelection(kind: SelectionKind.node, id: n.id));
        took = true;
        break;
      }
    }
    if (!took) {
      for (final BuildingEntity b in draft.buildings) {
        final Rect rect = Rect.fromLTWH(
          b.coordinate.x - b.width / 2,
          b.coordinate.y - b.height / 2,
          b.width,
          b.height,
        );
        if (rect.contains(worldPos)) {
          notifier.select(EditorSelection(kind: SelectionKind.building, id: b.id));
          took = true;
          break;
        }
      }
    }
    if (!took) {
      for (final DecorationEntity d in draft.decorations) {
        if ((worldPos - Offset(d.coordinate.x, d.coordinate.y)).distance < 18) {
          notifier.select(EditorSelection(
              kind: SelectionKind.decoration, id: d.id));
          took = true;
          break;
        }
      }
    }
    if (!took) notifier.select(EditorSelection.none);
  }

  void _onAssetDrop(
    WidgetRef ref,
    WorldDraftEntity draft,
    WorldEditorController controller,
    ValueNotifier<WorldEditorState> notifier,
    Offset worldPos,
    String assetId,
  ) {
    final CoordinateEntity coord =
        CoordinateEntity(x: worldPos.dx, y: worldPos.dy);
    controller.addBuilding('asset', coord, assetId: assetId);
    notifier.value = ref.read(worldEditorControllerProvider(draft));
  }

  void _onObjectDrag(
    WidgetRef ref,
    WorldDraftEntity draft,
    WorldEditorController controller,
    ValueNotifier<WorldEditorState> notifier,
    EditorSelection selection,
    Offset worldPos,
  ) {
    if (selection.isEmpty) return;
    final EditorSelection current =
        ref.read(worldEditorControllerProvider(draft)).selection;
    if (current != selection) {
      controller.select(selection);
    }
    controller.moveSelection(CoordinateEntity(x: worldPos.dx, y: worldPos.dy));
    notifier.value = ref.read(worldEditorControllerProvider(draft));
  }
}

class _ModeBar extends StatelessWidget {
  const _ModeBar({required this.controller, required this.state});

  final WorldEditorController controller;
  final WorldEditorState state;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: AdminSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outline),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
        children: <Widget>[
          _ModeButton(
            icon: Icons.pan_tool_outlined,
            label: 'Select',
            mode: EditorMode.select,
            controller: controller,
            current: state.mode,
          ),
          _ModeButton(
            icon: Icons.add_circle_outline,
            label: 'Node',
            mode: EditorMode.placeNode,
            controller: controller,
            current: state.mode,
          ),
          _ModeButton(
            icon: Icons.business_outlined,
            label: 'Building',
            mode: EditorMode.placeBuilding,
            controller: controller,
            current: state.mode,
          ),
          _ModeButton(
            icon: Icons.park_outlined,
            label: 'Decoration',
            mode: EditorMode.placeDecoration,
            controller: controller,
            current: state.mode,
          ),
          _ModeButton(
            icon: Icons.timeline,
            label: 'Auto-path',
            mode: EditorMode.paintPath,
            controller: controller,
            current: state.mode,
          ),
          const SizedBox(width: AdminSpacing.md),
          IconButton(
            tooltip: AdminStrings.actionZoomFit,
            onPressed: () => controller.resetView(),
            icon: const Icon(Icons.fit_screen_outlined, size: 16),
          ),
          IconButton(
            tooltip: AdminStrings.actionZoomIn,
            onPressed: () => controller.zoom(1.1),
            icon: const Icon(Icons.zoom_in, size: 16),
          ),
          IconButton(
            tooltip: AdminStrings.actionZoomOut,
            onPressed: () => controller.zoom(1 / 1.1),
            icon: const Icon(Icons.zoom_out, size: 16),
          ),
          IconButton(
            tooltip: AdminStrings.actionSnapToGrid,
            onPressed: () => controller.toggleSnapToGrid(),
            icon: Icon(
              state.viewport.snapToGrid ? Icons.grid_on : Icons.grid_off,
              size: 16,
              color: state.viewport.snapToGrid ? AdminPalette.accent : null,
            ),
          ),
          IconButton(
            tooltip: AdminStrings.actionToggleGrid,
            onPressed: () => controller.toggleShowGrid(),
            icon: Icon(
              state.viewport.showGrid
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank,
              size: 16,
            ),
          ),
        ],
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.icon,
    required this.label,
    required this.mode,
    required this.controller,
    required this.current,
  });

  final IconData icon;
  final String label;
  final EditorMode mode;
  final WorldEditorController controller;
  final EditorMode current;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool selected = current == mode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: selected
            ? theme.colorScheme.primary.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: () => controller.setMode(mode),
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Row(
              children: <Widget>[
                Icon(icon,
                    size: 16,
                    color: selected ? theme.colorScheme.primary : null),
                const SizedBox(width: AdminSpacing.xs),
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: selected ? theme.colorScheme.primary : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _undo(WidgetRef ref, WorldDraftEntity draft, ValueNotifier<WorldEditorState> n) {
  ref.read(worldEditorControllerProvider(draft).notifier).undo();
  n.value = ref.read(worldEditorControllerProvider(draft));
}

void _redo(WidgetRef ref, WorldDraftEntity draft, ValueNotifier<WorldEditorState> n) {
  ref.read(worldEditorControllerProvider(draft).notifier).redo();
  n.value = ref.read(worldEditorControllerProvider(draft));
}

Future<void> _save(WidgetRef ref, WorldDraftEntity draft,
    ValueNotifier<WorldEditorState> n) async {
  try {
    await ref.read(worldEditorControllerProvider(draft).notifier).save();
    n.value = ref.read(worldEditorControllerProvider(draft));
  } catch (_) {}
}

void _duplicate(WidgetRef ref, WorldDraftEntity draft,
    ValueNotifier<WorldEditorState> n) {
  ref.read(worldEditorControllerProvider(draft).notifier).duplicateSelection();
  n.value = ref.read(worldEditorControllerProvider(draft));
}

void _delete(WidgetRef ref, WorldDraftEntity draft,
    ValueNotifier<WorldEditorState> n) {
  ref.read(worldEditorControllerProvider(draft).notifier).deleteSelection();
  n.value = ref.read(worldEditorControllerProvider(draft));
}
