import 'package:flutter/foundation.dart';

/// Lifecycle stages a single mission can occupy for a specific user.
///
/// Mirrors the public-facing [MissionStatus] but adds a `perfect`
/// bucket the player lands in after a flawless run (every goal
/// counter reached and the score is exactly 100%). The two enums are
/// deliberately separate so the backend can stay stable when the
/// client adds new local-only statuses later.
enum MissionCompletionStatus {
  locked,
  unlocked,
  started,
  completed,
  perfect,
  expired,
}

/// Per-user summary of a single mission.
///
/// Lives at `users/{uid}/mission_progress/{missionId}` so each user
/// keeps an isolated ledger of stars, best score, completion
/// timestamps, and history. The presentation layer reads it via the
/// realtime stream surfaced by [MissionProgressService] and merges
/// it with the catalog [MissionEntity] from the local datasource.
@immutable
class MissionSummaryEntity {
  const MissionSummaryEntity({
    required this.uid,
    required this.missionId,
    required this.stars,
    required this.bestScore,
    required this.completionStatus,
    required this.completionTimestampsIso,
    required this.totalCompleted,
    this.currentMissionId,
    this.rewardsClaimed = false,
    this.lastUpdatedAtIso,
  });

  /// Authenticated user this summary belongs to. Empty for the
  /// in-memory / guest path.
  final String uid;

  /// Catalog mission id (matches [MissionEntity.id]).
  final String missionId;

  /// Cumulative stars earned on this mission across attempts.
  /// Stars are monotonically non-decreasing on the server.
  final int stars;

  /// Best score (0-100) the user has ever achieved on this mission.
  /// The server never overwrites a higher score with a lower one.
  final int bestScore;

  /// Latest lifecycle status — see [MissionCompletionStatus].
  final MissionCompletionStatus completionStatus;

  /// ISO-8601 UTC timestamps for every successful completion, capped
  /// at the most recent 50 entries. Used by the history ledger.
  final List<String> completionTimestampsIso;

  /// Cumulative count of completions on this mission — drives the
  /// dashboard's "completed missions" tile.
  final int totalCompleted;

  /// Currently active mission (the next one in the carousel). When
  /// null the user has no mission highlighted. Optional because the
  /// field is populated lazily from the controller.
  final String? currentMissionId;

  /// True once the user has tapped "Claim" on this mission's reward.
  /// Once claimed the controller transitions the mission into the
  /// `claimed` UI state — this boolean is the canonical store.
  final bool rewardsClaimed;

  /// ISO-8601 UTC timestamp of the last summary mutation.
  final String? lastUpdatedAtIso;

  bool get isCompleted =>
      completionStatus == MissionCompletionStatus.completed ||
      completionStatus == MissionCompletionStatus.perfect;

  bool get isPerfect => completionStatus == MissionCompletionStatus.perfect;

  bool get isUnlocked =>
      completionStatus != MissionCompletionStatus.locked;

  /// Aggregate snapshot the dashboard shows on the Missions hub.
  /// Counts every status the user has touched at least once.
  static const MissionSummaryEntity empty = MissionSummaryEntity(
    uid: '',
    missionId: '',
    stars: 0,
    bestScore: 0,
    completionStatus: MissionCompletionStatus.locked,
    completionTimestampsIso: <String>[],
    totalCompleted: 0,
    rewardsClaimed: false,
  );

  MissionSummaryEntity copyWith({
    String? uid,
    String? missionId,
    int? stars,
    int? bestScore,
    MissionCompletionStatus? completionStatus,
    List<String>? completionTimestampsIso,
    int? totalCompleted,
    String? currentMissionId,
    bool? rewardsClaimed,
    String? lastUpdatedAtIso,
    bool clearCurrentMission = false,
  }) {
    return MissionSummaryEntity(
      uid: uid ?? this.uid,
      missionId: missionId ?? this.missionId,
      stars: stars ?? this.stars,
      bestScore: bestScore ?? this.bestScore,
      completionStatus: completionStatus ?? this.completionStatus,
      completionTimestampsIso:
          completionTimestampsIso ?? this.completionTimestampsIso,
      totalCompleted: totalCompleted ?? this.totalCompleted,
      currentMissionId:
          clearCurrentMission ? null : (currentMissionId ?? this.currentMissionId),
      rewardsClaimed: rewardsClaimed ?? this.rewardsClaimed,
      lastUpdatedAtIso: lastUpdatedAtIso ?? this.lastUpdatedAtIso,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'missionId': missionId,
      'stars': stars,
      'bestScore': bestScore,
      'completionStatus': completionStatus.name,
      'completionTimestampsIso':
          List<String>.from(completionTimestampsIso, growable: false),
      'totalCompleted': totalCompleted,
      'currentMissionId': currentMissionId,
      'rewardsClaimed': rewardsClaimed,
      'lastUpdatedAtIso': lastUpdatedAtIso,
    };
  }

  static MissionSummaryEntity fromMap(Map<String, dynamic> map) {
    final List<String> timestamps = (map['completionTimestampsIso']
            as List<dynamic>?)
        ?.map((dynamic entry) => entry?.toString() ?? '')
        .where((String entry) => entry.isNotEmpty)
        .toList(growable: false) ??
        const <String>[];
    return MissionSummaryEntity(
      uid: (map['uid'] as String?) ?? '',
      missionId: (map['missionId'] as String?) ?? '',
      stars: (map['stars'] as num?)?.toInt() ?? 0,
      bestScore: (map['bestScore'] as num?)?.toInt() ?? 0,
      completionStatus: _statusFromId(map['completionStatus'] as String?),
      completionTimestampsIso: timestamps,
      totalCompleted: (map['totalCompleted'] as num?)?.toInt() ?? 0,
      currentMissionId: map['currentMissionId'] as String?,
      rewardsClaimed: (map['rewardsClaimed'] as bool?) ?? false,
      lastUpdatedAtIso: map['lastUpdatedAtIso'] as String?,
    );
  }

  static MissionCompletionStatus _statusFromId(String? id) {
    if (id == null) return MissionCompletionStatus.locked;
    for (final MissionCompletionStatus status
        in MissionCompletionStatus.values) {
      if (status.name == id) return status;
    }
    return MissionCompletionStatus.locked;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MissionSummaryEntity) return false;
    return uid == other.uid &&
        missionId == other.missionId &&
        stars == other.stars &&
        bestScore == other.bestScore &&
        completionStatus == other.completionStatus &&
        totalCompleted == other.totalCompleted &&
        rewardsClaimed == other.rewardsClaimed &&
        currentMissionId == other.currentMissionId &&
        lastUpdatedAtIso == other.lastUpdatedAtIso &&
        _listEquals(completionTimestampsIso, other.completionTimestampsIso);
  }

  @override
  int get hashCode => Object.hash(
        uid,
        missionId,
        stars,
        bestScore,
        completionStatus,
        totalCompleted,
        rewardsClaimed,
        currentMissionId,
        lastUpdatedAtIso,
        Object.hashAll(completionTimestampsIso),
      );

  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
