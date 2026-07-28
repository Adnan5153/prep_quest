import '../entities/subscription_entity.dart';
import '../repositories/subscription_repository.dart';

/// Returns the user's current subscription state. Kept as a separate
/// use case so legacy call-sites that imported [GetSubscription]
/// continue to compile while the rest of the codebase adopts
/// [GetCurrentSubscription].
class GetSubscription {
  const GetSubscription(this._repository);

  final SubscriptionRepository _repository;

  Future<SubscriptionEntity> call() => _repository.getCurrentSubscription();
}