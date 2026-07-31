import '../../domain/entities/subscription_entity.dart';

/// DTO for [SubscriptionEntity]. Owns the (de)serialisation contract
/// so the entity stays framework-independent.
class SubscriptionModel {
  const SubscriptionModel({
    required this.tier,
    required this.status,
    required this.renewsAtIso,
    required this.expiresAtIso,
    required this.autoRenews,
    required this.transactionId,
    this.plan,
  });

  factory SubscriptionModel.fromEntity(SubscriptionEntity entity) {
    return SubscriptionModel(
      tier: entity.tier,
      status: entity.status,
      renewsAtIso: entity.renewsAtIso,
      expiresAtIso: entity.expiresAtIso,
      autoRenews: entity.autoRenews,
      transactionId: entity.transactionId,
      plan: entity.plan == null
          ? null
          : SubscriptionPlanModel.fromEntity(entity.plan!),
    );
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      tier: _tierFromString(map['tier'] as String?),
      status: _statusFromString(map['status'] as String?),
      renewsAtIso: (map['renews_at_iso'] as String?) ?? '',
      expiresAtIso: (map['expires_at_iso'] as String?) ?? '',
      autoRenews: map['auto_renews'] as bool? ?? false,
      transactionId: (map['transaction_id'] as String?) ?? '',
      plan: map['plan'] == null
          ? null
          : SubscriptionPlanModel.fromMap(
              Map<String, dynamic>.from(map['plan'] as Map),
            ),
    );
  }

  final SubscriptionTier tier;
  final SubscriptionStatus status;
  final String renewsAtIso;
  final String expiresAtIso;
  final bool autoRenews;
  final String transactionId;
  final SubscriptionPlanModel? plan;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tier': tier.name,
      'status': status.name,
      'renews_at_iso': renewsAtIso,
      'expires_at_iso': expiresAtIso,
      'auto_renews': autoRenews,
      'transaction_id': transactionId,
      'plan': plan?.toMap(),
    };
  }

  SubscriptionEntity toEntity(List<SubscriptionFeatureEntity> catalog) {
    return SubscriptionEntity(
      tier: tier,
      status: status,
      renewsAtIso: renewsAtIso,
      expiresAtIso: expiresAtIso,
      autoRenews: autoRenews,
      transactionId: transactionId,
      plan: plan?.toEntity(catalog),
    );
  }

  SubscriptionModel copyWith({
    SubscriptionTier? tier,
    SubscriptionStatus? status,
    String? renewsAtIso,
    String? expiresAtIso,
    bool? autoRenews,
    String? transactionId,
    SubscriptionPlanModel? plan,
  }) {
    return SubscriptionModel(
      tier: tier ?? this.tier,
      status: status ?? this.status,
      renewsAtIso: renewsAtIso ?? this.renewsAtIso,
      expiresAtIso: expiresAtIso ?? this.expiresAtIso,
      autoRenews: autoRenews ?? this.autoRenews,
      transactionId: transactionId ?? this.transactionId,
      plan: plan ?? this.plan,
    );
  }

  static SubscriptionTier _tierFromString(String? raw) {
    if (raw == null) return SubscriptionTier.free;
    return SubscriptionTier.values.firstWhere(
      (SubscriptionTier t) => t.name == raw,
      orElse: () => SubscriptionTier.free,
    );
  }

  static SubscriptionStatus _statusFromString(String? raw) {
    if (raw == null) return SubscriptionStatus.active;
    return SubscriptionStatus.values.firstWhere(
      (SubscriptionStatus s) => s.name == raw,
      orElse: () => SubscriptionStatus.active,
    );
  }
}

class SubscriptionPlanModel {
  const SubscriptionPlanModel({
    required this.id,
    required this.tier,
    required this.name,
    required this.tagline,
    required this.priceBdt,
    required this.currencyCode,
    required this.billingCycleMonths,
    required this.discountPercent,
    required this.recommended,
    required this.featureIds,
    required this.paymentProviderCodes,
  });

  factory SubscriptionPlanModel.fromEntity(SubscriptionPlanEntity entity) {
    return SubscriptionPlanModel(
      id: entity.id,
      tier: entity.tier,
      name: entity.name,
      tagline: entity.tagline,
      priceBdt: entity.priceBdt,
      currencyCode: entity.currencyCode,
      billingCycleMonths: entity.billingCycleMonths,
      discountPercent: entity.discountPercent,
      recommended: entity.recommended,
      featureIds: entity.features
          .map((SubscriptionFeatureEntity f) => f.id)
          .toList(growable: false),
      paymentProviderCodes: entity.paymentProviderCodes,
    );
  }

  factory SubscriptionPlanModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionPlanModel(
      id: map['id'] as String,
      tier: SubscriptionModel._tierFromString(map['tier'] as String?),
      name: map['name'] as String,
      tagline: (map['tagline'] as String?) ?? '',
      priceBdt: (map['price_bdt'] as num?)?.toDouble() ?? 0.0,
      currencyCode: (map['currency_code'] as String?) ?? '৳',
      billingCycleMonths: (map['billing_cycle_months'] as int?) ?? 0,
      discountPercent: (map['discount_percent'] as int?) ?? 0,
      recommended: map['recommended'] as bool? ?? false,
      featureIds: ((map['feature_ids'] as List?) ?? <dynamic>[])
          .map((dynamic e) => e as String)
          .toList(growable: false),
      paymentProviderCodes:
          ((map['payment_provider_codes'] as List?) ?? <dynamic>[])
              .map((dynamic e) => e as String)
              .toList(growable: false),
    );
  }

  final String id;
  final SubscriptionTier tier;
  final String name;
  final String tagline;
  final double priceBdt;
  final String currencyCode;
  final int billingCycleMonths;
  final int discountPercent;
  final bool recommended;
  final List<String> featureIds;
  final List<String> paymentProviderCodes;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'tier': tier.name,
      'name': name,
      'tagline': tagline,
      'price_bdt': priceBdt,
      'currency_code': currencyCode,
      'billing_cycle_months': billingCycleMonths,
      'discount_percent': discountPercent,
      'recommended': recommended,
      'feature_ids': featureIds,
      'payment_provider_codes': paymentProviderCodes,
    };
  }

  SubscriptionPlanEntity toEntity(List<SubscriptionFeatureEntity> catalog) {
    final List<SubscriptionFeatureEntity> resolved = featureIds
        .map(
          (String id) => catalog.firstWhere(
            (SubscriptionFeatureEntity f) => f.id == id,
            orElse: () => const SubscriptionFeatureEntity(
              id: 'unknown',
              title: 'Unknown feature',
              description: '',
              icon: SubscriptionFeatureIcon.hints,
              freeAvailable: false,
              premiumAvailable: false,
            ),
          ),
        )
        .toList(growable: false);
    return SubscriptionPlanEntity(
      id: id,
      tier: tier,
      name: name,
      tagline: tagline,
      priceBdt: priceBdt,
      currencyCode: currencyCode,
      billingCycleMonths: billingCycleMonths,
      discountPercent: discountPercent,
      recommended: recommended,
      features: resolved,
      paymentProviderCodes: paymentProviderCodes,
    );
  }
}

class PurchaseModel {
  const PurchaseModel({
    required this.transactionId,
    required this.planId,
    required this.purchasedAtIso,
    required this.expiresAtIso,
    required this.providerCode,
    required this.status,
    required this.amount,
    required this.currencyCode,
  });

  factory PurchaseModel.fromEntity(PurchaseEntity entity) {
    return PurchaseModel(
      transactionId: entity.transactionId,
      planId: entity.planId,
      purchasedAtIso: entity.purchasedAtIso,
      expiresAtIso: entity.expiresAtIso,
      providerCode: entity.providerCode,
      status: entity.status,
      amount: entity.amount,
      currencyCode: entity.currencyCode,
    );
  }

  factory PurchaseModel.fromMap(Map<String, dynamic> map) {
    return PurchaseModel(
      transactionId: (map['transaction_id'] as String?) ?? '',
      planId: (map['plan_id'] as String?) ?? '',
      purchasedAtIso: (map['purchased_at_iso'] as String?) ?? '',
      expiresAtIso: (map['expires_at_iso'] as String?) ?? '',
      providerCode: (map['provider_code'] as String?) ?? '',
      status: _statusFromString(map['status'] as String?),
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      currencyCode: (map['currency_code'] as String?) ?? '৳',
    );
  }

  final String transactionId;
  final String planId;
  final String purchasedAtIso;
  final String expiresAtIso;
  final String providerCode;
  final PurchaseStatus status;
  final double amount;
  final String currencyCode;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transaction_id': transactionId,
      'plan_id': planId,
      'purchased_at_iso': purchasedAtIso,
      'expires_at_iso': expiresAtIso,
      'provider_code': providerCode,
      'status': status.name,
      'amount': amount,
      'currency_code': currencyCode,
    };
  }

  PurchaseEntity toEntity() {
    return PurchaseEntity(
      transactionId: transactionId,
      planId: planId,
      purchasedAtIso: purchasedAtIso,
      expiresAtIso: expiresAtIso,
      providerCode: providerCode,
      status: status,
      amount: amount,
      currencyCode: currencyCode,
    );
  }

  static PurchaseStatus _statusFromString(String? raw) {
    if (raw == null) return PurchaseStatus.failed;
    return PurchaseStatus.values.firstWhere(
      (PurchaseStatus s) => s.name == raw,
      orElse: () => PurchaseStatus.failed,
    );
  }
}
