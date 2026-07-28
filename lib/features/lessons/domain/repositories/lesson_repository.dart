import '../../../../shared/typedefs/result.dart';
import '../entities/lesson_entity.dart';

/// Domain-level contract every lesson repository must satisfy.
///
/// Implementations live in `data/repositories/` and may delegate to a
/// remote data source (Firestore once wired) and/or a local cache
/// (Hive/SQLite). The contract returns [Result]s so the presentation
/// layer can branch on success/failure without try/catch noise.
abstract class LessonRepository {
  /// Returns every lesson available to the player. The list is
  /// intentionally flat — the presentation layer is responsible for any
  /// grouping, filtering, or sorting.
  Future<Result<List<LessonEntity>>> getAllLessons();

  /// Returns the lessons linked to a Playground node id (e.g. `node-2`).
  ///
  /// Used by the Playground → Lesson navigation flow so tapping a level
  /// loads the curated content for that level.
  Future<Result<List<LessonEntity>>> getLessonsForNode(String nodeId);

  /// Returns a single lesson by id, or `null` if it does not exist.
  Future<Result<LessonEntity?>> getLessonById(String id);

  /// Resolves a [LessonEntity] by its slug (used for deep linking).
  Future<Result<LessonEntity?>> getLessonBySlug(String slug);
}