import '../../../../shared/typedefs/result.dart';
import '../entities/subject_statistics_entity.dart';
import '../repositories/statistics_repository.dart';

class GetAccuracyStatistics {
  const GetAccuracyStatistics(this._repository);

  final StatisticsRepository _repository;

  Future<Result<List<SubjectStatisticsEntity>>> call() =>
      _repository.getAccuracyStatistics();
}