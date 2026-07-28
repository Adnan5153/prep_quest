import '../entities/subscription_entity.dart';

/// Contract the Presentation layer depends on. Implementations live
/// in the data layer so they can be swapped for Play Billing, Apple
/// IAP, bKash, Nagad or SSLCommerz without touching widgets.
abstract class SubscriptionRepository {
  /// Returns the catalogue of purchasable plans.
  Future<List<SubscriptionPlanEntity>> getPlans();

  /// Returns the user's current subscription state, or a free-tier
  /// default if the user has never purchased.
  Future<SubscriptionEntity> getCurrentSubscription();

  /// Kicks off a purchase for the given plan. Implementations are
  /// expected to return a [PurchaseEntity] describing the result.
  Future<PurchaseEntity> purchaseSubscription({
    required String planId,
    required String providerCode,
  });

  /// Re-reads purchases from the payment gateway and refreshes the
  /// locally cached subscription.
  Future<SubscriptionEntity> restorePurchases();

  /// Cancels the active auto-renewing subscription. The current
  /// entitlement is retained until the period ends.
  Future<SubscriptionEntity> cancelSubscription();

  /// Quick helper used by feature gates (e.g. AI tutor unlimited).
  Future<bool> checkPremiumAccess();
}