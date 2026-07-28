import '../entities/subscription_entity.dart';
import '../repositories/subscription_repository.dart';

/// Cancels the active auto-renewing subscription.
class CancelSubscription {
  const CancelSubscription(this._repository);

  final SubscriptionRepository _repository;

  Future<SubscriptionEntity> call() => _repository.cancelSubscription();
}