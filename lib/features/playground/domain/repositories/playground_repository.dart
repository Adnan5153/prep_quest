import '../../../../shared/typedefs/result.dart';
import '../entities/challenge_entity.dart';
import '../entities/level_entity.dart';
import '../entities/world_entity.dart';

/// Snapshot returned by the progress stream. The active node id is the
/// node the player is currently working on; the focused node id is the
/// node the camera should currently point to.
class PlaygroundProgress {
  const PlaygroundProgress({
    required this.world,
    required this.cameraOffsetY,
    required this.zoom,
  });

  final WorldEntity world;
  final double cameraOffsetY;
  final double zoom;
}

/// Contract every Playground repository must satisfy.
///
/// The presentation layer depends on this interface only.
abstract class PlaygroundRepository {
  /// Returns the world map for the active user. Implementations should
  /// synchronise against the in-memory cache so multiple reads return
  /// the same snapshot.
  Future<Result<WorldEntity>> getWorldMap();

  /// Returns the level for the given node id, or `null` if the node
  /// has no level.
  Future<Result<LevelEntity?>> getLevel(String nodeId);

  /// Returns the challenges of a level.
  Future<Result<List<ChallengeEntity>>> getChallenges(String levelId);

  /// Marks the supplied node as started. Idempotent.
  Future<Result<NodeActionResult>> startLevel(String nodeId);

  /// Marks the supplied level as completed. Idempotent. Returns the
  /// `levelReward` and the optional node id that becomes unlocked.
  Future<Result<NodeActionResult>> completeLevel(String nodeId);

  /// Marks a reward node as claimed. Idempotent.
  Future<Result<NodeActionResult>> claimReward(String nodeId);

  /// Persists the cursor used by the focused/centered node plus the
  /// camera translation/zoom.
  Future<Result<void>> persistCameraState({
    required String focusedNodeId,
    required double offsetY,
    required double zoom,
  });

  /// Stream of progress updates. Emits whenever the world, the
  /// focused node, or the camera state changes.
  Stream<PlaygroundProgress> watchProgress();
}

/// Outcome of a node-mutation request. The repository returns the
/// updated state, the reward payload (if any), and the id of the node
/// that was unlocked as a side effect.
class NodeActionResult {
  const NodeActionResult({
    required this.world,
    this.rewardXp = 0,
    this.rewardCoins = 0,
    this.unlockedNodeId,
  });

  final WorldEntity world;
  final int rewardXp;
  final int rewardCoins;
  final String? unlockedNodeId;
}
