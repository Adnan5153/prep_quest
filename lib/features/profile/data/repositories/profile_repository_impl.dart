import 'dart:async';

// ignore_for_file: prefer_initializing_formals

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/security/auth_precondition.dart';
import '../../../../core/services/level_curve.dart';
import '../../../../shared/enums/exam_track.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_profile_model.dart';

/// Default repository implementation. Composes a remote source
/// (Firestore in production, mock in dev) with a local cache.
///
/// Phase 51 — every mutating method enforces an authenticated
/// precondition via [AuthGuard] before delegating to the remote data
/// source.
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remote,
    required ProfileLocalDataSource local,
    String activeUserId = 'demo-user',
    Ref? ref,
  })  : _remote = remote,
        _local = local,
        _activeUserId = activeUserId,
        _guard = ref == null ? null : AuthGuard(ref);

  final ProfileRemoteDataSource _remote;
  final ProfileLocalDataSource _local;
  final String _activeUserId;
  final AuthGuard? _guard;
  StreamSubscription<UserProfileModel>? _watchSubscription;

  @override
  Future<Result<UserProfile?>> readCachedProfile() async {
    try {
      final UserProfileModel? cached = await _local.read();
      return Result.success(cached?.toEntity());
    } catch (error) {
      return Result.failure(
        CacheFailure('Could not read cached profile: $error'),
      );
    }
  }

  @override
  Future<Result<UserProfile>> fetchProfile() async {
    try {
      final UserProfileModel model = await _remote.fetchProfile();
      await _local.write(model);
      return Result.success(model.toEntity());
    } catch (error) {
      return Result.failure(
        ServerFailure('Could not load your profile right now.'),
      );
    }
  }

  @override
  Stream<UserProfile> watchProfile() {
    final StreamController<UserProfile> controller =
        StreamController<UserProfile>.broadcast();
    controller.add(_emptyProfile());
    _watchSubscription?.cancel();
    _watchSubscription = _remote
        .watchProfile()
        .listen((UserProfileModel model) {
      _local.write(model);
      controller.add(model.toEntity());
    }, onError: (Object error) {
      controller.addError(
        ServerFailure('Profile stream disconnected.'),
      );
    });
    controller.onCancel = () => _watchSubscription?.cancel();
    return controller.stream;
  }

  @override
  Future<Result<UserProfile>> updateProfile(ProfileUpdateEntity update) async {
    try {
      _guard?.assertAuthenticated();
      final UserProfileModel model = await _remote.updateProfile(
        userId: _activeUserId,
        update: update,
      );
      await _local.write(model);
      return Result.success(model.toEntity());
    } catch (error) {
      return Result.failure(
        ServerFailure('Could not save your changes.'),
      );
    }
  }

  @override
  Future<Result<UserProfile>> uploadAvatar({required String imagePath}) async {
    try {
      _guard?.assertAuthenticated();
      final UserProfileModel model = await _remote.uploadAvatar(
        userId: _activeUserId,
        imagePath: imagePath,
      );
      await _local.write(model);
      return Result.success(model.toEntity());
    } catch (error) {
      return Result.failure(
        ServerFailure('Avatar upload failed. Please try again.'),
      );
    }
  }

  @override
  Future<Result<void>> deleteAccount() async {
    try {
      _guard?.assertAuthenticated();
      await _remote.deleteProfile(userId: _activeUserId);
      await _local.clear();
      return Result.success(null);
    } catch (error) {
      return Result.failure(
        ServerFailure('Could not delete account.'),
      );
    }
  }

  @override
  Future<Result<void>> clearCache() async {
    try {
      await _local.clear();
      return Result.success(null);
    } catch (error) {
      return Result.failure(
        CacheFailure('Could not clear cache.'),
      );
    }
  }

  Future<void> dispose() async {
    await _watchSubscription?.cancel();
  }

  UserProfile _emptyProfile() {
    final DateTime now = DateTime.now();
    return UserProfile(
      id: _activeUserId,
      email: '',
      displayName: '',
      emailVerified: false,
      phoneNumber: '',
      university: '',
      examTrack: ExamTrack.other,
      language: ProfileLanguage.english,
      role: 'free',
      district: '',
      bio: '',
      photoUrl: '',
      progression: ProgressionEntity(
        totalXp: 0,
        level: 1,
        xpInLevel: 0,
        xpForNextLevel: LevelCurve.defaultCurve.xpRequiredForLevel(1),
        coins: 0,
        energy: 5,
        maxEnergy: 5,
        energyRechargeSecondsRemaining: 0,
        rank: ProfileRank.bronze,
        streakDays: 0,
        isStreakAtRisk: false,
        previousLevelThreshold: 0,
        nextLevelThreshold: LevelCurve.defaultCurve.xpRequiredForLevel(1),
        totalLevelUpsCompleted: 0,
        lastLevelUpAt: null,
        pendingLevelRewards: const <PendingLevelReward>[],
      ),
      studyStats: StudyStatsEntity(
        totalQuizzesTaken: 0,
        totalQuestionsAnswered: 0,
        totalCorrectAnswers: 0,
        totalStudyMinutes: 0,
        currentStreakDays: 0,
        longestStreakDays: 0,
        averageAccuracy: 0,
        lastActiveAt: now,
      ),
      achievements: const <AchievementEntity>[],
      badges: const <BadgeEntity>[],
      quickActions: const <String>[],
      createdAt: now,
      lastUpdatedAt: now,
    );
  }
}
