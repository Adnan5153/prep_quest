import 'package:flutter/foundation.dart';

/// Subscription tier surfaced by the Plans screen. Mapped from the
/// mock remote catalogue today; the same enum will be returned by the
/// future Firestore collection.
enum SubscriptionTier {
  free,
  monthly,
  quarterly,
  yearly,
}

extension SubscriptionTierX on SubscriptionTier {
  /// Whether this tier unlocks the paid feature set.
  bool get isPremium => this != SubscriptionTier.free;

  /// Display label used by the UI.
  String get displayName {
    switch (this) {
      case SubscriptionTier.free:
        return 'Free';
      case SubscriptionTier.monthly:
        return 'Monthly Premium';
      case SubscriptionTier.quarterly:
        return 'Quarterly Premium';
      case SubscriptionTier.yearly:
        return 'Yearly Premium';
    }
  }
}

/// Where a subscription sits in its lifecycle.
enum SubscriptionStatus { active, expired, cancelled, pending, restored }

extension SubscriptionStatusX on SubscriptionStatus {
  bool get isActive => this == SubscriptionStatus.active;
  bool get isPending => this == SubscriptionStatus.pending;
}

/// One row in the "What you get" comparison table. Lives in the domain
/// because it's a plain value type that the data layer maps to/from
/// storage.
@immutable
class SubscriptionFeatureEntity {
  const SubscriptionFeatureEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.iconCodePoint,
    required this.freeAvailable,
    required this.premiumAvailable,
  });

  final String id;
  final String title;
  final String description;
  final int iconCodePoint;
  final bool freeAvailable;
  final bool premiumAvailable;
}

/// A purchasable plan as advertised by the catalog endpoint.
@immutable
class SubscriptionPlanEntity {
  const SubscriptionPlanEntity({
    required this.id,
    required this.tier,
    required this.name,
    required this.tagline,
    required this.priceBdt,
    required this.currencyCode,
    required this.billingCycleMonths,
    required this.discountPercent,
    required this.recommended,
    required this.features,
    required this.paymentProviderCodes,
  });

  final String id;
  final SubscriptionTier tier;
  final String name;
  final String tagline;
  final double priceBdt;
  final String currencyCode;
  final int billingCycleMonths;
  final int discountPercent;
  final bool recommended;
  final List<SubscriptionFeatureEntity> features;

  /// Stable identifiers the payment gateway understands (e.g.
  /// `play:billing:premium_yearly`). Used so the repository can
  /// dispatch to the right provider implementation.
  final List<String> paymentProviderCodes;

  /// Human-readable billing-cycle label, e.g. `৳299 / month`.
  String get cycleLabel {
    final String price = '$currencyCode ${priceBdt.toStringAsFixed(0)}';
    if (tier == SubscriptionTier.free) return 'Free forever';
    if (billingCycleMonths == 0) return '$price once';
    if (billingCycleMonths % 12 == 0) {
      final int years = billingCycleMonths ~/ 12;
      return '$price / ${years == 1 ? "year" : "${years}yr"}';
    }
    return '$price / ${billingCycleMonths}mo';
  }
}

/// The current subscription state for the signed-in user.
@immutable
class SubscriptionEntity {
  const SubscriptionEntity({
    required this.tier,
    required this.status,
    required this.renewsAtIso,
    required this.expiresAtIso,
    required this.autoRenews,
    required this.transactionId,
    required this.plan,
  });

  factory SubscriptionEntity.free() {
    return const SubscriptionEntity(
      tier: SubscriptionTier.free,
      status: SubscriptionStatus.active,
      renewsAtIso: '',
      expiresAtIso: '',
      autoRenews: false,
      transactionId: '',
      plan: null,
    );
  }

  final SubscriptionTier tier;
  final SubscriptionStatus status;
  final String renewsAtIso;
  final String expiresAtIso;
  final bool autoRenews;
  final String transactionId;

  /// The originating plan object, or `null` for the free tier.
  final SubscriptionPlanEntity? plan;

  /// Convenience for the gate-keep code path.
  bool get isPremium => tier.isPremium && status.isActive;

  SubscriptionEntity copyWith({
    SubscriptionTier? tier,
    SubscriptionStatus? status,
    String? renewsAtIso,
    String? expiresAtIso,
    bool? autoRenews,
    String? transactionId,
    SubscriptionPlanEntity? plan,
  }) {
    return SubscriptionEntity(
      tier: tier ?? this.tier,
      status: status ?? this.status,
      renewsAtIso: renewsAtIso ?? this.renewsAtIso,
      expiresAtIso: expiresAtIso ?? this.expiresAtIso,
      autoRenews: autoRenews ?? this.autoRenews,
      transactionId: transactionId ?? this.transactionId,
      plan: plan ?? this.plan,
    );
  }
}

/// Result of a single purchase / restore attempt.
@immutable
class PurchaseEntity {
  const PurchaseEntity({
    required this.transactionId,
    required this.planId,
    required this.purchasedAtIso,
    required this.expiresAtIso,
    required this.providerCode,
    required this.status,
    required this.amount,
    required this.currencyCode,
  });

  final String transactionId;
  final String planId;
  final String purchasedAtIso;
  final String expiresAtIso;
  final String providerCode;
  final PurchaseStatus status;
  final double amount;
  final String currencyCode;
}

enum PurchaseStatus { success, pending, failed, restored, cancelled }

extension PurchaseStatusX on PurchaseStatus {
  bool get isSuccess =>
      this == PurchaseStatus.success || this == PurchaseStatus.restored;
}