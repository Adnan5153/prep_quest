import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../../core/constants/firestore_keys.dart';
import '../../../../core/services/level_curve.dart';
import '../../../../shared/enums/exam_track.dart';
import '../../domain/entities/user_profile.dart';
import '../models/user_profile_model.dart';
import 'profile_remote_datasource.dart';

/// Firestore-backed [ProfileRemoteDataSource].
///
/// Persists the user profile under `users/{uid}/profile/current` and
/// exposes a `watchProfile()` stream that mirrors realtime Firestore
/// snapshots. When the Firebase SDK is not configured the data source
/// throws `StateError` from its constructor — the Riverpod provider
/// falls back to the in-memory mock in that case.
class FirestoreProfileRemoteDataSource implements ProfileRemoteDataSource {
  FirestoreProfileRemoteDataSource({required String uid})
      : _uid = uid,
        _doc = FirebaseConfig.firestore!
            .collection(FirestoreKeys.users)
            .doc(uid)
            .collection(FirestoreKeys.profileSubcollection)
            .doc('current');

  final String _uid;
  final DocumentReference<Map<String, dynamic>> _doc;

  @override
  Future<UserProfileModel> fetchProfile() async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _doc.get();
    if (!snapshot.exists) {
      final UserProfileModel seed = _emptySeed();
      await _doc.set(seed.toMap(), SetOptions(merge: true));
      return seed;
    }
    return UserProfileModel.fromMap(<String, dynamic>{
      'id': _uid,
      ...?snapshot.data(),
    });
  }

  @override
  Stream<UserProfileModel> watchProfile() async* {
    yield await fetchProfile();
    yield* _doc.snapshots().map((DocumentSnapshot<Map<String, dynamic>> snap) {
      if (!snap.exists) return _emptySeed();
      return UserProfileModel.fromMap(<String, dynamic>{
        'id': _uid,
        ...?snap.data(),
      });
    });
  }

  @override
  Future<UserProfileModel> updateProfile({
    required String userId,
    required ProfileUpdateEntity update,
  }) async {
    final Map<String, dynamic> patch = <String, dynamic>{
      'displayName': update.displayName,
      'university': update.university,
      'examTrackId': update.examTrack.id,
      'languageId': update.language.id,
      'district': update.district,
      'bio': update.bio,
      'lastUpdatedAt': DateTime.now().toUtc().toIso8601String(),
    };
    await _doc.set(patch, SetOptions(merge: true));
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _doc.get();
    return UserProfileModel.fromMap(<String, dynamic>{
      'id': _uid,
      ...?snapshot.data(),
    });
  }

  @override
  Future<UserProfileModel> uploadAvatar({
    required String userId,
    required String imagePath,
  }) async {
    final Map<String, dynamic> patch = <String, dynamic>{
      'photoUrl': imagePath,
      'lastUpdatedAt': DateTime.now().toUtc().toIso8601String(),
    };
    await _doc.set(patch, SetOptions(merge: true));
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _doc.get();
    return UserProfileModel.fromMap(<String, dynamic>{
      'id': _uid,
      ...?snapshot.data(),
    });
  }

  @override
  Future<void> deleteProfile({required String userId}) async {
    await _doc.delete();
  }

  UserProfileModel _emptySeed() {
    final DateTime now = DateTime.now();
    return UserProfileModel(
      id: _uid,
      email: '',
      displayName: '',
      emailVerified: false,
      phoneNumber: '',
      university: '',
      examTrackId: ExamTrack.other.id,
      languageId: 'en',
      role: 'free',
      district: '',
      bio: '',
      photoUrl: '',
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
        lastActiveAt: now,
      ),
      achievements: const <AchievementModel>[],
      badges: const <BadgeModel>[],
      quickActions: const <String>[],
      createdAt: now,
      lastUpdatedAt: now,
    );
  }
}
