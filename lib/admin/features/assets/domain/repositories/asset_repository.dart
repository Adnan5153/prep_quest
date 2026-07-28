import '../../../../shared/enums/workflow_state.dart';
import '../entities/asset_entity.dart';

abstract class AssetRepository {
  Future<List<AssetEntity>> listAssets({String? query, AssetKind? kind});
  Future<AssetEntity> getAsset(String id);
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
  });
  Future<AssetEntity> deprecateAsset(String id);
  Future<AssetEntity> addVersion(
    String id, {
    required String url,
    required int sizeBytes,
    required String hash,
  });
}
