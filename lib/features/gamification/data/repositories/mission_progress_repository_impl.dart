import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/mission_progress_attempt.dart';
import '../../../../core/services/mission_progress_service.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/mission_entity.dart';
import '../../domain/entities/mission_summary_entity.dart';
import '../../domain/repositories/mission_progress_repository.dart';

/// Concrete repository — wraps [MissionProgressService] and adapts
/// its API to the domain contract. Lives here so consumers depend
/// only on the abstract repository.
class MissionProgressRepositoryImpl implements MissionProgressRepository {
  MissionProgressRepositoryImpl({
    required MissionProgressService service,
  }) : _service = service;

  final MissionProgressService _service;

  @override
  Stream<MissionProgressBundle> watch(String uid) {
    return _service.watch(uid).map(_bundleFrom);
  }

  @override
  Future<MissionProgressBundle> list(String uid) async {
    final List<MissionSummaryEntity> rows = await _service.list(uid);
    return _bundleFrom(rows);
  }

  @override
  Future<MissionSummaryEntity> summary({
    required String uid,
    required String missionId,
  }) {
    return _service.summary(uid: uid, missionId: missionId);
  }

  @override
  Future<Result<MissionSummaryEntity>> recordAttempt({
    required String uid,
    required MissionEntity mission,
    required MissionProgressAttempt attempt,
  }) {
    return _service.recordAttempt(
      uid: uid,
      mission: mission,
      attempt: attempt,
    );
  }

  @override
  Future<Result<MissionSummaryEntity>> markRewardsClaimed({
    required String uid,
    required String missionId,
  }) {
    return _service.markRewardsClaimed(uid: uid, missionId: missionId);
  }

  static MissionProgressBundle _bundleFrom(List<MissionSummaryEntity> rows) {
    if (rows.isEmpty) return MissionProgressBundle.empty;
    int totalCompleted = 0;
    int totalStars = 0;
    int bestScoreOverall = 0;
    for (final MissionSummaryEntity s in rows) {
      totalCompleted += s.totalCompleted;
      totalStars += s.stars;
      if (s.bestScore > bestScoreOverall) bestScoreOverall = s.bestScore;
    }
    return MissionProgressBundle(
      summaries: List<MissionSummaryEntity>.unmodifiable(rows),
      totalCompleted: totalCompleted,
      totalStars: totalStars,
      bestScoreOverall: bestScoreOverall,
    );
  }
}

/// Riverpod provider — single instance per ProviderContainer.
final missionProgressRepositoryProvider =
    Provider<MissionProgressRepository>((ref) {
  return MissionProgressRepositoryImpl(
    service: ref.watch(missionProgressServiceProvider),
  );
});
