import '../entities/subscription_entity.dart';
import '../repositories/subscription_repository.dart';

/// Kicks off a purchase for the given plan. The presentation layer
/// passes the payment provider code so the data layer can route to
/// the correct gateway implementation.
class PurchaseSubscription {
  const PurchaseSubscription(this._repository);

  final SubscriptionRepository _repository;

  Future<PurchaseEntity> call({
    required String planId,
    required String providerCode,
  }) {
    return _repository.purchaseSubscription(
      planId: planId,
      providerCode: providerCode,
    );
  }
}