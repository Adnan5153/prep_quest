import 'package:flutter/foundation.dart';

/// One pass on a mission, produced by the quiz-completion funnel
/// and fed to [MissionProgressRepository.recordAttempt].
///
/// `sessionId` is the canonical dedup key — every retry/replay with
/// the same `sessionId` is silently ignored. The repository enforces
/// monotonic star accumulation and `bestScore = max(prev, score)`.
@immutable
class MissionProgressAttempt {
  const MissionProgressAttempt({
    required this.sessionId,
    required this.score,
    required this.achievedGoal,
    this.completedAtIso,
    this.metadata = const <String, dynamic>{},
  });

  /// Stable id for this pass — usually `QuizSessionEntity.sessionId`.
  /// Two attempts with the same id on the same mission collapse into
  /// one effective update.
  final String sessionId;

  /// 0-100 percentage score.
  final int score;

  /// Whether the user reached the mission's goal on this attempt.
  /// Drives the `completed`/`perfect` transition.
  final bool achievedGoal;

  /// ISO-8601 UTC timestamp. Defaults to `now` server-side if null.
  final String? completedAtIso;

  /// Optional metadata persisted alongside the history entry (e.g.
  /// `{'quizId': ..., 'categoryId': ...}`).
  final Map<String, dynamic> metadata;

  bool get isPerfect => achievedGoal && score >= 100;
}
