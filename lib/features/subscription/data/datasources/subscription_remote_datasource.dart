import 'dart:async';

import 'package:flutter/services.dart';

import '../../domain/entities/subscription_entity.dart';
import '../models/subscription_model.dart';

/// Contract for the remote (Firestore / Cloud Functions backed)
/// catalogue and entitlement lookup. The mock implementation below
/// returns deterministic in-memory data so the UI can be exercised
/// without Firebase wired in.
abstract class SubscriptionRemoteDatasource {
  Future<List<SubscriptionPlanModel>> getPlans();
  Future<SubscriptionModel> getCurrentSubscription();
  Future<PurchaseModel> purchase({
    required String planId,
    required String providerCode,
  });
  Future<SubscriptionModel> restorePurchases();
  Future<SubscriptionModel> cancelSubscription();
}

/// Static feature catalogue used by both the mock and any future
/// real implementation. Centralised here so the model can rebuild
/// plan feature lists from plan `feature_ids`.
final List<SubscriptionFeatureEntity> _featureCatalog =
    <SubscriptionFeatureEntity>[
      const SubscriptionFeatureEntity(
        id: 'unlimited_ai_explanations',
        title: 'Unlimited AI Explanations',
        description:
            'Ask anything, get an unlimited number of deep explanations.',
        icon: SubscriptionFeatureIcon.unlimitedAi,
        freeAvailable: false,
        premiumAvailable: true,
      ),
      const SubscriptionFeatureEntity(
        id: 'unlimited_ai_hints',
        title: 'Unlimited AI Hints',
        description: 'Get unstuck without losing your streak.',
        icon: SubscriptionFeatureIcon.hints,
        freeAvailable: false,
        premiumAvailable: true,
      ),
      const SubscriptionFeatureEntity(
        id: 'unlimited_ai_flashcards',
        title: 'Unlimited AI Flashcards',
        description: 'Generate flashcards for any topic on demand.',
        icon: SubscriptionFeatureIcon.flashcards,
        freeAvailable: false,
        premiumAvailable: true,
      ),
      const SubscriptionFeatureEntity(
        id: 'unlimited_ai_study_plans',
        title: 'Unlimited AI Study Plans',
        description: 'Personalised 4-week study plans, refreshed weekly.',
        icon: SubscriptionFeatureIcon.studyPlans,
        freeAvailable: false,
        premiumAvailable: true,
      ),
      const SubscriptionFeatureEntity(
        id: 'premium_mock_tests',
        title: 'Premium Mock Tests',
        description: 'Full-length BCS model tests with detailed solutions.',
        icon: SubscriptionFeatureIcon.mockTests,
        freeAvailable: false,
        premiumAvailable: true,
      ),
      const SubscriptionFeatureEntity(
        id: 'advanced_analytics',
        title: 'Advanced Analytics',
        description: 'Track streaks, accuracy, weak topics and study time.',
        icon: SubscriptionFeatureIcon.advancedAnalytics,
        freeAvailable: false,
        premiumAvailable: true,
      ),
      const SubscriptionFeatureEntity(
        id: 'weakness_reports',
        title: 'Detailed Weakness Reports',
        description: 'Per-subject weakness breakdowns with prescriptions.',
        icon: SubscriptionFeatureIcon.weaknessReports,
        freeAvailable: false,
        premiumAvailable: true,
      ),
      const SubscriptionFeatureEntity(
        id: 'unlimited_bookmarks',
        title: 'Unlimited Bookmarks',
        description: 'Save every question, lesson and AI response.',
        icon: SubscriptionFeatureIcon.unlimitedBookmarks,
        freeAvailable: false,
        premiumAvailable: true,
      ),
      const SubscriptionFeatureEntity(
        id: 'offline_downloads',
        title: 'Offline Downloads',
        description: 'Read lessons and take quizzes without internet.',
        icon: SubscriptionFeatureIcon.offlineDownloads,
        freeAvailable: false,
        premiumAvailable: true,
      ),
      const SubscriptionFeatureEntity(
        id: 'priority_content',
        title: 'Priority Content Access',
        description: 'New lessons and mock tests drop 48h early for Premium.',
        icon: SubscriptionFeatureIcon.priorityContent,
        freeAvailable: false,
        premiumAvailable: true,
      ),
      const SubscriptionFeatureEntity(
        id: 'exclusive_study_materials',
        title: 'Exclusive Study Materials',
        description: 'Hand-curated guides, cheat-sheets and model answers.',
        icon: SubscriptionFeatureIcon.exclusiveStudyMaterials,
        freeAvailable: false,
        premiumAvailable: true,
      ),
      const SubscriptionFeatureEntity(
        id: 'ad_free',
        title: 'Ad-Free Experience',
        description: 'No interruptions — ever.',
        icon: SubscriptionFeatureIcon.adFree,
        freeAvailable: false,
        premiumAvailable: true,
      ),
    ];

List<SubscriptionFeatureEntity> subscriptionFeatureCatalog() =>
    List<SubscriptionFeatureEntity>.unmodifiable(_featureCatalog);

/// Mock implementation. Replace with Firestore / Cloud Functions in
/// production by swapping the provider binding.
class MockSubscriptionRemoteDatasource implements SubscriptionRemoteDatasource {
  MockSubscriptionRemoteDatasource();

  static const MethodChannel _channel = MethodChannel(
    'prep_quest/subscription',
  );

  final List<SubscriptionPlanModel> _plans = <SubscriptionPlanModel>[
    SubscriptionPlanModel.fromMap(<String, dynamic>{
      'id': 'plan_free',
      'tier': 'free',
      'name': 'Free',
      'tagline': 'All the basics, zero cost.',
      'price_bdt': 0,
      'currency_code': '৳',
      'billing_cycle_months': 0,
      'discount_percent': 0,
      'recommended': false,
      'feature_ids': <String>[],
      'payment_provider_codes': <String>[],
    }),
    SubscriptionPlanModel.fromMap(<String, dynamic>{
      'id': 'plan_monthly',
      'tier': 'monthly',
      'name': 'Monthly Premium',
      'tagline': 'Unlimited access, billed monthly.',
      'price_bdt': 299,
      'currency_code': '৳',
      'billing_cycle_months': 1,
      'discount_percent': 0,
      'recommended': false,
      'feature_ids': const <String>[
        'unlimited_ai_explanations',
        'unlimited_ai_hints',
        'unlimited_ai_flashcards',
        'unlimited_ai_study_plans',
        'premium_mock_tests',
        'advanced_analytics',
        'weakness_reports',
        'unlimited_bookmarks',
        'offline_downloads',
        'priority_content',
        'exclusive_study_materials',
        'ad_free',
      ],
      'payment_provider_codes': const <String>[
        'play:billing:premium_monthly',
        'apple:iap:premium_monthly',
      ],
    }),
    SubscriptionPlanModel.fromMap(<String, dynamic>{
      'id': 'plan_quarterly',
      'tier': 'quarterly',
      'name': 'Quarterly Premium',
      'tagline': 'Save 15% with a 3-month plan.',
      'price_bdt': 749,
      'currency_code': '৳',
      'billing_cycle_months': 3,
      'discount_percent': 15,
      'recommended': false,
      'feature_ids': const <String>[
        'unlimited_ai_explanations',
        'unlimited_ai_hints',
        'unlimited_ai_flashcards',
        'unlimited_ai_study_plans',
        'premium_mock_tests',
        'advanced_analytics',
        'weakness_reports',
        'unlimited_bookmarks',
        'offline_downloads',
        'priority_content',
        'exclusive_study_materials',
        'ad_free',
      ],
      'payment_provider_codes': const <String>[
        'play:billing:premium_quarterly',
        'apple:iap:premium_quarterly',
      ],
    }),
    SubscriptionPlanModel.fromMap(<String, dynamic>{
      'id': 'plan_yearly',
      'tier': 'yearly',
      'name': 'Yearly Premium',
      'tagline': 'Best value — two months on us.',
      'price_bdt': 2499,
      'currency_code': '৳',
      'billing_cycle_months': 12,
      'discount_percent': 30,
      'recommended': true,
      'feature_ids': const <String>[
        'unlimited_ai_explanations',
        'unlimited_ai_hints',
        'unlimited_ai_flashcards',
        'unlimited_ai_study_plans',
        'premium_mock_tests',
        'advanced_analytics',
        'weakness_reports',
        'unlimited_bookmarks',
        'offline_downloads',
        'priority_content',
        'exclusive_study_materials',
        'ad_free',
      ],
      'payment_provider_codes': const <String>[
        'play:billing:premium_yearly',
        'apple:iap:premium_yearly',
        'bkash:premium_yearly',
        'nagad:premium_yearly',
        'sslcommerz:premium_yearly',
      ],
    }),
  ];

  SubscriptionModel _current = const SubscriptionModel(
    tier: SubscriptionTier.free,
    status: SubscriptionStatus.active,
    renewsAtIso: '',
    expiresAtIso: '',
    autoRenews: false,
    transactionId: '',
  );

  @override
  Future<List<SubscriptionPlanModel>> getPlans() async {
    return List<SubscriptionPlanModel>.unmodifiable(_plans);
  }

  @override
  Future<SubscriptionModel> getCurrentSubscription() async {
    try {
      final Map<Object?, Object?>? raw = await _channel
          .invokeMapMethod<Object?, Object?>('getCurrentSubscription');
      if (raw != null) {
        return SubscriptionModel.fromMap(
          raw.map(
            (Object? k, Object? v) =>
                MapEntry<String, dynamic>(k.toString(), v),
          ),
        );
      }
    } on MissingPluginException {
      // Mock mode: return in-memory state.
    } on PlatformException {
      // Mock mode: return in-memory state.
    }
    return _current;
  }

  @override
  Future<PurchaseModel> purchase({
    required String planId,
    required String providerCode,
  }) async {
    final SubscriptionPlanModel matchedPlan = _plans.firstWhere(
      (SubscriptionPlanModel p) => p.id == planId,
      orElse: () => _plans.first,
    );
    final SubscriptionPlanModel plan = matchedPlan;
    final DateTime now = DateTime.now();
    final DateTime expiresAt = DateTime(
      now.year,
      now.month + plan.billingCycleMonths,
      now.day,
    );
    _current = SubscriptionModel(
      tier: plan.tier,
      status: SubscriptionStatus.active,
      renewsAtIso: expiresAt.toIso8601String(),
      expiresAtIso: expiresAt.toIso8601String(),
      autoRenews: plan.tier != SubscriptionTier.free,
      transactionId: 'txn_${now.millisecondsSinceEpoch}',
      plan: plan,
    );
    return PurchaseModel(
      transactionId: _current.transactionId,
      planId: plan.id,
      purchasedAtIso: now.toIso8601String(),
      expiresAtIso: expiresAt.toIso8601String(),
      providerCode: providerCode,
      status: PurchaseStatus.success,
      amount: plan.priceBdt,
      currencyCode: plan.currencyCode,
    );
  }

  @override
  Future<SubscriptionModel> restorePurchases() async {
    // The mock treats the current in-memory state as already restored.
    return _current;
  }

  @override
  Future<SubscriptionModel> cancelSubscription() async {
    if (_current.tier == SubscriptionTier.free) {
      return _current;
    }
    _current = _current.copyWith(
      autoRenews: false,
      status: SubscriptionStatus.cancelled,
    );
    return _current;
  }

  // ---- Internal mutator for tests --------------------------------------
  // ignore: unused_element
  void _setCurrent(SubscriptionModel model) => _current = model;
}

/// Reads/writes the locally cached entitlement. Used for the
/// "is the user premium?" fast-path that gates AI tutor limits.
abstract class SubscriptionLocalDatasource {
  Future<bool> hasPremiumEntitlement();
  Future<void> setPremiumEntitlement(bool value);
}

class MockSubscriptionLocalDatasource implements SubscriptionLocalDatasource {
  bool _cache = false;

  @override
  Future<bool> hasPremiumEntitlement() async => _cache;

  @override
  Future<void> setPremiumEntitlement(bool value) async {
    _cache = value;
  }
}
