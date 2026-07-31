import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../../core/constants/firestore_keys.dart';
import '../../../../core/services/level_curve.dart';
import '../../../../shared/enums/exam_track.dart';
import '../../../../shared/enums/user_role.dart';
import '../../../profile/data/models/user_profile_model.dart';
import '../../domain/entities/auth_identity_seed.dart';
import '../models/app_user_model.dart';
import 'app_user_remote_datasource.dart';

/// Firestore-backed [AppUserRemoteDataSource].
///
/// Persists the canonical app-user document at
/// `users/{uid}/app_user/current` and exposes a
/// `Stream<AppUserModel>` watch for realtime updates.
class FirestoreAppUserRemoteDataSource implements AppUserRemoteDataSource {
  FirestoreAppUserRemoteDataSource({required String uid})
      : _uid = uid,
        _doc = FirebaseConfig.firestore!
            .collection(FirestoreKeys.users)
            .doc(uid)
            .collection(FirestoreKeys.appUserSubcollection)
            .doc(FirestoreKeys.currentDocId);

  final String _uid;
  final DocumentReference<Map<String, dynamic>> _doc;

  @override
  Future<AppUserModel> fetchOrCreate(
    String uid, {
    AuthIdentitySeed? identity,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _doc.get();
    if (!snapshot.exists) {
      final AppUserModel fresh = AppUserModel(
        id: uid,
        displayName: identity?.displayName ?? '',
        email: identity?.email ?? '',
        emailVerified: identity?.emailVerified ?? false,
        phoneNumber: identity?.phoneNumber ?? '',
        examTrackId: ExamTrack.other.id,
        roleId: UserRole.free.id,
        district: '',
        photoUrl: identity?.photoUrl ?? '',
        createdAt: identity?.createdAt ?? DateTime.now(),
        lastSignInAt: DateTime.now(),
        progression: ProgressionModel(
          totalXp: 0,
          level: 1,
          xpInLevel: 0,
          xpForNextLevel: LevelCurve.defaultCurve.xpRequiredForLevel(1),
          coins: 0,
          energy: 5,
          maxEnergy: 5,
          energyRechargeSecondsRemaining: 0,
          rankId: 'bronze',
          streakDays: 0,
          isStreakAtRisk: false,
        ),
        studyStats: StudyStatsModel(
          totalQuizzesTaken: 0,
          totalQuestionsAnswered: 0,
          totalCorrectAnswers: 0,
          totalStudyMinutes: 0,
          currentStreakDays: 0,
          longestStreakDays: 0,
          averageAccuracy: 0,
          lastActiveAt: DateTime.now(),
        ),
        quickActions: const <String>['resume', 'mock_test', 'leaderboard'],
      );
      await _doc.set(fresh.toMap(), SetOptions(merge: true));
      return fresh;
    }
    return AppUserModel.fromMap(<String, dynamic>{
      'id': _uid,
      ...?snapshot.data(),
    });
  }

  @override
  Future<void> patch(String uid, Map<String, dynamic> fields) async {
    await _doc.set(fields, SetOptions(merge: true));
  }

  @override
  Future<void> delete(String uid) async {
    await _doc.delete();
  }
}
