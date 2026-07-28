// ignore_for_file: prefer_initializing_formals

import '../../domain/entities/subscription_entity.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/subscription_remote_datasource.dart';
import '../models/subscription_model.dart';

/// Default [SubscriptionRepository] backed by the remote + local
/// datasources. This is the single seam where payment-provider
/// implementations are swapped in (Play Billing, Apple IAP, bKash,
/// Nagad, SSLCommerz, etc.).
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  SubscriptionRepositoryImpl({
    required SubscriptionRemoteDatasource remote,
    required SubscriptionLocalDatasource local,
  })  : _remote = remote,
        _local = local;

  final SubscriptionRemoteDatasource _remote;
  final SubscriptionLocalDatasource _local;

  @override
  Future<List<SubscriptionPlanEntity>> getPlans() async {
    final List<SubscriptionPlanModel> plans = await _remote.getPlans();
    final List<SubscriptionFeatureEntity> catalog =
        subscriptionFeatureCatalog();
    return plans
        .map(
          (SubscriptionPlanModel p) => p.toEntity(catalog),
        )
        .toList(growable: false);
  }

  @override
  Future<SubscriptionEntity> getCurrentSubscription() async {
    final SubscriptionModel model = await _remote.getCurrentSubscription();
    final SubscriptionEntity entity =
        model.toEntity(subscriptionFeatureCatalog());
    await _local.setPremiumEntitlement(entity.isPremium);
    return entity;
  }

  @override
  Future<PurchaseEntity> purchaseSubscription({
    required String planId,
    required String providerCode,
  }) async {
    final PurchaseModel result = await _remote.purchase(
      planId: planId,
      providerCode: providerCode,
    );
    final PurchaseEntity entity = result.toEntity();
    if (entity.status.isSuccess) {
      final SubscriptionEntity current = await getCurrentSubscription();
      await _local.setPremiumEntitlement(current.isPremium);
    }
    return entity;
  }

  @override
  Future<SubscriptionEntity> restorePurchases() async {
    final SubscriptionModel model = await _remote.restorePurchases();
    final SubscriptionEntity entity =
        model.toEntity(subscriptionFeatureCatalog());
    await _local.setPremiumEntitlement(entity.isPremium);
    return entity;
  }

  @override
  Future<SubscriptionEntity> cancelSubscription() async {
    final SubscriptionModel model = await _remote.cancelSubscription();
    final SubscriptionEntity entity =
        model.toEntity(subscriptionFeatureCatalog());
    await _local.setPremiumEntitlement(entity.isPremium);
    return entity;
  }

  @override
  Future<bool> checkPremiumAccess() => _local.hasPremiumEntitlement();
}
