import '../../domain/entities/statistics_entity.dart';

abstract class StatisticsRemoteDataSource {
  Future<StatisticsEntity> fetchStatistics();
}