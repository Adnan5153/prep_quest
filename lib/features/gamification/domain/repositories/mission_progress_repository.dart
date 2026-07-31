import 'dart:async';

import '../../../../core/services/mission_progress_attempt.dart';
import '../../../../shared/typedefs/result.dart';
import '../entities/mission_entity.dart';
import '../entities/mission_summary_entity.dart';

/// Aggregate snapshot returned by [MissionProgressRepository.watch].
class MissionProgressBundle {
  const MissionProgressBundle({
    required this.summaries,
    required this.totalCompleted,
    required this.totalStars,
    required this.bestScoreOverall,
  });

  /// Per-mission summaries keyed by missionId in [summaries].
  final List<MissionSummaryEntity> summaries;

  /// Total number of completed missions across all summaries. Drives
  /// the dashboard's "completed" tile and the profile's "missions
  /// finished" counter.
  final int totalCompleted;

  /// Cumulative stars earned across every tracked mission.
  final int totalStars;

  /// Highest score the user has ever recorded across any mission
  /// (0-100). Useful for the achievements hub banner.
  final int bestScoreOverall;

  static const MissionProgressBundle empty = MissionProgressBundle(
    summaries: <MissionSummaryEntity>[],
    totalCompleted: 0,
    totalStars: 0,
    bestScoreOverall: 0,
  );
}

/// Read/write surface for per-user mission progress.
abstract class MissionProgressRepository {
  /// Real-time stream of every summary the user owns.
  Stream<MissionProgressBundle> watch(String uid);

  /// One-shot fetch — useful during bootstrap.
  Future<MissionProgressBundle> list(String uid);

  /// Reads a single mission's summary, returning
  /// [MissionSummaryEntity.empty] when the user has never attempted
  /// the mission.
  Future<MissionSummaryEntity> summary({
    required String uid,
    required String missionId,
  });

  /// Applies a single attempt produced by the quiz-completion
  /// funnel. Implements dedup, star accumulation, best-score
  /// protection, completion-status transition, and history append in
  /// one place. Returns the canonical post-write summary so the
  /// controller can update its local mirror without a follow-up read.
  Future<Result<MissionSummaryEntity>> recordAttempt({
    required String uid,
    required MissionEntity mission,
    required MissionProgressAttempt attempt,
  });

  /// Marks the rewards for a given mission as claimed. Idempotent —
  /// subsequent calls are no-ops.
  Future<Result<MissionSummaryEntity>> markRewardsClaimed({
    required String uid,
    required String missionId,
  });
}
