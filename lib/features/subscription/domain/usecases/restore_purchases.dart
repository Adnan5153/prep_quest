import '../entities/subscription_entity.dart';
import '../repositories/subscription_repository.dart';

/// Re-reads past purchases from the payment gateway and refreshes the
/// locally cached subscription state.
class RestorePurchases {
  const RestorePurchases(this._repository);

  final SubscriptionRepository _repository;

  Future<SubscriptionEntity> call() => _repository.restorePurchases();
}