import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_keys.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../domain/entities/app_user_entity.dart';
import '../../domain/entities/auth_identity_seed.dart';
import '../datasources/app_user_local_datasource.dart';
import '../datasources/app_user_remote_datasource.dart';
import '../datasources/firestore_app_user_remote_datasource.dart';
import '../datasources/mock_app_user_remote_datasource.dart';
import '../models/app_user_model.dart';

/// Concrete repository for the `user_account` feature.
///
/// Composes a [AppUserRemoteDataSource] (Firestore in production) with
/// a [AppUserLocalDataSource] (Hive in production) so that:
///
///   * sign-in populates `currentUser` synchronously from the local
///     cache when possible,
///   * remote writes are mirrored to the local cache for offline
///     reads,
///   * sign-in identity fields are back-filled into the persisted
///     doc without overwriting user-edited values.
class AppUserRepositoryImpl {
  AppUserRepositoryImpl({
    required AppUserRemoteDataSource remote,
    required AppUserLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final AppUserRemoteDataSource _remote;
  final AppUserLocalDataSource _local;
  final StreamController<AppUserEntity?> _controller =
      StreamController<AppUserEntity?>.broadcast();

  AppUserEntity? _currentUser;

  /// Currently signed-in user, or `null` after sign-out / before any
  /// sign-in.
  AppUserEntity? get currentUser => _currentUser;

  /// Stream of auth state changes for downstream subscribers (the
  /// app shell's auth provider, for example).
  Stream<AppUserEntity?> watch() => _controller.stream;

  /// Called by the auth feature after a successful sign-in. Fetches
  /// (or creates) the persistent user doc, back-fills any empty
  /// identity fields from the supplied [identity], mirrors to the
  /// local cache, and emits on the [watch] stream.
  Future<AppUserEntity> onSignedIn(
    String uid, {
    AuthIdentitySeed? identity,
  }) async {
    final AppUserModel remote =
        await _remote.fetchOrCreate(uid, identity: identity);
    await _local.write(remote);
    _currentUser = remote.toEntity();
    _controller.add(_currentUser);
    return _currentUser!;
  }

  /// Called by the auth feature after sign-out. Clears the local
  /// cache and emits `null` on the [watch] stream.
  void onSignedOut() {
    _currentUser = null;
    _local.clear();
    _controller.add(null);
  }

  /// Applies a progression / study-stats update. Writes both the
  /// remote and local caches in a single patch so they cannot drift
  /// apart across sign-ins.
  Future<AppUserEntity> applyProgression(AppUserEntity next) async {
    final AppUserModel patched =
        await _patchRemote(next.id, _progressionPatch(next));
    _currentUser = patched.toEntity();
    await _local.write(patched);
    _controller.add(_currentUser);
    return _currentUser!;
  }

  /// Convenience wrapper around [applyProgression] for the
  /// common "user finished a quiz" call site. Persists the new
  /// progression + study stats + completed-quizzes counter in a
  /// single remote patch.
  Future<AppUserEntity> recordQuizCompletion({
    required ProgressionEntity nextProgression,
    required StudyStatsEntity nextStudyStats,
    required int completedQuizzes,
  }) async {
    final AppUserEntity? base = _currentUser;
    if (base == null) {
      throw StateError('recordQuizCompletion called before onSignedIn');
    }
    final AppUserEntity next = base.copyWith(
      progression: nextProgression,
      studyStats: nextStudyStats,
      completedQuizzes: completedQuizzes,
    );
    return applyProgression(next);
  }

  /// Releases the underlying stream controller. Tests call this in
  /// `addTearDown` to avoid leaking listeners.
  Future<void> dispose() async {
    await _controller.close();
  }

  Future<AppUserModel> _patchRemote(
    String uid,
    Map<String, dynamic> patch,
  ) async {
    final AppUserRemoteDataSource remote = _remote;
    if (remote is FirestoreAppUserRemoteDataSource) {
      await remote.patch(uid, patch);
      final DocumentSnapshot<Map<String, dynamic>> snap = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(uid)
          .collection(FirestoreKeys.appUserSubcollection)
          .doc(FirestoreKeys.currentDocId)
          .get();
      return AppUserModel.fromMap(<String, dynamic>{
        'id': uid,
        ...?snap.data(),
      });
    }
    if (remote is MockAppUserRemoteDataSource) {
      await remote.patch(uid, patch);
      return remote.fetchOrCreate(uid);
    }
    // Generic fallback — call fetchOrCreate which is supported by every
    // implementation.
    await remote.patch(uid, patch);
    return remote.fetchOrCreate(uid);
  }

  Map<String, dynamic> _progressionPatch(AppUserEntity next) {
    return <String, dynamic>{
      'progression': <String, dynamic>{
        'totalXp': next.progression.totalXp,
        'level': next.progression.level,
        'xpInLevel': next.progression.xpInLevel,
        'xpForNextLevel': next.progression.xpForNextLevel,
        'coins': next.progression.coins,
        'energy': next.progression.energy,
        'maxEnergy': next.progression.maxEnergy,
        'energyRechargeSecondsRemaining':
            next.progression.energyRechargeSecondsRemaining,
        'rankId': next.progression.rank.id,
        'streakDays': next.progression.streakDays,
        'isStreakAtRisk': next.progression.isStreakAtRisk,
      },
      'studyStats': <String, dynamic>{
        'totalQuizzesTaken': next.studyStats.totalQuizzesTaken,
        'totalQuestionsAnswered': next.studyStats.totalQuestionsAnswered,
        'totalCorrectAnswers': next.studyStats.totalCorrectAnswers,
        'totalStudyMinutes': next.studyStats.totalStudyMinutes,
        'currentStreakDays': next.studyStats.currentStreakDays,
        'longestStreakDays': next.studyStats.longestStreakDays,
        'averageAccuracy': next.studyStats.averageAccuracy,
        'lastActiveAt': next.studyStats.lastActiveAt.toUtc().toIso8601String(),
      },
      'completedQuizzes': next.completedQuizzes,
    };
  }
}