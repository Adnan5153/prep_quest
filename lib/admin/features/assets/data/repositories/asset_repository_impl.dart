import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/ulid.dart';
import '../../../../shared/enums/workflow_state.dart';
import '../../domain/entities/asset_entity.dart';
import '../../domain/repositories/asset_repository.dart';

class AssetRepositoryImpl implements AssetRepository {
  AssetRepositoryImpl() {
    _seed();
  }

  final Map<String, AssetEntity> _assets = <String, AssetEntity>{};

  void _seed() {
    final DateTime now = DateTime.now();
    final List<AssetEntity> seed = <AssetEntity>[
      AssetEntity(
        id: 'ast_node_default',
        slug: 'node-default',
        displayName: 'Lesson Node',
        kind: AssetKind.image,
        mimeType: 'image/png',
        url: 'asset://nodes/lesson.png',
        sizeBytes: 24_512,
        width: 96,
        height: 96,
        tags: const <String>['node', 'default'],
        versions: <AssetVersion>[
          AssetVersion(
            id: Ulid.generate(),
            version: 1,
            url: 'asset://nodes/lesson.png',
            sizeBytes: 24_512,
            hash: 'a1b2c3',
            createdAt: now.subtract(const Duration(days: 30)),
          ),
        ],
        status: WorkflowState.published,
        uploadedBy: 'usr_admin',
        uploadedAt: now.subtract(const Duration(days: 30)),
        altText: 'A glowing lesson node marker.',
      ),
      AssetEntity(
        id: 'ast_boss_default',
        slug: 'boss-default',
        displayName: 'Boss Gate',
        kind: AssetKind.image,
        mimeType: 'image/png',
        url: 'asset://nodes/boss.png',
        sizeBytes: 32_400,
        width: 128,
        height: 128,
        tags: const <String>['node', 'boss'],
        versions: const <AssetVersion>[],
        status: WorkflowState.published,
        uploadedBy: 'usr_admin',
        uploadedAt: now.subtract(const Duration(days: 30)),
        altText: 'A glowing boss gate marker.',
      ),
      AssetEntity(
        id: 'ast_tree_pine',
        slug: 'tree-pine',
        displayName: 'Pine Tree',
        kind: AssetKind.image,
        mimeType: 'image/png',
        url: 'asset://decorations/tree_pine.png',
        sizeBytes: 18_700,
        width: 64,
        height: 96,
        tags: const <String>['tree', 'forest'],
        versions: const <AssetVersion>[],
        status: WorkflowState.published,
        uploadedBy: 'usr_admin',
        uploadedAt: now.subtract(const Duration(days: 30)),
      ),
      AssetEntity(
        id: 'ast_building_academy',
        slug: 'academy',
        displayName: 'Academy Building',
        kind: AssetKind.image,
        mimeType: 'image/png',
        url: 'asset://buildings/academy.png',
        sizeBytes: 64_800,
        width: 192,
        height: 256,
        tags: const <String>['building', 'academy'],
        versions: const <AssetVersion>[],
        status: WorkflowState.published,
        uploadedBy: 'usr_admin',
        uploadedAt: now.subtract(const Duration(days: 30)),
      ),
      AssetEntity(
        id: 'ast_bcs_cover',
        slug: 'bcs-cover',
        displayName: 'BCS Cover',
        kind: AssetKind.image,
        mimeType: 'image/png',
        url: 'asset://covers/bcs.png',
        sizeBytes: 96_400,
        width: 512,
        height: 256,
        tags: const <String>['cover', 'bcs'],
        versions: const <AssetVersion>[],
        status: WorkflowState.published,
        uploadedBy: 'usr_admin',
        uploadedAt: now.subtract(const Duration(days: 30)),
      ),
      AssetEntity(
        id: 'ast_bangla_flag',
        slug: 'banner-bangla',
        displayName: 'Bangla Flag',
        kind: AssetKind.image,
        mimeType: 'image/png',
        url: 'asset://decorations/bangla_flag.png',
        sizeBytes: 16_200,
        width: 64,
        height: 64,
        tags: const <String>['flag', 'bangla'],
        versions: const <AssetVersion>[],
        status: WorkflowState.published,
        uploadedBy: 'usr_admin',
        uploadedAt: now.subtract(const Duration(days: 30)),
      ),
      AssetEntity(
        id: 'ast_node_glow',
        slug: 'node-glow-animation',
        displayName: 'Node Glow Animation',
        kind: AssetKind.lottie,
        mimeType: 'application/json',
        url: 'asset://animations/node_glow.json',
        sizeBytes: 28_400,
        tags: const <String>['animation', 'node'],
        versions: const <AssetVersion>[],
        status: WorkflowState.published,
        uploadedBy: 'usr_admin',
        uploadedAt: now.subtract(const Duration(days: 14)),
      ),
      AssetEntity(
        id: 'ast_music_home',
        slug: 'music-meadow',
        displayName: 'Meadow Ambient',
        kind: AssetKind.audio,
        mimeType: 'audio/mpeg',
        url: 'asset://audio/meadow.mp3',
        sizeBytes: 1_245_000,
        tags: const <String>['music', 'ambient'],
        versions: const <AssetVersion>[],
        status: WorkflowState.published,
        uploadedBy: 'usr_admin',
        uploadedAt: now.subtract(const Duration(days: 28)),
      ),
    ];
    for (final AssetEntity a in seed) {
      _assets[a.id] = a;
    }
  }

  @override
  Future<List<AssetEntity>> listAssets({String? query, AssetKind? kind}) async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    Iterable<AssetEntity> filtered = _assets.values;
    if (kind != null) filtered = filtered.where((AssetEntity a) => a.kind == kind);
    if (query != null && query.isNotEmpty) {
      final String q = query.toLowerCase();
      filtered = filtered.where((AssetEntity a) =>
          a.slug.contains(q) ||
          a.displayName.toLowerCase().contains(q) ||
          a.tags.any((String t) => t.contains(q)));
    }
    return filtered.sortedBy<String>((AssetEntity a) => a.slug).toList();
  }

  @override
  Future<AssetEntity> getAsset(String id) async {
    final AssetEntity? a = _assets[id];
    if (a == null) throw StateError('Asset not found');
    return a;
  }

  @override
  Future<AssetEntity> uploadAsset({
    required String slug,
    required String displayName,
    required AssetKind kind,
    required String mimeType,
    required String url,
    required int sizeBytes,
    required List<String> tags,
    required String uploadedBy,
    int? width,
    int? height,
    String? altText,
  }) async {
    final String id = 'ast_${Ulid.generate()}';
    final AssetEntity asset = AssetEntity(
      id: id,
      slug: slug,
      displayName: displayName,
      kind: kind,
      mimeType: mimeType,
      url: url,
      sizeBytes: sizeBytes,
      width: width,
      height: height,
      tags: tags,
      versions: <AssetVersion>[
        AssetVersion(
          id: Ulid.generate(),
          version: 1,
          url: url,
          sizeBytes: sizeBytes,
          hash: 'pending',
          createdAt: DateTime.now(),
        ),
      ],
      status: WorkflowState.published,
      uploadedBy: uploadedBy,
      uploadedAt: DateTime.now(),
      altText: altText,
    );
    _assets[id] = asset;
    return asset;
  }

  @override
  Future<AssetEntity> deprecateAsset(String id) async {
    final AssetEntity? a = _assets[id];
    if (a == null) throw StateError('Asset not found');
    final AssetEntity updated = a.copyWith(status: WorkflowState.archived);
    _assets[id] = updated;
    return updated;
  }

  @override
  Future<AssetEntity> addVersion(
    String id, {
    required String url,
    required int sizeBytes,
    required String hash,
  }) async {
    final AssetEntity? a = _assets[id];
    if (a == null) throw StateError('Asset not found');
    final AssetEntity updated = a.copyWith(
      url: url,
      sizeBytes: sizeBytes,
      versions: <AssetVersion>[
        ...a.versions,
        AssetVersion(
          id: Ulid.generate(),
          version: a.versions.length + 1,
          url: url,
          sizeBytes: sizeBytes,
          hash: hash,
          createdAt: DateTime.now(),
        ),
      ],
    );
    _assets[id] = updated;
    return updated;
  }
}

final assetRepositoryProvider = Provider<AssetRepository>((Ref ref) {
  return AssetRepositoryImpl();
});
