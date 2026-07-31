import '../../../../core/services/level_curve.dart';
import '../../../../shared/enums/exam_track.dart';
import '../../../../shared/enums/user_role.dart';
import '../../../profile/data/models/user_profile_model.dart';
import '../../domain/entities/auth_identity_seed.dart';
import '../models/app_user_model.dart';
import 'app_user_remote_datasource.dart';

/// In-memory [AppUserRemoteDataSource] used during development and
/// tests. Mirrors the Firestore API surface (fetch-or-create with
/// identity back-fill + partial patch) so the production swap can
/// happen without touching call sites.
class MockAppUserRemoteDataSource implements AppUserRemoteDataSource {
  MockAppUserRemoteDataSource({Duration? latency})
      : _latency = latency ?? const Duration(milliseconds: 220);

  final Duration _latency;
  final Map<String, AppUserModel> _byId = <String, AppUserModel>{};

  @override
  Future<AppUserModel> fetchOrCreate(
    String uid, {
    AuthIdentitySeed? identity,
  }) async {
    await Future<void>.delayed(_latency);
    final AppUserModel? existing = _byId[uid];
    if (existing == null) {
      final DateTime now = DateTime.now();
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
        createdAt: identity?.createdAt ?? now,
        lastSignInAt: now,
        progression: _emptyProgression(),
        studyStats: _emptyStudyStats(),
        quickActions: List<String>.unmodifiable(<String>[
          'resume',
          'mock_test',
          'leaderboard',
        ]),
      );
      _byId[uid] = fresh;
      return fresh;
    }

    // Back-fill empty identity fields without overwriting user-edited
    // values.
    final AppUserModel patched = _backfillIdentity(existing, identity);
    _byId[uid] = patched;
    return patched;
  }

  @override
  Future<void> patch(String uid, Map<String, dynamic> fields) async {
    await Future<void>.delayed(_latency);
    final AppUserModel? existing = _byId[uid];
    if (existing == null) return;
    _byId[uid] = _applyPatch(existing, fields);
  }

  @override
  Future<void> delete(String uid) async {
    await Future<void>.delayed(_latency);
    _byId.remove(uid);
  }

  /// Resets the in-memory store. Tests use this between cases.
  void reset() {
    _byId.clear();
  }

  AppUserModel _backfillIdentity(
    AppUserModel existing,
    AuthIdentitySeed? identity,
  ) {
    if (identity == null) return existing;
    return existing.copyWith(
      displayName:
          existing.displayName.isEmpty ? identity.displayName : null,
      email: existing.email.isEmpty ? identity.email : null,
      emailVerified:
          existing.email.isEmpty ? identity.emailVerified : null,
      phoneNumber:
          existing.phoneNumber.isEmpty ? identity.phoneNumber : null,
      photoUrl: existing.photoUrl.isEmpty ? identity.photoUrl : null,
      createdAt: identity.createdAt ?? existing.createdAt,
    );
  }

  AppUserModel _applyPatch(
    AppUserModel existing,
    Map<String, dynamic> fields,
  ) {
    AppUserModel result = existing;
    final String? displayName = fields['displayName'] as String?;
    if (displayName != null) result = result.copyWith(displayName: displayName);
    final String? email = fields['email'] as String?;
    if (email != null) result = result.copyWith(email: email);
    final String? phoneNumber = fields['phoneNumber'] as String?;
    if (phoneNumber != null) result = result.copyWith(phoneNumber: phoneNumber);
    final String? photoUrl = fields['photoUrl'] as String?;
    if (photoUrl != null) result = result.copyWith(photoUrl: photoUrl);
    final String? district = fields['district'] as String?;
    if (district != null) result = result.copyWith(district: district);
    final String? examTrackId = fields['examTrackId'] as String?;
    if (examTrackId != null) result = result.copyWith(examTrackId: examTrackId);
    final String? roleId = fields['roleId'] as String?;
    if (roleId != null) result = result.copyWith(roleId: roleId);
    final bool? emailVerified = fields['emailVerified'] as bool?;
    if (emailVerified != null) {
      result = result.copyWith(emailVerified: emailVerified);
    }
    final Map<String, dynamic>? progression =
        fields['progression'] as Map<String, dynamic>?;
    if (progression != null) {
      result = result.copyWith(
        progression: _mergeProgression(result.progression, progression),
      );
    }
    final Map<String, dynamic>? studyStats =
        fields['studyStats'] as Map<String, dynamic>?;
    if (studyStats != null) {
      result = result.copyWith(
        studyStats: _mergeStudyStats(result.studyStats, studyStats),
      );
    }
    final int? completedQuizzes =
        (fields['completedQuizzes'] as num?)?.toInt();
    if (completedQuizzes != null) {
      result = result.copyWith(completedQuizzes: completedQuizzes);
    }
    final List<String>? quickActions = (fields['quickActions'] as List?)
        ?.whereType<String>()
        .toList(growable: false);
    if (quickActions != null) {
      result = result.copyWith(quickActions: quickActions);
    }
    return result;
  }
}

ProgressionModel _emptyProgression() {
  return ProgressionModel(
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
  );
}

StudyStatsModel _emptyStudyStats() {
  return StudyStatsModel(
    totalQuizzesTaken: 0,
    totalQuestionsAnswered: 0,
    totalCorrectAnswers: 0,
    totalStudyMinutes: 0,
    currentStreakDays: 0,
    longestStreakDays: 0,
    averageAccuracy: 0,
    lastActiveAt: DateTime.now(),
  );
}

ProgressionModel _mergeProgression(
  ProgressionModel existing,
  Map<String, dynamic> patch,
) {
  return ProgressionModel(
    totalXp: (patch['totalXp'] as num?)?.toInt() ?? existing.totalXp,
    level: (patch['level'] as num?)?.toInt() ?? existing.level,
    xpInLevel: (patch['xpInLevel'] as num?)?.toInt() ?? existing.xpInLevel,
    xpForNextLevel:
        (patch['xpForNextLevel'] as num?)?.toInt() ?? existing.xpForNextLevel,
    coins: (patch['coins'] as num?)?.toInt() ?? existing.coins,
    energy: (patch['energy'] as num?)?.toInt() ?? existing.energy,
    maxEnergy: (patch['maxEnergy'] as num?)?.toInt() ?? existing.maxEnergy,
    energyRechargeSecondsRemaining:
        (patch['energyRechargeSecondsRemaining'] as num?)?.toInt() ??
            existing.energyRechargeSecondsRemaining,
    rankId: (patch['rankId'] as String?) ?? existing.rankId,
    streakDays: (patch['streakDays'] as num?)?.toInt() ?? existing.streakDays,
    isStreakAtRisk:
        (patch['isStreakAtRisk'] as bool?) ?? existing.isStreakAtRisk,
  );
}

StudyStatsModel _mergeStudyStats(
  StudyStatsModel existing,
  Map<String, dynamic> patch,
) {
  return StudyStatsModel(
    totalQuizzesTaken:
        (patch['totalQuizzesTaken'] as num?)?.toInt() ??
            existing.totalQuizzesTaken,
    totalQuestionsAnswered:
        (patch['totalQuestionsAnswered'] as num?)?.toInt() ??
            existing.totalQuestionsAnswered,
    totalCorrectAnswers:
        (patch['totalCorrectAnswers'] as num?)?.toInt() ??
            existing.totalCorrectAnswers,
    totalStudyMinutes:
        (patch['totalStudyMinutes'] as num?)?.toInt() ??
            existing.totalStudyMinutes,
    currentStreakDays:
        (patch['currentStreakDays'] as num?)?.toInt() ??
            existing.currentStreakDays,
    longestStreakDays:
        (patch['longestStreakDays'] as num?)?.toInt() ??
            existing.longestStreakDays,
    averageAccuracy:
        (patch['averageAccuracy'] as num?)?.toDouble() ??
            existing.averageAccuracy,
    lastActiveAt: DateTime.tryParse(patch['lastActiveAt'] as String? ?? '') ??
        existing.lastActiveAt,
  );
}