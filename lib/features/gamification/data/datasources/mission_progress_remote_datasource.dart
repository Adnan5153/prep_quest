import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_keys.dart';
import '../../domain/entities/mission_summary_entity.dart';

/// Abstraction for the Firestore-backed mission progress ledger.
///
/// The contract is intentionally narrow so the offline /
/// non-configured path can replace the Firestore implementation with
/// an in-memory map (see [InMemoryMissionProgressRemoteDataSource])
/// without leaking transport details.
abstract class MissionProgressRemoteDataSource {
  /// Real-time list of every persisted summary for [uid]. Cancelling
  /// the subscription stops the snapshot listener.
  Stream<List<MissionSummaryEntity>> watch(String uid);

  /// One-shot fetch for callers that want a deterministic snapshot
  /// without a subscription (tests, bootstrap).
  Future<List<MissionSummaryEntity>> list(String uid);

  /// Loads a single summary doc, or `null` if none exists.
  Future<MissionSummaryEntity?> read({required String uid, required String missionId});

  /// Writes/merges a summary. Returns the canonical entity that was
  /// written so the caller can update its local mirror without a
  /// follow-up read.
  Future<MissionSummaryEntity> write(MissionSummaryEntity summary);

  /// Convenience helper for atomic transaction-driven updates. The
  /// returned [DocumentReference] lets callers participate in an
  /// enclosing `firestore.runTransaction` block (see
  /// [MissionProgressService.recordAttempt]).
  DocumentReference<Map<String, dynamic>> referenceFor({
    required String uid,
    required String missionId,
  });
}

/// In-memory fallback for non-Firebase environments (unit tests and
/// the period before `Firebase.initializeApp` has run).
class InMemoryMissionProgressRemoteDataSource
    implements MissionProgressRemoteDataSource {
  InMemoryMissionProgressRemoteDataSource();

  final Map<String, Map<String, MissionSummaryEntity>> _store =
      <String, Map<String, MissionSummaryEntity>>{};

  final StreamController<List<MissionSummaryEntity>> _controller =
      StreamController<List<MissionSummaryEntity>>.broadcast();

  List<MissionSummaryEntity> _snapshot(String uid) {
    final Map<String, MissionSummaryEntity>? mine = _store[uid];
    if (mine == null) return const <MissionSummaryEntity>[];
    return List<MissionSummaryEntity>.unmodifiable(mine.values);
  }

  void _emit(String uid) {
    _controller.add(_snapshot(uid));
  }

  @override
  Stream<List<MissionSummaryEntity>> watch(String uid) async* {
    yield _snapshot(uid);
    yield* _controller.stream.map((_) => _snapshot(uid));
  }

  @override
  Future<List<MissionSummaryEntity>> list(String uid) async => _snapshot(uid);

  @override
  Future<MissionSummaryEntity?> read({
    required String uid,
    required String missionId,
  }) async {
    final Map<String, MissionSummaryEntity>? mine = _store[uid];
    return mine?[missionId];
  }

  @override
  Future<MissionSummaryEntity> write(MissionSummaryEntity summary) async {
    final Map<String, MissionSummaryEntity> mine = _store.putIfAbsent(
      summary.uid,
      () => <String, MissionSummaryEntity>{},
    );
    mine[summary.missionId] = summary;
    _emit(summary.uid);
    return summary;
  }

  @override
  DocumentReference<Map<String, dynamic>> referenceFor({
    required String uid,
    required String missionId,
  }) {
    throw UnsupportedError(
      'InMemoryMissionProgressRemoteDataSource has no DocumentReference.',
    );
  }

  void clear() {
    _store.clear();
  }
}

/// Firestore-backed implementation.
///
/// Schema:
/// ```
/// users/{uid}/mission_progress/{missionId}
///   uid: string
///   missionId: string
///   stars: int
///   bestScore: int
///   completionStatus: 'locked'|'unlocked'|'started'|'completed'|'perfect'|'expired'
///   completionTimestampsIso: [string iso8601] (capped 50, newest first)
///   totalCompleted: int
///   currentMissionId: string?
///   rewardsClaimed: bool
///   lastUpdatedAtIso: string iso8601
/// ```
class FirestoreMissionProgressRemoteDataSource
    implements MissionProgressRemoteDataSource {
  const FirestoreMissionProgressRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection(FirestoreKeys.missionProgressSubcollection);
  }

  DocumentReference<Map<String, dynamic>> _reference({
    required String uid,
    required String missionId,
  }) {
    return _collection(uid).doc(missionId);
  }

  @override
  Stream<List<MissionSummaryEntity>> watch(String uid) {
    return _collection(uid)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snap) {
      return List<MissionSummaryEntity>.unmodifiable(
        snap.docs
            .where((QueryDocumentSnapshot<Map<String, dynamic>> d) => d.exists)
            .map((QueryDocumentSnapshot<Map<String, dynamic>> d) {
              final Map<String, dynamic> raw = d.data();
              return MissionSummaryEntity.fromMap(<String, dynamic>{
                ...raw,
                'uid': raw['uid']?.toString() ?? uid,
                'missionId': raw['missionId']?.toString() ?? d.id,
              });
            }),
      );
    });
  }

  @override
  Future<List<MissionSummaryEntity>> list(String uid) async {
    final QuerySnapshot<Map<String, dynamic>> snap =
        await _collection(uid).get();
    return List<MissionSummaryEntity>.unmodifiable(
      snap.docs
          .where((QueryDocumentSnapshot<Map<String, dynamic>> d) => d.exists)
          .map((QueryDocumentSnapshot<Map<String, dynamic>> d) {
            final Map<String, dynamic> raw = d.data();
            return MissionSummaryEntity.fromMap(<String, dynamic>{
              ...raw,
              'uid': raw['uid']?.toString() ?? uid,
              'missionId': raw['missionId']?.toString() ?? d.id,
            });
          }),
    );
  }

  @override
  Future<MissionSummaryEntity?> read({
    required String uid,
    required String missionId,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>> snap =
        await _reference(uid: uid, missionId: missionId).get();
    if (!snap.exists) return null;
    final Map<String, dynamic> raw = snap.data() ?? <String, dynamic>{};
    return MissionSummaryEntity.fromMap(<String, dynamic>{
      ...raw,
      'uid': raw['uid']?.toString() ?? uid,
      'missionId': raw['missionId']?.toString() ?? missionId,
    });
  }

  @override
  Future<MissionSummaryEntity> write(MissionSummaryEntity summary) async {
    final Map<String, dynamic> payload = summary.toMap();
    await _reference(uid: summary.uid, missionId: summary.missionId)
        .set(payload, SetOptions(merge: true));
    return summary;
  }

  @override
  DocumentReference<Map<String, dynamic>> referenceFor({
    required String uid,
    required String missionId,
  }) {
    return _reference(uid: uid, missionId: missionId);
  }
}
