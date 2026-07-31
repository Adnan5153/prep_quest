import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../../core/constants/firestore_keys.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../domain/entities/statistics_entity.dart';
import '../../domain/entities/study_statistics_entity.dart';
import '../../domain/entities/subject_statistics_entity.dart';
import 'statistics_remote_datasource.dart';

/// Live, profile-driven statistics data source.
///
/// Materializes a complete [StatisticsEntity] from the authenticated
/// user's Firestore documents:
///
/// * `users/{uid}/profile/current` — for display name, level, study
///   minutes, etc.
/// * `users/{uid}/study_stats/current` — for accuracy, totals, streak.
/// * `users/{uid}/category_progress/{categoryId}` — for the per-subject
///   accuracy breakdown (one subject ≈ one category).
///
/// Falls back to [StatisticsEntity.isEmpty] when the user is not signed
/// in or Firestore is not configured so the UI can render the empty
/// state without crashing.
class ProfileDrivenStatisticsRemoteDataSource
    implements StatisticsRemoteDataSource {
  const ProfileDrivenStatisticsRemoteDataSource({
    required this.activeUserId,
    required this.profile,
  });

  final String activeUserId;
  final UserProfile? profile;

  @override
  Future<StatisticsEntity> fetchStatistics() async {
    final UserProfile? profile = this.profile;
    if (profile == null || activeUserId.isEmpty) {
      return _empty();
    }
    if (!FirebaseConfig.isPlatformConfigured) {
      return _fromProfile(profile, const <_SubjectSnapshot>[]);
    }
    final FirebaseFirestore? firestore = FirebaseConfig.firestore;
    if (firestore == null) {
      return _fromProfile(profile, const <_SubjectSnapshot>[]);
    }
    final List<_SubjectSnapshot> snapshots = await _loadCategoryProgress(
      firestore,
      activeUserId,
    );
    return _fromProfile(profile, snapshots);
  }

  Future<List<_SubjectSnapshot>> _loadCategoryProgress(
    FirebaseFirestore firestore,
    String uid,
  ) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection(FirestoreKeys.users)
          .doc(uid)
          .collection(FirestoreKeys.categoryProgressSubcollection)
          .get();
      return snapshot.docs.map(_SubjectSnapshot.fromDoc).toList(growable: false);
    } catch (_) {
      return const <_SubjectSnapshot>[];
    }
  }

  StatisticsEntity _fromProfile(
    UserProfile profile,
    List<_SubjectSnapshot> categorySnapshots,
  ) {
    final StudyStatsEntity stats = profile.studyStats;
    final ProgressionEntity prog = profile.progression;

    final int totalQuestions = stats.totalQuestionsAnswered;
    final int totalCorrect = stats.totalCorrectAnswers;
    final int totalIncorrect =
        (totalQuestions - totalCorrect).clamp(0, 1 << 20);
    final int totalSkipped = 0;

    final List<SubjectStatisticsEntity> subjectBreakdown =
        _buildSubjectBreakdown(categorySnapshots, totalCorrect, totalQuestions);
    final List<SubjectStatisticsEntity> weakSubjects = subjectBreakdown
        .where((SubjectStatisticsEntity s) => s.accuracyPercent < 60)
        .toList(growable: false);
    final List<SubjectStatisticsEntity> strongSubjects = subjectBreakdown
        .where((SubjectStatisticsEntity s) => s.accuracyPercent >= 75)
        .toList(growable: false);

    return StatisticsEntity(
      totalXp: prog.totalXp,
      todayXp: 0,
      weeklyXp: prog.totalXp,
      monthlyXp: prog.totalXp,
      currentLevel: prog.level,
      currentXpIntoLevel: prog.xpInLevel,
      nextLevelXp: prog.xpForNextLevel,
      overallAccuracyPercent: (stats.averageAccuracy * 100).round(),
      totalQuestions: totalQuestions,
      totalCorrect: totalCorrect,
      totalIncorrect: totalIncorrect,
      totalSkipped: totalSkipped,
      streakDays: prog.streakDays,
      study: StudyStatisticsEntity(
        todayMinutes: stats.totalStudyMinutes,
        weeklyMinutes: stats.totalStudyMinutes,
        monthlyMinutes: stats.totalStudyMinutes,
        averageDailyMinutes: stats.totalStudyMinutes,
        streakDays: prog.streakDays,
        longestStreak: stats.longestStreakDays,
      ),
      subjectBreakdown: subjectBreakdown,
      xpGrowth: const <XpGrowthPoint>[],
      dailyAccuracy: const <AccuracyPoint>[],
      weeklyAccuracy: const <AccuracyPoint>[],
      studyHeatmap: const <HeatmapCell>[],
      weeklyActivity: const <ActivityPoint>[],
      monthlyActivity: const <ActivityPoint>[],
      weakSubjects: weakSubjects,
      strongSubjects: strongSubjects,
    );
  }

  List<SubjectStatisticsEntity> _buildSubjectBreakdown(
    List<_SubjectSnapshot> snapshots,
    int totalCorrect,
    int totalQuestions,
  ) {
    if (snapshots.isEmpty) return const <SubjectStatisticsEntity>[];
    return snapshots
        .map(
          (_SubjectSnapshot s) => SubjectStatisticsEntity(
            subjectId: s.subjectId,
            subjectName: s.subjectName,
            totalQuestions: s.totalQuestions,
            correct: s.correct,
            incorrect: s.incorrect,
            skipped: 0,
            accuracyPercent: s.accuracyPercent,
            averageSecondsPerQuestion: 0,
            totalMinutes: s.totalMinutes,
            xpEarned: s.xpEarned,
            weakestTopicId: null,
            weakestTopicName: null,
            weakestTopicAccuracy: null,
            isPriority: s.accuracyPercent < 60,
            achievementBadgeId: null,
          ),
        )
        .toList(growable: false);
  }

  StatisticsEntity _empty() {
    return const StatisticsEntity(
      totalXp: 0,
      todayXp: 0,
      weeklyXp: 0,
      monthlyXp: 0,
      currentLevel: 1,
      currentXpIntoLevel: 0,
      nextLevelXp: 100,
      overallAccuracyPercent: 0,
      totalQuestions: 0,
      totalCorrect: 0,
      totalIncorrect: 0,
      totalSkipped: 0,
      streakDays: 0,
      study: StudyStatisticsEntity.empty,
      subjectBreakdown: <SubjectStatisticsEntity>[],
      xpGrowth: <XpGrowthPoint>[],
      dailyAccuracy: <AccuracyPoint>[],
      weeklyAccuracy: <AccuracyPoint>[],
      studyHeatmap: <HeatmapCell>[],
      weeklyActivity: <ActivityPoint>[],
      monthlyActivity: <ActivityPoint>[],
      weakSubjects: <SubjectStatisticsEntity>[],
      strongSubjects: <SubjectStatisticsEntity>[],
    );
  }
}

class _SubjectSnapshot {
  const _SubjectSnapshot({
    required this.subjectId,
    required this.subjectName,
    required this.totalQuestions,
    required this.correct,
    required this.incorrect,
    required this.accuracyPercent,
    required this.totalMinutes,
    required this.xpEarned,
  });

  factory _SubjectSnapshot.fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final Map<String, dynamic> data = doc.data();
    final int total = (data['totalQuestions'] as num?)?.toInt() ?? 0;
    final int correct = (data['correct'] as num?)?.toInt() ?? 0;
    final int incorrect = (data['incorrect'] as num?)?.toInt() ??
        (total - correct).clamp(0, 1 << 20);
    final int accuracy =
        total == 0 ? 0 : ((correct / total) * 100).round();
    return _SubjectSnapshot(
      subjectId: (data['subjectId'] as String?) ?? doc.id,
      subjectName: (data['subjectName'] as String?) ??
          (data['title'] as String?) ??
          doc.id,
      totalQuestions: total,
      correct: correct,
      incorrect: incorrect,
      accuracyPercent: accuracy,
      totalMinutes: (data['totalMinutes'] as num?)?.toInt() ?? 0,
      xpEarned: (data['xpEarned'] as num?)?.toInt() ?? 0,
    );
  }

  final String subjectId;
  final String subjectName;
  final int totalQuestions;
  final int correct;
  final int incorrect;
  final int accuracyPercent;
  final int totalMinutes;
  final int xpEarned;
}