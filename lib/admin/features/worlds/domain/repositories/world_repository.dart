import '../entities/world_draft_entity.dart';
import '../entities/world_entity.dart';
import '../entities/world_version_entity.dart';

abstract class WorldRepository {
  Future<List<WorldEntity>> listWorlds();
  Future<WorldEntity> getWorld(String id);
  Future<WorldEntity> createWorld({
    required String slug,
    required String displayName,
    required String examVertical,
    required String description,
    required String ownerId,
  });
  Future<WorldEntity> updateWorld(WorldEntity world);
  Future<WorldEntity> setStatus(String worldId, String status);

  Future<List<WorldVersionEntity>> listVersions(String worldId);
  Future<WorldVersionEntity> getVersion(String versionId);

  Future<WorldDraftEntity> openDraft({
    required String worldId,
    required String branchName,
    required String ownerId,
    String? baseVersionId,
  });
  Future<WorldDraftEntity> getDraft(String draftId);
  Future<List<WorldDraftEntity>> listDrafts(String worldId);
  Future<WorldDraftEntity> saveDraft(
    WorldDraftEntity draft, {
    required int expectedVersionCounter,
  });
  Future<WorldVersionEntity> publishDraft({
    required String draftId,
    required String actorId,
    required String releaseNotes,
  });
  Future<WorldVersionEntity> rollback({
    required String worldId,
    required String targetVersionId,
    required String actorId,
    required String reason,
  });
  Future<WorldDraftEntity> mergeDrafts({
    required String sourceDraftId,
    required String targetDraftId,
    required String actorId,
  });

  Stream<List<WorldEntity>> watchWorlds();
  Stream<WorldDraftEntity?> watchDraft(String draftId);
}
