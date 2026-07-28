import '../repositories/subscription_repository.dart';

/// Quick boolean check used by feature gates across the app (e.g. the
/// AI tutor limit warning, the offline download toggle).
class CheckPremiumAccess {
  const CheckPremiumAccess(this._repository);

  final SubscriptionRepository _repository;

  Future<bool> call() => _repository.checkPremiumAccess();
}