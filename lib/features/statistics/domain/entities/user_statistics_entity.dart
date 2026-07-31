import 'package:flutter/foundation.dart';

/// Per-user, per-category statistics snapshot.
///
/// One document lives at `users/{uid}/category_statistics/{categoryId}`
/// and accumulates the lifetime performance of every session that
/// finished in [categoryId]. Counters are monotonic non-decreasing
/// on the server; `bestScore` is `max(prev, attempt.score)` — never
/// overwritten with a lower score. `averageSecondsPerQuestion` is an
/// exponentially-weighted moving average (`alpha = 0.2`) so recent
/// attempts dominate.
@immutable
class CategoryStatisticsEntity {
  const CategoryStatisticsEntity({
    required this.uid,
    required this.categoryId,
    required this.subjectName,
    required this.totalQuestions,
    required this.correct,
    required this.wrong,
    required this.skipped,
    required this.bestScore,
    required this.averageSecondsPerQuestion,
    required this.totalMinutes,
    required this.xpEarned,
    required this.lastSessionIds,
    required this.lastUpdatedAtIso,
  });

  /// Authenticated user this row belongs to. Empty for offline.
  final String uid;

  /// Category (subject) id — matches `categoryId` on the quiz
  /// session.
  final String categoryId;

  /// Display name resolved at write time so the statistics screen
  /// has a stable label even if the catalog renames the subject.
  final String subjectName;

  /// Lifetime total questions answered in this category.
  final int totalQuestions;

  /// Lifetime correct answers.
  final int correct;

  /// Lifetime wrong answers (= incorrect + skipped counts that
  /// failed the validator).
  final int wrong;

  /// Lifetime skipped answers.
  final int skipped;

  /// Highest score (0-100) the user has ever achieved in this
  /// category. Monotonic non-decreasing.
  final int bestScore;

  /// EMA of seconds-per-question across attempts in this category.
  final double averageSecondsPerQuestion;

  /// Cumulative study minutes spent in this category.
  final int totalMinutes;

  /// Cumulative XP earned from this category.
  final int xpEarned;

  /// Last 50 quiz session ids that contributed to this row. Used
  /// both as a dedup key (replays of the same sessionId are absorbed)
  /// and as a forensic trail.
  final List<String> lastSessionIds;

  /// ISO-8601 UTC timestamp of the last mutation.
  final String? lastUpdatedAtIso;

  int get accuracyPercent =>
      totalQuestions == 0 ? 0 : ((correct / totalQuestions) * 100).round();

  bool get isPriority => totalQuestions >= 5 && accuracyPercent < 60;

  /// Empty mirror used by the in-memory datasource and the offline
  /// fallback. The `categoryId` is `''` because the canonical
  /// lookup-by-id path always provides the real id.
  static const CategoryStatisticsEntity empty = CategoryStatisticsEntity(
    uid: '',
    categoryId: '',
    subjectName: '',
    totalQuestions: 0,
    correct: 0,
    wrong: 0,
    skipped: 0,
    bestScore: 0,
    averageSecondsPerQuestion: 0,
    totalMinutes: 0,
    xpEarned: 0,
    lastSessionIds: <String>[],
    lastUpdatedAtIso: null,
  );

  CategoryStatisticsEntity copyWith({
    String? uid,
    String? categoryId,
    String? subjectName,
    int? totalQuestions,
    int? correct,
    int? wrong,
    int? skipped,
    int? bestScore,
    double? averageSecondsPerQuestion,
    int? totalMinutes,
    int? xpEarned,
    List<String>? lastSessionIds,
    String? lastUpdatedAtIso,
  }) {
    return CategoryStatisticsEntity(
      uid: uid ?? this.uid,
      categoryId: categoryId ?? this.categoryId,
      subjectName: subjectName ?? this.subjectName,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correct: correct ?? this.correct,
      wrong: wrong ?? this.wrong,
      skipped: skipped ?? this.skipped,
      bestScore: bestScore ?? this.bestScore,
      averageSecondsPerQuestion:
          averageSecondsPerQuestion ?? this.averageSecondsPerQuestion,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      xpEarned: xpEarned ?? this.xpEarned,
      lastSessionIds: lastSessionIds ?? this.lastSessionIds,
      lastUpdatedAtIso: lastUpdatedAtIso ?? this.lastUpdatedAtIso,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'categoryId': categoryId,
      'subjectName': subjectName,
      'totalQuestions': totalQuestions,
      'correct': correct,
      'wrong': wrong,
      'skipped': skipped,
      'bestScore': bestScore,
      'averageSecondsPerQuestion': averageSecondsPerQuestion,
      'totalMinutes': totalMinutes,
      'xpEarned': xpEarned,
      'lastSessionIds': List<String>.from(lastSessionIds, growable: false),
      'lastUpdatedAtIso': lastUpdatedAtIso,
    };
  }

  static CategoryStatisticsEntity fromMap(Map<String, dynamic> map) {
    final List<String> sessions = (map['lastSessionIds'] as List<dynamic>?)
            ?.map((dynamic entry) => entry?.toString() ?? '')
            .where((String entry) => entry.isNotEmpty)
            .toList(growable: false) ??
        const <String>[];
    return CategoryStatisticsEntity(
      uid: (map['uid'] as String?) ?? '',
      categoryId: (map['categoryId'] as String?) ?? '',
      subjectName: (map['subjectName'] as String?) ?? '',
      totalQuestions: (map['totalQuestions'] as num?)?.toInt() ?? 0,
      correct: (map['correct'] as num?)?.toInt() ?? 0,
      wrong: (map['wrong'] as num?)?.toInt() ?? 0,
      skipped: (map['skipped'] as num?)?.toInt() ?? 0,
      bestScore: (map['bestScore'] as num?)?.toInt() ?? 0,
      averageSecondsPerQuestion:
          (map['averageSecondsPerQuestion'] as num?)?.toDouble() ?? 0.0,
      totalMinutes: (map['totalMinutes'] as num?)?.toInt() ?? 0,
      xpEarned: (map['xpEarned'] as num?)?.toInt() ?? 0,
      lastSessionIds: sessions,
      lastUpdatedAtIso: map['lastUpdatedAtIso'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CategoryStatisticsEntity) return false;
    return uid == other.uid &&
        categoryId == other.categoryId &&
        subjectName == other.subjectName &&
        totalQuestions == other.totalQuestions &&
        correct == other.correct &&
        wrong == other.wrong &&
        skipped == other.skipped &&
        bestScore == other.bestScore &&
        averageSecondsPerQuestion == other.averageSecondsPerQuestion &&
        totalMinutes == other.totalMinutes &&
        xpEarned == other.xpEarned &&
        lastUpdatedAtIso == other.lastUpdatedAtIso &&
        _listEquals(lastSessionIds, other.lastSessionIds);
  }

  @override
  int get hashCode => Object.hash(
        uid,
        categoryId,
        subjectName,
        totalQuestions,
        correct,
        wrong,
        skipped,
        bestScore,
        averageSecondsPerQuestion,
        totalMinutes,
        xpEarned,
        lastUpdatedAtIso,
        Object.hashAll(lastSessionIds),
      );

  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Aggregate per-user statistics.
///
/// One document lives at `users/{uid}/statistics/current`. Lives in
/// parallel to `UserProfile.progression` and `studyStats` — the
/// standalone collection exists so the statistics screen can be
/// served by a single query, and so future Cloud Functions can
/// schedule rollups without re-deriving from the profile.
@immutable
class UserStatisticsEntity {
  const UserStatisticsEntity({
    required this.uid,
    required this.totalAnswered,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.accuracy,
    required this.averageTimeSecondsPerQuestion,
    required this.totalStudyMinutes,
    required this.totalXp,
    required this.totalCoins,
    required this.lastSessionIds,
    required this.lastUpdatedAtIso,
  });

  /// Authenticated user id. Empty for guests / offline.
  final String uid;

  /// Lifetime total questions answered.
  final int totalAnswered;

  /// Lifetime correct answers.
  final int correctAnswers;

  /// Lifetime wrong answers (includes `skipped` so the math
  /// `correct + wrong == totalAnswered` always holds).
  final int wrongAnswers;

  /// 0-100 accuracy percentage.
  final double accuracy;

  /// EMA of seconds-per-question across every quiz session.
  final double averageTimeSecondsPerQuestion;

  /// Cumulative study minutes across all sessions.
  final int totalStudyMinutes;

  /// Cumulative XP earned across all sessions.
  final int totalXp;

  /// Cumulative coins earned across all sessions.
  final int totalCoins;

  /// Last 50 quiz session ids that contributed to this row. Used
  /// as dedup key + audit trail.
  final List<String> lastSessionIds;

  /// ISO-8601 UTC timestamp of the last mutation.
  final String? lastUpdatedAtIso;

  int get accuracyPercent => accuracy.round();

  bool get isEmpty => totalAnswered == 0 && totalXp == 0;

  static const UserStatisticsEntity empty = UserStatisticsEntity(
    uid: '',
    totalAnswered: 0,
    correctAnswers: 0,
    wrongAnswers: 0,
    accuracy: 0,
    averageTimeSecondsPerQuestion: 0,
    totalStudyMinutes: 0,
    totalXp: 0,
    totalCoins: 0,
    lastSessionIds: <String>[],
    lastUpdatedAtIso: null,
  );

  UserStatisticsEntity copyWith({
    String? uid,
    int? totalAnswered,
    int? correctAnswers,
    int? wrongAnswers,
    double? accuracy,
    double? averageTimeSecondsPerQuestion,
    int? totalStudyMinutes,
    int? totalXp,
    int? totalCoins,
    List<String>? lastSessionIds,
    String? lastUpdatedAtIso,
  }) {
    return UserStatisticsEntity(
      uid: uid ?? this.uid,
      totalAnswered: totalAnswered ?? this.totalAnswered,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      accuracy: accuracy ?? this.accuracy,
      averageTimeSecondsPerQuestion:
          averageTimeSecondsPerQuestion ?? this.averageTimeSecondsPerQuestion,
      totalStudyMinutes: totalStudyMinutes ?? this.totalStudyMinutes,
      totalXp: totalXp ?? this.totalXp,
      totalCoins: totalCoins ?? this.totalCoins,
      lastSessionIds: lastSessionIds ?? this.lastSessionIds,
      lastUpdatedAtIso: lastUpdatedAtIso ?? this.lastUpdatedAtIso,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'totalAnswered': totalAnswered,
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'accuracy': accuracy,
      'averageTimeSecondsPerQuestion': averageTimeSecondsPerQuestion,
      'totalStudyMinutes': totalStudyMinutes,
      'totalXp': totalXp,
      'totalCoins': totalCoins,
      'lastSessionIds': List<String>.from(lastSessionIds, growable: false),
      'lastUpdatedAtIso': lastUpdatedAtIso,
    };
  }

  static UserStatisticsEntity fromMap(Map<String, dynamic> map) {
    final List<String> sessions = (map['lastSessionIds'] as List<dynamic>?)
            ?.map((dynamic entry) => entry?.toString() ?? '')
            .where((String entry) => entry.isNotEmpty)
            .toList(growable: false) ??
        const <String>[];
    return UserStatisticsEntity(
      uid: (map['uid'] as String?) ?? '',
      totalAnswered: (map['totalAnswered'] as num?)?.toInt() ?? 0,
      correctAnswers: (map['correctAnswers'] as num?)?.toInt() ?? 0,
      wrongAnswers: (map['wrongAnswers'] as num?)?.toInt() ?? 0,
      accuracy: (map['accuracy'] as num?)?.toDouble() ?? 0.0,
      averageTimeSecondsPerQuestion:
          (map['averageTimeSecondsPerQuestion'] as num?)?.toDouble() ?? 0.0,
      totalStudyMinutes: (map['totalStudyMinutes'] as num?)?.toInt() ?? 0,
      totalXp: (map['totalXp'] as num?)?.toInt() ?? 0,
      totalCoins: (map['totalCoins'] as num?)?.toInt() ?? 0,
      lastSessionIds: sessions,
      lastUpdatedAtIso: map['lastUpdatedAtIso'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserStatisticsEntity) return false;
    return uid == other.uid &&
        totalAnswered == other.totalAnswered &&
        correctAnswers == other.correctAnswers &&
        wrongAnswers == other.wrongAnswers &&
        accuracy == other.accuracy &&
        averageTimeSecondsPerQuestion == other.averageTimeSecondsPerQuestion &&
        totalStudyMinutes == other.totalStudyMinutes &&
        totalXp == other.totalXp &&
        totalCoins == other.totalCoins &&
        lastUpdatedAtIso == other.lastUpdatedAtIso &&
        _listEquals(lastSessionIds, other.lastSessionIds);
  }

  @override
  int get hashCode => Object.hash(
        uid,
        totalAnswered,
        correctAnswers,
        wrongAnswers,
        accuracy,
        averageTimeSecondsPerQuestion,
        totalStudyMinutes,
        totalXp,
        totalCoins,
        lastUpdatedAtIso,
        Object.hashAll(lastSessionIds),
      );

  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
