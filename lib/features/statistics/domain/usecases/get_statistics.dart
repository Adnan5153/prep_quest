import '../../../../shared/typedefs/result.dart';
import '../entities/statistics_entity.dart';
import '../repositories/statistics_repository.dart';

class GetStatistics {
  const GetStatistics(this._repository);

  final StatisticsRepository _repository;

  Future<Result<StatisticsEntity>> call() => _repository.getStatistics();
}