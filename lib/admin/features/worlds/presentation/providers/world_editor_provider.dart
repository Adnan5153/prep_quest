import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/ulid.dart';
import '../../../../shared/enums/workflow_state.dart';
import '../../data/repositories/world_repository_impl.dart';
import '../../domain/entities/building_entity.dart';
import '../../domain/entities/coordinate_entity.dart';
import '../../domain/entities/decoration_entity.dart';
import '../../domain/entities/node_entity.dart';
import '../../domain/entities/path_entity.dart';
import '../../domain/entities/world_draft_entity.dart';
import '../../domain/entities/world_version_entity.dart';
import '../../domain/usecases/world_usecases.dart';

enum EditorMode { select, placeNode, placeBuilding, placeDecoration, paintPath, measure }

enum SelectionKind { none, node, building, decoration, path }

@immutable
class EditorSelection {
  const EditorSelection({required this.kind, this.id});

  final SelectionKind kind;
  final String? id;

  static const EditorSelection none = EditorSelection(kind: SelectionKind.none);

  bool get isEmpty => kind == SelectionKind.none || id == null;

  EditorSelection copyWith({SelectionKind? kind, String? id}) =>
      EditorSelection(kind: kind ?? this.kind, id: id ?? this.id);
}

@immutable
class ViewportState {
  const ViewportState({
    required this.scale,
    required this.offsetX,
    required this.offsetY,
    this.gridSize = 20,
    this.snapToGrid = true,
    this.showGrid = true,
  });

  final double scale;
  final double offsetX;
  final double offsetY;
  final double gridSize;
  final bool snapToGrid;
  final bool showGrid;

  ViewportState copyWith({
    double? scale,
    double? offsetX,
    double? offsetY,
    double? gridSize,
    bool? snapToGrid,
    bool? showGrid,
  }) {
    return ViewportState(
      scale: scale ?? this.scale,
      offsetX: offsetX ?? this.offsetX,
      offsetY: offsetY ?? this.offsetY,
      gridSize: gridSize ?? this.gridSize,
      snapToGrid: snapToGrid ?? this.snapToGrid,
      showGrid: showGrid ?? this.showGrid,
    );
  }

  static const ViewportState initial = ViewportState(
    scale: 1,
    offsetX: 0,
    offsetY: 0,
  );
}

@immutable
class HistoryEntry {
  const HistoryEntry({
    required this.label,
    required this.draft,
    required this.timestamp,
  });

  final String label;
  final WorldDraftEntity draft;
  final DateTime timestamp;
}

@immutable
class ValidationIssue {
  const ValidationIssue({
    required this.code,
    required this.message,
    required this.severity,
    this.field,
    this.entityId,
  });

  final String code;
  final String message;
  final IssueSeverity severity;
  final String? field;
  final String? entityId;
}

enum IssueSeverity { info, warning, error }

@immutable
class WorldEditorState {
  const WorldEditorState({
    required this.draft,
    required this.viewport,
    required this.selection,
    required this.mode,
    required this.history,
    required this.future,
    required this.issues,
    required this.lastSavedAt,
    required this.previewThemeId,
    required this.previewLocale,
    required this.saving,
    required this.dirty,
  });

  final WorldDraftEntity draft;
  final ViewportState viewport;
  final EditorSelection selection;
  final EditorMode mode;
  final List<HistoryEntry> history;
  final List<HistoryEntry> future;
  final List<ValidationIssue> issues;
  final DateTime? lastSavedAt;
  final String? previewThemeId;
  final LocaleTag previewLocale;
  final bool saving;
  final bool dirty;

  WorldEditorState copyWith({
    WorldDraftEntity? draft,
    ViewportState? viewport,
    EditorSelection? selection,
    EditorMode? mode,
    List<HistoryEntry>? history,
    List<HistoryEntry>? future,
    List<ValidationIssue>? issues,
    DateTime? lastSavedAt,
    String? previewThemeId,
    LocaleTag? previewLocale,
    bool? saving,
    bool? dirty,
  }) {
    return WorldEditorState(
      draft: draft ?? this.draft,
      viewport: viewport ?? this.viewport,
      selection: selection ?? this.selection,
      mode: mode ?? this.mode,
      history: history ?? this.history,
      future: future ?? this.future,
      issues: issues ?? this.issues,
      lastSavedAt: lastSavedAt ?? this.lastSavedAt,
      previewThemeId: previewThemeId ?? this.previewThemeId,
      previewLocale: previewLocale ?? this.previewLocale,
      saving: saving ?? this.saving,
      dirty: dirty ?? this.dirty,
    );
  }
}

class WorldEditorController
    extends StateNotifier<WorldEditorState> {
  WorldEditorController(this._ref, WorldDraftEntity initial)
      : super(WorldEditorState(
          draft: initial,
          viewport: ViewportState.initial,
          selection: EditorSelection.none,
          mode: EditorMode.select,
          history: <HistoryEntry>[],
          future: <HistoryEntry>[],
          issues: <ValidationIssue>[],
          lastSavedAt: initial.updatedAt,
          previewThemeId: initial.selectedThemeId,
          previewLocale: LocaleTag.english,
          saving: false,
          dirty: false,
        )) {
    _validate();
  }

  final Ref _ref;
  static const int _maxHistory = 64;

  void setMode(EditorMode mode) {
    state = state.copyWith(mode: mode);
  }

  void select(EditorSelection selection) {
    state = state.copyWith(selection: selection);
  }

  void pan(double dx, double dy) {
    final ViewportState v = state.viewport;
    state = state.copyWith(
      viewport: v.copyWith(offsetX: v.offsetX + dx, offsetY: v.offsetY + dy),
    );
  }

  void zoom(double factor) {
    final ViewportState v = state.viewport;
    final double newScale = (v.scale * factor).clamp(0.25, 4.0);
    state = state.copyWith(viewport: v.copyWith(scale: newScale));
  }

  void resetView() {
    state = state.copyWith(viewport: ViewportState.initial);
  }

  void toggleSnapToGrid() {
    final ViewportState v = state.viewport;
    state = state.copyWith(
      viewport: v.copyWith(snapToGrid: !v.snapToGrid),
    );
  }

  void toggleShowGrid() {
    final ViewportState v = state.viewport;
    state = state.copyWith(
      viewport: v.copyWith(showGrid: !v.showGrid),
    );
  }

  CoordinateEntity _maybeSnap(CoordinateEntity c) {
    if (!state.viewport.snapToGrid) return c;
    final double g = state.viewport.gridSize;
    return CoordinateEntity(
      x: (c.x / g).round() * g,
      y: (c.y / g).round() * g,
    );
  }

  void addNode(WorldObjectKind kind, CoordinateEntity coord) {
    final CoordinateEntity c = _maybeSnap(coord);
    final NodeEntity node = NodeEntity(
      id: 'nd_${Ulid.generate()}',
      draftId: state.draft.id,
      kind: kind,
      coordinate: c,
      levelNumber: state.draft.nodes.length + 1,
    );
    _commit(state.copyWith(
      draft: state.draft.copyWith(nodes: <NodeEntity>[...state.draft.nodes, node]),
      selection: EditorSelection(kind: SelectionKind.node, id: node.id),
      dirty: true,
    ), label: 'Add ${kind.wire}');
  }

  void addBuilding(String kind, CoordinateEntity coord,
      {double width = 96, double height = 120, String? assetId}) {
    final CoordinateEntity c = _maybeSnap(coord);
    final BuildingEntity b = BuildingEntity(
      id: 'bld_${Ulid.generate()}',
      draftId: state.draft.id,
      kind: kind,
      coordinate: c,
      width: width,
      height: height,
      assetId: assetId,
    );
    _commit(state.copyWith(
      draft: state.draft.copyWith(buildings: <BuildingEntity>[...state.draft.buildings, b]),
      selection: EditorSelection(kind: SelectionKind.building, id: b.id),
      dirty: true,
    ), label: 'Add $kind');
  }

  void addDecoration(WorldObjectKind kind, CoordinateEntity coord) {
    final CoordinateEntity c = _maybeSnap(coord);
    final DecorationEntity d = DecorationEntity(
      id: 'dec_${Ulid.generate()}',
      draftId: state.draft.id,
      kind: kind,
      coordinate: c,
    );
    _commit(state.copyWith(
      draft: state.draft.copyWith(
        decorations: <DecorationEntity>[...state.draft.decorations, d],
      ),
      selection: EditorSelection(kind: SelectionKind.decoration, id: d.id),
      dirty: true,
    ), label: 'Add decoration');
  }

  void updateNode(String id, NodeEntity Function(NodeEntity) update) {
    final List<NodeEntity> nodes = state.draft.nodes
        .map((NodeEntity n) => n.id == id ? update(n) : n)
        .toList();
    _commit(state.copyWith(
      draft: state.draft.copyWith(nodes: nodes),
      dirty: true,
    ), label: 'Edit node');
  }

  void updateBuilding(String id, BuildingEntity Function(BuildingEntity) update) {
    final List<BuildingEntity> buildings = state.draft.buildings
        .map((BuildingEntity b) => b.id == id ? update(b) : b)
        .toList();
    _commit(state.copyWith(
      draft: state.draft.copyWith(buildings: buildings),
      dirty: true,
    ), label: 'Edit building');
  }

  void updateDecoration(String id, DecorationEntity Function(DecorationEntity) update) {
    final List<DecorationEntity> decorations = state.draft.decorations
        .map((DecorationEntity d) => d.id == id ? update(d) : d)
        .toList();
    _commit(state.copyWith(
      draft: state.draft.copyWith(decorations: decorations),
      dirty: true,
    ), label: 'Edit decoration');
  }

  void deleteSelection() {
    final EditorSelection sel = state.selection;
    if (sel.isEmpty) return;
    switch (sel.kind) {
      case SelectionKind.node:
        final List<NodeEntity> remaining = state.draft.nodes
            .where((NodeEntity n) => n.id != sel.id)
            .toList();
        _commit(state.copyWith(
          draft: state.draft.copyWith(nodes: remaining),
          selection: EditorSelection.none,
          dirty: true,
        ), label: 'Delete node');
        break;
      case SelectionKind.building:
        final List<BuildingEntity> remaining = state.draft.buildings
            .where((BuildingEntity b) => b.id != sel.id)
            .toList();
        _commit(state.copyWith(
          draft: state.draft.copyWith(buildings: remaining),
          selection: EditorSelection.none,
          dirty: true,
        ), label: 'Delete building');
        break;
      case SelectionKind.decoration:
        final List<DecorationEntity> remaining = state.draft.decorations
            .where((DecorationEntity d) => d.id != sel.id)
            .toList();
        _commit(state.copyWith(
          draft: state.draft.copyWith(decorations: remaining),
          selection: EditorSelection.none,
          dirty: true,
        ), label: 'Delete decoration');
        break;
      case SelectionKind.path:
        final List<WorldPathEntity> remaining = state.draft.paths
            .where((WorldPathEntity p) => p.id != sel.id)
            .toList();
        _commit(state.copyWith(
          draft: state.draft.copyWith(paths: remaining),
          selection: EditorSelection.none,
          dirty: true,
        ), label: 'Delete path');
        break;
      case SelectionKind.none:
        break;
    }
  }

  void moveSelection(CoordinateEntity worldPos) {
    final EditorSelection sel = state.selection;
    if (sel.isEmpty) return;
    final CoordinateEntity c = _maybeSnap(worldPos);
    switch (sel.kind) {
      case SelectionKind.node:
        updateNode(sel.id!, (NodeEntity n) => n.copyWith(coordinate: c));
        break;
      case SelectionKind.building:
        updateBuilding(sel.id!, (BuildingEntity b) => b.copyWith(coordinate: c));
        break;
      case SelectionKind.decoration:
        updateDecoration(sel.id!, (DecorationEntity d) => d.copyWith(coordinate: c));
        break;
      case SelectionKind.path:
      case SelectionKind.none:
        break;
    }
  }

  void duplicateSelection() {
    final EditorSelection sel = state.selection;
    if (sel.isEmpty) return;
    switch (sel.kind) {
      case SelectionKind.node:
        final NodeEntity? original =
            state.draft.nodes.where((NodeEntity n) => n.id == sel.id).firstOrNull;
        if (original == null) return;
        final NodeEntity copy = original.copyWith(
          id: 'nd_${Ulid.generate()}',
          coordinate: original.coordinate.copyWith(
            x: original.coordinate.x + state.viewport.gridSize,
            y: original.coordinate.y + state.viewport.gridSize,
          ),
        );
        _commit(state.copyWith(
          draft: state.draft.copyWith(
            nodes: <NodeEntity>[...state.draft.nodes, copy],
          ),
          selection: EditorSelection(kind: SelectionKind.node, id: copy.id),
          dirty: true,
        ), label: 'Duplicate node');
        break;
      case SelectionKind.building:
        final BuildingEntity? original = state.draft.buildings
            .where((BuildingEntity b) => b.id == sel.id)
            .firstOrNull;
        if (original == null) return;
        final BuildingEntity copy = original.copyWith(
          id: 'bld_${Ulid.generate()}',
          coordinate: original.coordinate.copyWith(
            x: original.coordinate.x + state.viewport.gridSize,
            y: original.coordinate.y + state.viewport.gridSize,
          ),
        );
        _commit(state.copyWith(
          draft: state.draft.copyWith(
            buildings: <BuildingEntity>[...state.draft.buildings, copy],
          ),
          selection: EditorSelection(kind: SelectionKind.building, id: copy.id),
          dirty: true,
        ), label: 'Duplicate building');
        break;
      case SelectionKind.decoration:
        final DecorationEntity? original = state.draft.decorations
            .where((DecorationEntity d) => d.id == sel.id)
            .firstOrNull;
        if (original == null) return;
        final DecorationEntity copy = original.copyWith(
          id: 'dec_${Ulid.generate()}',
          coordinate: original.coordinate.copyWith(
            x: original.coordinate.x + state.viewport.gridSize,
            y: original.coordinate.y + state.viewport.gridSize,
          ),
        );
        _commit(state.copyWith(
          draft: state.draft.copyWith(
            decorations: <DecorationEntity>[...state.draft.decorations, copy],
          ),
          selection: EditorSelection(kind: SelectionKind.decoration, id: copy.id),
          dirty: true,
        ), label: 'Duplicate decoration');
        break;
      case SelectionKind.path:
      case SelectionKind.none:
        break;
    }
  }

  void autoConnectNodes() {
    final List<NodeEntity> navigables = state.draft.nodes
        .where((NodeEntity n) => n.isNavigable)
        .toList();
    final Set<String> existingPathPairs = state.draft.paths
        .map((WorldPathEntity p) => '${p.fromNodeId}->${p.toNodeId}')
        .toSet();
    final List<WorldPathEntity> next = <WorldPathEntity>[...state.draft.paths];
    for (int i = 0; i < navigables.length - 1; i++) {
      final NodeEntity a = navigables[i];
      final NodeEntity b = navigables[i + 1];
      final String key = '${a.id}->${b.id}';
      if (existingPathPairs.contains(key)) continue;
      next.add(WorldPathEntity(
        id: 'pth_${Ulid.generate()}',
        draftId: state.draft.id,
        fromNodeId: a.id,
        toNodeId: b.id,
        segments: <PathSegmentEntity>[
          PathSegmentEntity(
            kind: PathSegmentKind.bezier,
            start: a.coordinate,
            end: b.coordinate,
            control: CoordinateEntity(
              x: (a.coordinate.x + b.coordinate.x) / 2,
              y: (a.coordinate.y + b.coordinate.y) / 2 -
                  ((b.coordinate.x - a.coordinate.x).abs() * 0.2 + 30),
            ),
            width: 12,
          ),
        ],
        style: PathStyle.bezier,
      ));
    }
    _commit(state.copyWith(
      draft: state.draft.copyWith(paths: next),
      dirty: true,
    ), label: 'Auto-connect nodes');
  }

  void updateSelectedPathControl(PathSegmentEntity segment) {
    final String? pathId = state.selection.id;
    if (pathId == null) return;
    final List<WorldPathEntity> updated = state.draft.paths
        .map((WorldPathEntity p) =>
            p.id == pathId ? p.copyWith(segments: <PathSegmentEntity>[segment]) : p)
        .toList();
    _commit(state.copyWith(
      draft: state.draft.copyWith(paths: updated),
      dirty: true,
    ), label: 'Adjust path');
  }

  void setPreviewTheme(String? themeId) {
    state = state.copyWith(previewThemeId: themeId);
  }

  void setPreviewLocale(LocaleTag locale) {
    state = state.copyWith(previewLocale: locale);
  }

  void undo() {
    if (state.history.isEmpty) return;
    final HistoryEntry last = state.history.last;
    final List<HistoryEntry> history = <HistoryEntry>[...state.history]..removeLast();
    final List<HistoryEntry> future = <HistoryEntry>[_snapshot('redo', state.draft), ...state.future];
    state = state.copyWith(
      draft: last.draft,
      history: history,
      future: future,
      dirty: true,
    );
    _validate();
  }

  void redo() {
    if (state.future.isEmpty) return;
    final HistoryEntry next = state.future.first;
    final List<HistoryEntry> future = <HistoryEntry>[...state.future]..removeAt(0);
    final List<HistoryEntry> history = <HistoryEntry>[...state.history, _snapshot('undo', state.draft)];
    state = state.copyWith(
      draft: next.draft,
      future: future,
      history: history,
      dirty: true,
    );
    _validate();
  }

  Future<void> save() async {
    if (!state.dirty) return;
    state = state.copyWith(saving: true);
    try {
      final WorldDraftEntity saved = await SaveDraftUseCase(
        _ref.read(worldRepositoryProvider),
      )(SaveDraftParams(
        draft: state.draft,
        expectedVersion: state.draft.versionCounter,
      ));
      state = state.copyWith(
        draft: saved,
        saving: false,
        dirty: false,
        lastSavedAt: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(saving: false);
      rethrow;
    }
  }

  Future<WorldVersionEntity> publish(String releaseNotes, String actorId) {
    return PublishDraftUseCase(_ref.read(worldRepositoryProvider))(
      PublishDraftParams(
        draftId: state.draft.id,
        actorId: actorId,
        releaseNotes: releaseNotes,
      ),
    );
  }

  void _commit(WorldEditorState next, {required String label}) {
    final List<HistoryEntry> history =
        <HistoryEntry>[...state.history, _snapshot(label, state.draft)];
    if (history.length > _maxHistory) {
      history.removeRange(0, history.length - _maxHistory);
    }
    state = next.copyWith(history: history, future: <HistoryEntry>[]);
    _validate();
  }

  HistoryEntry _snapshot(String label, WorldDraftEntity d) => HistoryEntry(
        label: label,
        draft: d,
        timestamp: DateTime.now(),
      );

  void _validate() {
    final List<ValidationIssue> issues = <ValidationIssue>[];
    final Set<String> coordinates = <String>{};
    for (final NodeEntity n in state.draft.nodes) {
      final String key = '${n.coordinate.x.toInt()},${n.coordinate.y.toInt()}';
      if (coordinates.contains(key)) {
        issues.add(ValidationIssue(
          code: 'node.duplicate_coordinate',
          message: 'Two nodes share coordinate (${n.coordinate.x.toInt()}, ${n.coordinate.y.toInt()}).',
          severity: IssueSeverity.error,
          entityId: n.id,
        ));
      }
      coordinates.add(key);
      if (n.titleKey == null || n.titleKey!.isEmpty) {
        issues.add(ValidationIssue(
          code: 'node.missing_title',
          message: 'Node ${n.levelNumber ?? n.id} is missing a translation key.',
          severity: IssueSeverity.warning,
          entityId: n.id,
          field: 'titleKey',
        ));
      }
    }

    final Set<String> nodeIds = state.draft.nodes.map((NodeEntity n) => n.id).toSet();
    for (final WorldPathEntity p in state.draft.paths) {
      if (!nodeIds.contains(p.fromNodeId) || !nodeIds.contains(p.toNodeId)) {
        issues.add(ValidationIssue(
          code: 'path.broken_link',
          message: 'Path references an unknown node.',
          severity: IssueSeverity.error,
          entityId: p.id,
        ));
      }
    }

    for (final NodeEntity n in state.draft.nodes) {
      for (final String prereq in n.prerequisiteNodeIds) {
        if (!nodeIds.contains(prereq)) {
          issues.add(ValidationIssue(
            code: 'node.broken_prereq',
            message: 'Node ${n.levelNumber ?? n.id} has a missing prerequisite.',
            severity: IssueSeverity.error,
            entityId: n.id,
          ));
        }
      }
    }

    state = state.copyWith(issues: issues);
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}

final worldDraftProvider = FutureProvider.family<WorldDraftEntity, String>(
  (Ref ref, String draftId) async {
    return ref.watch(worldRepositoryProvider).getDraft(draftId);
  },
);

final worldEditorControllerProvider = StateNotifierProvider.family<
    WorldEditorController, WorldEditorState, WorldDraftEntity>(
  (Ref ref, WorldDraftEntity draft) {
    // The screen already awaited the draft before instantiating the
    // controller, so we can construct it directly here. Keeping the watch
    // on `worldDraftProvider` would risk a synchronous `StateError` if the
    // provider were ever read while still loading — see the original bug
    // where `_EditorShell.build` blew up because the family initializer
    // threw "Draft not ready" inside Riverpod's provider resolution.
    return WorldEditorController(ref, draft);
  },
);
