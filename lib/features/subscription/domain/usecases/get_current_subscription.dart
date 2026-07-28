import '../entities/subscription_entity.dart';
import '../repositories/subscription_repository.dart';

/// Returns the user's current subscription state.
class GetCurrentSubscription {
  const GetCurrentSubscription(this._repository);

  final SubscriptionRepository _repository;

  Future<SubscriptionEntity> call() => _repository.getCurrentSubscription();
}