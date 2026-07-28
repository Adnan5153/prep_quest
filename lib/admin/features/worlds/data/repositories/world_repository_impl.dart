import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/admin_exception.dart';
import '../../../../core/utils/hash_utils.dart';
import '../../../../core/utils/ulid.dart';
import '../../../../shared/enums/workflow_state.dart';
import '../../../audit/data/repositories/audit_repository_impl.dart';
import '../../../audit/domain/repositories/audit_repository.dart';
import '../../domain/entities/building_entity.dart';
import '../../domain/entities/coordinate_entity.dart';
import '../../domain/entities/decoration_entity.dart';
import '../../domain/entities/node_entity.dart';
import '../../domain/entities/path_entity.dart';
import '../../domain/entities/world_draft_entity.dart';
import '../../domain/entities/world_entity.dart';
import '../../domain/entities/world_version_entity.dart';
import '../../domain/repositories/world_repository.dart';

class WorldRepositoryImpl implements WorldRepository {
  WorldRepositoryImpl(this._audit) {
    _seed();
  }

  final AuditRepository _audit;

  final Map<String, WorldEntity> _worlds = <String, WorldEntity>{};
  final Map<String, WorldVersionEntity> _versions =
      <String, WorldVersionEntity>{};
  final Map<String, WorldDraftEntity> _drafts = <String, WorldDraftEntity>{};
  final Map<String, StreamController<List<WorldEntity>>> _worldStreams =
      <String, StreamController<List<WorldEntity>>>{};
  final Map<String, StreamController<WorldDraftEntity?>> _draftStreams =
      <String, StreamController<WorldDraftEntity?>>{};

  static const String _schemaVersion = '32.0.0';
  static const String _rendererContract = '32.0.0';

  void _seed() {
    final DateTime now = DateTime.now();
    final WorldEntity bcs = WorldEntity(
      id: 'wld_bcs',
      slug: 'bcs',
      displayName: 'Bangladesh Civil Service',
      examVertical: ExamVertical.bcs,
      ownerId: 'usr_admin',
      tags: const <String>['bcs', 'primary', 'launch'],
      status: WorkflowState.published,
      activeVersionId: 'wvr_bcs_v1',
      description: 'The flagship BCS preparation world.',
      createdAt: now.subtract(const Duration(days: 90)),
      updatedAt: now.subtract(const Duration(days: 5)),
      coverAssetId: 'ast_bcs_cover',
    );
    final WorldEntity bank = WorldEntity(
      id: 'wld_bank',
      slug: 'bank-jobs',
      displayName: 'Bank Recruitment',
      examVertical: ExamVertical.bank,
      ownerId: 'usr_admin',
      tags: const <String>['bank', 'recruitment'],
      status: WorkflowState.inReview,
      activeVersionId: null,
      description: 'Bangladesh Bank recruitment preparation world.',
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now.subtract(const Duration(days: 1)),
      coverAssetId: 'ast_bank_cover',
    );
    final WorldEntity primary = WorldEntity(
      id: 'wld_primary',
      slug: 'primary-teacher',
      displayName: 'Primary Teacher',
      examVertical: ExamVertical.primary,
      ownerId: 'usr_author',
      tags: const <String>['primary', 'teacher'],
      status: WorkflowState.draft,
      activeVersionId: null,
      description: 'Primary teacher recruitment preparation world.',
      createdAt: now.subtract(const Duration(days: 7)),
      updatedAt: now.subtract(const Duration(hours: 12)),
      coverAssetId: 'ast_primary_cover',
    );
    final WorldEntity ntrca = WorldEntity(
      id: 'wld_ntrca',
      slug: 'ntrca',
      displayName: 'NTRCA Registration',
      examVertical: ExamVertical.ntrca,
      ownerId: 'usr_author',
      tags: const <String>['ntrca', 'registration'],
      status: WorkflowState.draft,
      activeVersionId: null,
      description: 'NTRCA teacher registration world.',
      createdAt: now.subtract(const Duration(days: 3)),
      updatedAt: now.subtract(const Duration(hours: 2)),
    );
    final WorldEntity medical = WorldEntity(
      id: 'wld_medical',
      slug: 'medical',
      displayName: 'Medical Admission',
      examVertical: ExamVertical.medical,
      ownerId: 'usr_admin',
      tags: const <String>['medical', 'mbbs'],
      status: WorkflowState.archived,
      activeVersionId: null,
      description: 'MBBS admission preparation (archived).',
      createdAt: now.subtract(const Duration(days: 365)),
      updatedAt: now.subtract(const Duration(days: 60)),
      archivedAt: now.subtract(const Duration(days: 60)),
    );
    final WorldEntity govt = WorldEntity(
      id: 'wld_govt',
      slug: 'government-jobs',
      displayName: 'Government Jobs',
      examVertical: ExamVertical.government,
      ownerId: 'usr_admin',
      tags: const <String>['government', 'misc'],
      status: WorkflowState.draft,
      activeVersionId: null,
      description: 'Aggregated government job preparation world.',
      createdAt: now.subtract(const Duration(days: 1)),
      updatedAt: now.subtract(const Duration(hours: 1)),
    );

    for (final WorldEntity w in <WorldEntity>[bcs, bank, primary, ntrca, medical, govt]) {
      _worlds[w.id] = w;
    }

    final WorldVersionEntity bcsV1 = _seedBcsVersion(bcs);
    _versions[bcsV1.id] = bcsV1;

    _drafts[_draftIdFor(bcsV1)] = WorldDraftEntity(
      id: _draftIdFor(bcsV1),
      worldId: bcs.id,
      baseVersionId: bcsV1.id,
      branchName: 'main',
      ownerId: bcs.ownerId,
      nodes: <NodeEntity>[],
      decorations: <DecorationEntity>[],
      buildings: <BuildingEntity>[],
      paths: <WorldPathEntity>[],
      updatedAt: now.subtract(const Duration(days: 2)),
    );
  }

  WorldVersionEntity _seedBcsVersion(WorldEntity world) {
    final DateTime now = DateTime.now().subtract(const Duration(days: 5));
    final List<NodeEntity> nodes = <NodeEntity>[
      NodeEntity(
        id: 'nd_bcs_01',
        draftId: 'main',
        kind: WorldObjectKind.lessonNode,
        coordinate: const CoordinateEntity(x: 120, y: 120),
        levelNumber: 1,
        titleKey: 'lesson.bcs.intro',
        subtitleKey: 'lesson.bcs.intro.sub',
        iconKey: 'icon.book',
        assetId: 'ast_node_default',
      ),
      NodeEntity(
        id: 'nd_bcs_02',
        draftId: 'main',
        kind: WorldObjectKind.lessonNode,
        coordinate: const CoordinateEntity(x: 220, y: 200),
        levelNumber: 2,
        titleKey: 'lesson.bcs.bangla',
        subtitleKey: 'lesson.bcs.bangla.sub',
        iconKey: 'icon.book',
        assetId: 'ast_node_default',
        prerequisiteNodeIds: const <String>['nd_bcs_01'],
      ),
      NodeEntity(
        id: 'nd_bcs_03',
        draftId: 'main',
        kind: WorldObjectKind.lessonNode,
        coordinate: const CoordinateEntity(x: 320, y: 280),
        levelNumber: 3,
        titleKey: 'lesson.bcs.english',
        subtitleKey: 'lesson.bcs.english.sub',
        iconKey: 'icon.book',
        assetId: 'ast_node_default',
        prerequisiteNodeIds: const <String>['nd_bcs_02'],
      ),
      NodeEntity(
        id: 'nd_bcs_boss',
        draftId: 'main',
        kind: WorldObjectKind.bossGate,
        coordinate: const CoordinateEntity(x: 440, y: 380),
        titleKey: 'lesson.bcs.boss',
        subtitleKey: 'lesson.bcs.boss.sub',
        assetId: 'ast_boss_default',
        prerequisiteNodeIds: const <String>['nd_bcs_03'],
      ),
    ];

    final List<DecorationEntity> decorations = <DecorationEntity>[
      DecorationEntity(
        id: 'dec_bcs_tree1',
        draftId: 'main',
        kind: WorldObjectKind.tree,
        coordinate: const CoordinateEntity(x: 60, y: 220),
        assetId: 'ast_tree_pine',
        parallaxLayer: 1,
      ),
      DecorationEntity(
        id: 'dec_bcs_cloud1',
        draftId: 'main',
        kind: WorldObjectKind.cloud,
        coordinate: const CoordinateEntity(x: 280, y: 60),
        parallaxLayer: 2,
      ),
    ];

    final List<BuildingEntity> buildings = <BuildingEntity>[
      BuildingEntity(
        id: 'bld_bcs_academy',
        draftId: 'main',
        kind: 'academy',
        coordinate: const CoordinateEntity(x: 540, y: 260),
        width: 96,
        height: 120,
        assetId: 'ast_building_academy',
      ),
    ];

    final List<WorldPathEntity> paths = <WorldPathEntity>[
      WorldPathEntity(
        id: 'pth_bcs_1_2',
        draftId: 'main',
        fromNodeId: 'nd_bcs_01',
        toNodeId: 'nd_bcs_02',
        segments: <PathSegmentEntity>[
          PathSegmentEntity(
            kind: PathSegmentKind.bezier,
            start: nodes[0].coordinate,
            end: nodes[1].coordinate,
            control: const CoordinateEntity(x: 170, y: 130),
            width: 14,
          ),
        ],
        style: PathStyle.bezier,
      ),
    ];

    final Map<String, dynamic> payload = <String, dynamic>{
      'id': 'main',
      'worldId': world.id,
      'compass': <String, dynamic>{'x': 0, 'y': 0, 'z': 0},
      'zoom': 1,
      'nodes': nodes.map((NodeEntity n) => n.toJson()).toList(),
      'decorations':
          decorations.map((DecorationEntity d) => d.toJson()).toList(),
      'buildings': buildings.map((BuildingEntity b) => b.toJson()).toList(),
      'paths': paths.map((WorldPathEntity p) => p.toJson()).toList(),
    };

    return WorldVersionEntity(
      id: 'wvr_bcs_v1',
      worldId: world.id,
      parentId: null,
      status: WorkflowState.published,
      schemaVersion: _schemaVersion,
      rendererContractVersion: _rendererContract,
      payloadHash: HashUtils.sha256OfJson(payload),
      payload: payload,
      diffSummary: const DiffSummaryEntity(
        addedNodeIds: <String>[
          'nd_bcs_01',
          'nd_bcs_02',
          'nd_bcs_03',
          'nd_bcs_boss'
        ],
        removedNodeIds: <String>[],
        modifiedNodeIds: <String>[],
        addedDecorationIds: <String>['dec_bcs_tree1', 'dec_bcs_cloud1'],
        modifiedDecorationIds: <String>[],
        addedPathIds: <String>['pth_bcs_1_2'],
        modifiedPathIds: <String>[],
        totalChanges: 7,
      ),
      releaseNotes: 'Initial BCS launch world.',
      createdBy: world.ownerId,
      createdAt: now,
      publishedBy: world.ownerId,
      publishedAt: now,
      branchName: 'main',
    );
  }

  String _draftIdFor(WorldVersionEntity version) =>
      'drf_${version.worldId}_${version.branchName ?? 'main'}';

  @override
  Future<List<WorldEntity>> listWorlds() async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return _worlds.values
        .sorted((WorldEntity a, WorldEntity b) =>
            b.updatedAt.compareTo(a.updatedAt))
        .toList();
  }

  @override
  Future<WorldEntity> getWorld(String id) async {
    final WorldEntity? w = _worlds[id];
    if (w == null) throw AdminNotFoundException('World not found');
    return w;
  }

  @override
  Future<WorldEntity> createWorld({
    required String slug,
    required String displayName,
    required String examVertical,
    required String description,
    required String ownerId,
  }) async {
    final String id = Ulid.generate();
    final DateTime now = DateTime.now();
    final WorldEntity w = WorldEntity(
      id: id,
      slug: slug,
      displayName: displayName,
      examVertical: ExamVertical.fromCode(examVertical),
      ownerId: ownerId,
      tags: const <String>[],
      status: WorkflowState.draft,
      activeVersionId: null,
      description: description,
      createdAt: now,
      updatedAt: now,
    );
    _worlds[id] = w;
    _emitWorlds();
    await _audit.recordWorldCreated(world: w, actorId: ownerId);
    return w;
  }

  @override
  Future<WorldEntity> updateWorld(WorldEntity world) async {
    _worlds[world.id] = world.copyWith(updatedAt: DateTime.now());
    _emitWorlds();
    return _worlds[world.id]!;
  }

  @override
  Future<WorldEntity> setStatus(String worldId, String status) async {
    final WorldEntity? w = _worlds[worldId];
    if (w == null) throw AdminNotFoundException('World not found');
    final WorldEntity updated = w.copyWith(
      status: WorkflowState.fromWire(status),
      updatedAt: DateTime.now(),
    );
    _worlds[worldId] = updated;
    _emitWorlds();
    return updated;
  }

  @override
  Future<List<WorldVersionEntity>> listVersions(String worldId) async {
    return _versions.values
        .where((WorldVersionEntity v) => v.worldId == worldId)
        .sorted((WorldVersionEntity a, WorldVersionEntity b) =>
            b.createdAt.compareTo(a.createdAt))
        .toList();
  }

  @override
  Future<WorldVersionEntity> getVersion(String versionId) async {
    final WorldVersionEntity? v = _versions[versionId];
    if (v == null) throw AdminNotFoundException('Version not found');
    return v;
  }

  @override
  Future<WorldDraftEntity> openDraft({
    required String worldId,
    required String branchName,
    required String ownerId,
    String? baseVersionId,
  }) async {
    final String key = 'drf_${worldId}_$branchName';
    final WorldDraftEntity? existing = _drafts[key];
    if (existing != null) return existing;
    final DateTime now = DateTime.now();
    final String baseId =
        baseVersionId ?? _worlds[worldId]?.activeVersionId ?? 'pending';
    final WorldDraftEntity draft = WorldDraftEntity(
      id: key,
      worldId: worldId,
      baseVersionId: baseId,
      branchName: branchName,
      ownerId: ownerId,
      nodes: <NodeEntity>[],
      decorations: <DecorationEntity>[],
      buildings: <BuildingEntity>[],
      paths: <WorldPathEntity>[],
      updatedAt: now,
    );
    _drafts[key] = draft;
    _emitDraft(draft.id);
    return draft;
  }

  @override
  Future<WorldDraftEntity> getDraft(String draftId) async {
    final WorldDraftEntity? d = _drafts[draftId];
    if (d == null) throw AdminNotFoundException('Draft not found');
    return d;
  }

  @override
  Future<List<WorldDraftEntity>> listDrafts(String worldId) async {
    return _drafts.values
        .where((WorldDraftEntity d) => d.worldId == worldId)
        .toList();
  }

  @override
  Future<WorldDraftEntity> saveDraft(
    WorldDraftEntity draft, {
    required int expectedVersionCounter,
  }) async {
    if (draft.versionCounter != expectedVersionCounter) {
      throw AdminConflictException('Draft was modified by someone else',
          currentVersion: draft.versionCounter);
    }
    final WorldDraftEntity updated = draft.copyWith(
      versionCounter: draft.versionCounter + 1,
      updatedAt: DateTime.now(),
    );
    _drafts[draft.id] = updated;
    _emitDraft(updated.id);
    return updated;
  }

  @override
  Future<WorldVersionEntity> publishDraft({
    required String draftId,
    required String actorId,
    required String releaseNotes,
  }) async {
    final WorldDraftEntity? d = _drafts[draftId];
    if (d == null) throw AdminNotFoundException('Draft not found');
    final String versionId = Ulid.generate();
    final Map<String, dynamic> payload = d.toPayload();
    final WorldVersionEntity previous =
        _versions.values.firstWhereOrNull((WorldVersionEntity v) =>
                v.worldId == d.worldId && v.parentId == d.baseVersionId) ??
            _versions[d.baseVersionId] ??
            WorldVersionEntity(
              id: d.baseVersionId,
              worldId: d.worldId,
              parentId: null,
              status: WorkflowState.published,
              schemaVersion: _schemaVersion,
              rendererContractVersion: _rendererContract,
              payloadHash: '',
              payload: <String, dynamic>{},
              diffSummary: DiffSummaryEntity.empty,
              releaseNotes: '',
              createdBy: d.ownerId,
              createdAt: d.updatedAt,
            );
    final DiffSummaryEntity diff = _diff(previous.payload, payload);
    final WorldVersionEntity version = WorldVersionEntity(
      id: versionId,
      worldId: d.worldId,
      parentId: d.baseVersionId,
      status: WorkflowState.published,
      schemaVersion: _schemaVersion,
      rendererContractVersion: _rendererContract,
      payloadHash: HashUtils.sha256OfJson(payload),
      payload: payload,
      diffSummary: diff,
      releaseNotes: releaseNotes,
      createdBy: d.ownerId,
      createdAt: DateTime.now(),
      publishedBy: actorId,
      publishedAt: DateTime.now(),
      branchName: d.branchName,
    );
    _versions[versionId] = version;
    final WorldEntity? world = _worlds[d.worldId];
    if (world != null) {
      _worlds[d.worldId] = world.copyWith(
        activeVersionId: versionId,
        status: WorkflowState.published,
        updatedAt: DateTime.now(),
      );
      _emitWorlds();
    }
    await _audit.recordWorldPublished(version: version, actorId: actorId);
    return version;
  }

  @override
  Future<WorldVersionEntity> rollback({
    required String worldId,
    required String targetVersionId,
    required String actorId,
    required String reason,
  }) async {
    final WorldVersionEntity? target = _versions[targetVersionId];
    if (target == null) throw AdminNotFoundException('Target version not found');
    final String newId = Ulid.generate();
    final WorldVersionEntity snapshot = WorldVersionEntity(
      id: newId,
      worldId: worldId,
      parentId: _worlds[worldId]?.activeVersionId,
      status: WorkflowState.published,
      schemaVersion: target.schemaVersion,
      rendererContractVersion: target.rendererContractVersion,
      payloadHash: target.payloadHash,
      payload: target.payload,
      diffSummary: DiffSummaryEntity.empty,
      releaseNotes: 'Rollback to $targetVersionId — $reason',
      createdBy: actorId,
      createdAt: DateTime.now(),
      publishedBy: actorId,
      publishedAt: DateTime.now(),
      branchName: target.branchName,
    );
    _versions[newId] = snapshot;
    final WorldEntity? w = _worlds[worldId];
    if (w != null) {
      _worlds[worldId] = w.copyWith(
        activeVersionId: newId,
        status: WorkflowState.published,
        updatedAt: DateTime.now(),
      );
      _emitWorlds();
    }
    await _audit.recordRollback(world: worldId, versionId: newId, actorId: actorId, reason: reason);
    return snapshot;
  }

  @override
  Future<WorldDraftEntity> mergeDrafts({
    required String sourceDraftId,
    required String targetDraftId,
    required String actorId,
  }) async {
    final WorldDraftEntity? source = _drafts[sourceDraftId];
    final WorldDraftEntity? target = _drafts[targetDraftId];
    if (source == null || target == null) {
      throw AdminNotFoundException('Source or target draft missing');
    }
    final Set<String> targetNodeIds =
        target.nodes.map((NodeEntity n) => n.id).toSet();
    final Set<String> targetDecIds =
        target.decorations.map((DecorationEntity d) => d.id).toSet();
    final Set<String> targetBldIds =
        target.buildings.map((BuildingEntity b) => b.id).toSet();
    final Set<String> targetPathIds =
        target.paths.map((WorldPathEntity p) => p.id).toSet();
    final List<NodeEntity> mergedNodes = <NodeEntity>[
      ...target.nodes,
      ...source.nodes
          .where((NodeEntity n) => !targetNodeIds.contains(n.id)),
    ];
    final List<DecorationEntity> mergedDec = <DecorationEntity>[
      ...target.decorations,
      ...source.decorations
          .where((DecorationEntity d) => !targetDecIds.contains(d.id)),
    ];
    final List<BuildingEntity> mergedBld = <BuildingEntity>[
      ...target.buildings,
      ...source.buildings
          .where((BuildingEntity b) => !targetBldIds.contains(b.id)),
    ];
    final List<WorldPathEntity> mergedPaths = <WorldPathEntity>[
      ...target.paths,
      ...source.paths
          .where((WorldPathEntity p) => !targetPathIds.contains(p.id)),
    ];
    final WorldDraftEntity merged = target.copyWith(
      nodes: mergedNodes,
      decorations: mergedDec,
      buildings: mergedBld,
      paths: mergedPaths,
      versionCounter: target.versionCounter + 1,
      updatedAt: DateTime.now(),
    );
    _drafts[targetDraftId] = merged;
    _emitDraft(merged.id);
    return merged;
  }

  @override
  Stream<List<WorldEntity>> watchWorlds() {
    final String key = 'all';
    final StreamController<List<WorldEntity>>? existing = _worldStreams[key];
    if (existing != null) return existing.stream;
    late StreamController<List<WorldEntity>> controller;
    controller = StreamController<List<WorldEntity>>.broadcast(
      onListen: () {
        // Push the current snapshot to the freshly-attached listener so the
        // list screen unblocks immediately instead of waiting forever for
        // the first write. Without this initial seed, the dashboard and
        // worlds screen stay in their loading branches until something
        // mutates the repo (createWorld, updateWorld, setStatus).
        scheduleMicrotask(() {
          if (!controller.isClosed) {
            controller.add(_worlds.values.toList());
          }
        });
      },
    );
    _worldStreams[key] = controller;
    controller.onCancel = () {
      _worldStreams.remove(key);
    };
    return controller.stream;
  }

  @override
  Stream<WorldDraftEntity?> watchDraft(String draftId) {
    final StreamController<WorldDraftEntity?>? existing = _draftStreams[draftId];
    if (existing != null) return existing.stream;
    late StreamController<WorldDraftEntity?> controller;
    controller = StreamController<WorldDraftEntity?>.broadcast(
      onListen: () {
        // Mirror the initial-snapshot pattern from watchWorlds so the editor
        // receives the current draft state instead of waiting forever.
        scheduleMicrotask(() {
          if (!controller.isClosed) {
            controller.add(_drafts[draftId]);
          }
        });
      },
    );
    _draftStreams[draftId] = controller;
    controller.onCancel = () {
      _draftStreams.remove(draftId);
    };
    return controller.stream;
  }

  void _emitWorlds() {
    for (final StreamController<List<WorldEntity>> c
        in _worldStreams.values.toList()) {
      c.add(_worlds.values.toList());
    }
  }

  void _emitDraft(String id) {
    final StreamController<WorldDraftEntity?>? c = _draftStreams[id];
    c?.add(_drafts[id]);
  }

  DiffSummaryEntity _diff(Map<String, dynamic> a, Map<String, dynamic> b) {
    List<String> ids(List<dynamic> input) =>
        input.map((dynamic e) => (e as Map)['id'] as String).toList();
    final List<String> prev = ids(a['nodes'] as List<dynamic>? ?? const <dynamic>[]);
    final List<String> next = ids(b['nodes'] as List<dynamic>? ?? const <dynamic>[]);
    final List<String> added = next.where((String id) => !prev.contains(id)).toList();
    final List<String> removed = prev.where((String id) => !next.contains(id)).toList();
    final List<String> modified = next.where((String id) => prev.contains(id)).toList();
    return DiffSummaryEntity(
      addedNodeIds: added,
      removedNodeIds: removed,
      modifiedNodeIds: modified,
      addedDecorationIds: const <String>[],
      modifiedDecorationIds: const <String>[],
      addedPathIds: const <String>[],
      modifiedPathIds: const <String>[],
      totalChanges: added.length + removed.length + modified.length,
    );
  }
}

final worldRepositoryProvider = Provider<WorldRepository>((Ref ref) {
  return WorldRepositoryImpl(ref.watch(auditRepositoryProvider));
});
