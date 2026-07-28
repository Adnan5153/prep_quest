import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/enums/workflow_state.dart';
import '../../data/repositories/asset_repository_impl.dart';
import '../../domain/entities/asset_entity.dart';

class AssetSummary {
  const AssetSummary({
    required this.id,
    required this.displayName,
    required this.kind,
    required this.url,
    required this.width,
    required this.height,
  });

  final String id;
  final String displayName;
  final AssetKind kind;
  final String url;
  final int? width;
  final int? height;

  factory AssetSummary.fromEntity(AssetEntity a) => AssetSummary(
        id: a.id,
        displayName: a.displayName,
        kind: a.kind,
        url: a.url,
        width: a.width,
        height: a.height,
      );
}

final assetsListProvider =
    FutureProvider.family<List<AssetSummary>, AssetKind?>((Ref ref, AssetKind? kind) async {
  final List<AssetEntity> list = await ref.watch(assetRepositoryProvider).listAssets(kind: kind);
  return list.map(AssetSummary.fromEntity).toList();
});

final allAssetsProvider = FutureProvider<List<AssetSummary>>((Ref ref) async {
  final List<AssetEntity> list = await ref.watch(assetRepositoryProvider).listAssets();
  return list.map(AssetSummary.fromEntity).toList();
});

final assetKindFilterProvider = StateProvider<AssetKind?>((Ref ref) => null);
final assetSearchQueryProvider = StateProvider<String>((Ref ref) => '');
