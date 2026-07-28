import '../../../../core/errors/error_handler.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/statistics_entity.dart';
import '../../domain/entities/study_statistics_entity.dart';
import '../../domain/entities/subject_statistics_entity.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../datasources/statistics_remote_datasource.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  StatisticsRepositoryImpl(this._remote);

  final StatisticsRemoteDataSource _remote;
  StatisticsEntity? _cache;

  @override
  Future<Result<StatisticsEntity>> getStatistics() async {
    try {
      final StatisticsEntity stats = _cache ??= await _remote.fetchStatistics();
      return Result<StatisticsEntity>.success(stats);
    } catch (error, stackTrace) {
      return Result<StatisticsEntity>.failure(
        ErrorHandler.map(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<StudyStatisticsEntity>> getStudyStatistics() async {
    try {
      final StatisticsEntity stats =
          _cache ??= await _remote.fetchStatistics();
      return Result<StudyStatisticsEntity>.success(stats.study);
    } catch (error, stackTrace) {
      return Result<StudyStatisticsEntity>.failure(
        ErrorHandler.map(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<List<SubjectStatisticsEntity>>> getAccuracyStatistics() async {
    try {
      final StatisticsEntity stats =
          _cache ??= await _remote.fetchStatistics();
      return Result<List<SubjectStatisticsEntity>>.success(
        List<SubjectStatisticsEntity>.unmodifiable(stats.subjectBreakdown),
      );
    } catch (error, stackTrace) {
      return Result<List<SubjectStatisticsEntity>>.failure(
        ErrorHandler.map(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<List<SubjectStatisticsEntity>>> getWeakSubjects() async {
    try {
      final StatisticsEntity stats =
          _cache ??= await _remote.fetchStatistics();
      return Result<List<SubjectStatisticsEntity>>.success(
        List<SubjectStatisticsEntity>.unmodifiable(stats.weakSubjects),
      );
    } catch (error, stackTrace) {
      return Result<List<SubjectStatisticsEntity>>.failure(
        ErrorHandler.map(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<List<SubjectStatisticsEntity>>> getStrongSubjects() async {
    try {
      final StatisticsEntity stats =
          _cache ??= await _remote.fetchStatistics();
      return Result<List<SubjectStatisticsEntity>>.success(
        List<SubjectStatisticsEntity>.unmodifiable(stats.strongSubjects),
      );
    } catch (error, stackTrace) {
      return Result<List<SubjectStatisticsEntity>>.failure(
        ErrorHandler.map(error, stackTrace),
      );
    }
  }
}