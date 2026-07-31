import '../../../../shared/typedefs/result.dart';
import '../entities/statistics_entity.dart';
import '../entities/study_statistics_entity.dart';
import '../entities/subject_statistics_entity.dart';
import '../entities/user_statistics_entity.dart';

/// Bundle returned by [StatisticsRepository.watch].
class StatisticsSnapshot {
  const StatisticsSnapshot({
    required this.user,
    required this.categories,
  });

  /// Global aggregates. Always non-null (empty fallback for guests).
  final UserStatisticsEntity user;

  /// Per-category breakdown. Empty for users with no quiz history.
  final List<CategoryStatisticsEntity> categories;

  CategoryStatisticsEntity? category(String id) {
    for (final CategoryStatisticsEntity c in categories) {
      if (c.categoryId == id) return c;
    }
    return null;
  }

  static const StatisticsSnapshot empty = StatisticsSnapshot(
    user: UserStatisticsEntity.empty,
    categories: <CategoryStatisticsEntity>[],
  );
}

abstract class StatisticsRepository {
  // Legacy one-shot API — preserved so every existing use case still
  // compiles. The implementation routes through the realtime
  // snapshot.
  Future<Result<StatisticsEntity>> getStatistics();
  Future<Result<StudyStatisticsEntity>> getStudyStatistics();
  Future<Result<List<SubjectStatisticsEntity>>> getAccuracyStatistics();
  Future<Result<List<SubjectStatisticsEntity>>> getWeakSubjects();
  Future<Result<List<SubjectStatisticsEntity>>> getStrongSubjects();

  // Realtime + per-category API added in Phase 43.
  Stream<StatisticsSnapshot> watch(String uid);
  Future<StatisticsSnapshot> snapshot(String uid);
  Future<CategoryStatisticsEntity> category({
    required String uid,
    required String categoryId,
  });
}
