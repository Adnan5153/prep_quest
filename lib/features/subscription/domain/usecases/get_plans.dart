import '../entities/subscription_entity.dart';
import '../repositories/subscription_repository.dart';

/// Returns the catalogue of purchasable plans.
class GetPlans {
  const GetPlans(this._repository);

  final SubscriptionRepository _repository;

  Future<List<SubscriptionPlanEntity>> call() => _repository.getPlans();
}