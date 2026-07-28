import '../../../../core/errors/error_handler.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../datasources/lesson_remote_datasource.dart';

class LessonRepositoryImpl implements LessonRepository {
  const LessonRepositoryImpl(this._remote);

  final LessonRemoteDataSource _remote;

  @override
  Future<Result<List<LessonEntity>>> getAllLessons() async {
    try {
      final models = await _remote.fetchAllLessons();
      return Result.success(
        models.map((m) => m.toEntity()).toList(growable: false),
      );
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<List<LessonEntity>>> getLessonsForNode(String nodeId) async {
    try {
      final models = await _remote.fetchLessonsForNode(nodeId);
      return Result.success(
        models.map((m) => m.toEntity()).toList(growable: false),
      );
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<LessonEntity?>> getLessonById(String id) async {
    try {
      final model = await _remote.fetchLessonById(id);
      return Result.success(model?.toEntity());
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<LessonEntity?>> getLessonBySlug(String slug) async {
    try {
      final model = await _remote.fetchLessonBySlug(slug);
      return Result.success(model?.toEntity());
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }
}