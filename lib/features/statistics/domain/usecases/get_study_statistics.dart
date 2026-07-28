import '../../../../shared/typedefs/result.dart';
import '../entities/study_statistics_entity.dart';
import '../repositories/statistics_repository.dart';

class GetStudyStatistics {
  const GetStudyStatistics(this._repository);

  final StatisticsRepository _repository;

  Future<Result<StudyStatisticsEntity>> call() =>
      _repository.getStudyStatistics();
}