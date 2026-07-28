import '../../../../shared/typedefs/result.dart';
import '../entities/statistics_entity.dart';
import '../entities/study_statistics_entity.dart';
import '../entities/subject_statistics_entity.dart';

abstract class StatisticsRepository {
  Future<Result<StatisticsEntity>> getStatistics();
  Future<Result<StudyStatisticsEntity>> getStudyStatistics();
  Future<Result<List<SubjectStatisticsEntity>>> getAccuracyStatistics();
  Future<Result<List<SubjectStatisticsEntity>>> getWeakSubjects();
  Future<Result<List<SubjectStatisticsEntity>>> getStrongSubjects();
}