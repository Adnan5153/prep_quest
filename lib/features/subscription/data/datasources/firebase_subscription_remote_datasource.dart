import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../../core/constants/firestore_keys.dart';
import '../../domain/entities/subscription_entity.dart';
import '../models/subscription_model.dart';
import 'subscription_remote_datasource.dart';

/// Firestore-backed [SubscriptionRemoteDatasource] (Phase 55).
///
/// Reads plans from the top-level `subscription_plans` collection and
/// the current entitlement from `users/{uid}/subscription/current`.
/// Purchase / restore / cancel are routed through a Cloud Function
/// (`callableSubscriptionPurchase` — stubbed locally until the
/// production callable is deployed; the
/// `MockSubscriptionRemoteDatasource`'s MethodChannel handles the
/// native IAP flow as before, so user-facing purchase behaviour is
/// unaffected).
///
/// Schema (read):
///   subscription_plans/{planId}: id, tier, name, tagline, price_bdt,
///     currency_code, billing_cycle_months, discount_percent,
///     recommended, feature_ids[], payment_provider_codes[]
///   users/{uid}/subscription/current: tier, status,
///     renews_at_iso, expires_at_iso, auto_renews, transaction_id,
///     plan{...}
class FirebaseSubscriptionRemoteDatasource
    implements SubscriptionRemoteDatasource {
  FirebaseSubscriptionRemoteDatasource({
    required String uid,
    FirebaseFirestore? firestore,
  })  : _uid = uid,
        _firestore = firestore ?? FirebaseConfig.firestore;

  final String _uid;
  final FirebaseFirestore? _firestore;

  CollectionReference<Map<String, dynamic>> _plansRef() {
    return _firestore!.collection(FirestoreKeys.subscriptionPlansCollection);
  }

  DocumentReference<Map<String, dynamic>> _currentRef() {
    return _firestore!
        .collection(FirestoreKeys.users)
        .doc(_uid)
        .collection(FirestoreKeys.subscriptionSubcollection)
        .doc(FirestoreKeys.currentDocId);
  }

  @override
  Future<List<SubscriptionPlanModel>> getPlans() async {
    if (_firestore == null) return const <SubscriptionPlanModel>[];
    final QuerySnapshot<Map<String, dynamic>> snap = await _plansRef().get();
    final List<SubscriptionPlanModel> out = snap.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
            SubscriptionPlanModel.fromMap(<String, dynamic>{
              'id': doc.id,
              ...?doc.data(),
            }))
        .toList(growable: false);
    out.sort(
      (SubscriptionPlanModel a, SubscriptionPlanModel b) =>
          a.billingCycleMonths.compareTo(b.billingCycleMonths),
    );
    return List<SubscriptionPlanModel>.unmodifiable(out);
  }

  @override
  Future<SubscriptionModel> getCurrentSubscription() async {
    if (_firestore == null) {
      return _freeSubscription();
    }
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await _currentRef().get();
    if (!doc.exists) {
      return _freeSubscription();
    }
    return SubscriptionModel.fromMap(<String, dynamic>{
      'tier': 'free',
      'status': 'active',
      'renews_at_iso': '',
      'expires_at_iso': '',
      'auto_renews': false,
      'transaction_id': '',
      ...?doc.data(),
    });
  }

  @override
  Future<PurchaseModel> purchase({
    required String planId,
    required String providerCode,
  }) async {
    // Native IAP is funneled through the platform's MethodChannel
    // (Play Billing / Apple IAP). Production wiring once a Cloud
    // Function for receipt validation lands is delegated to Phase 56;
    // for Phase 55 the purchase acknowledgement is written to
    // `users/{uid}/subscription/current` so screens can react.
    final SubscriptionModel current = await getCurrentSubscription();
    final String txnId =
        'txn-${DateTime.now().microsecondsSinceEpoch}';
    final String nowIso = DateTime.now().toUtc().toIso8601String();
    if (_firestore != null) {
      await _currentRef().set(<String, dynamic>{
        ...?current.toMap(),
        'transaction_id': txnId,
      }, SetOptions(merge: true));
    }
    return PurchaseModel(
      transactionId: txnId,
      planId: planId,
      purchasedAtIso: nowIso,
      expiresAtIso: current.expiresAtIso.isEmpty
          ? DateTime.now()
              .add(const Duration(days: 30))
              .toUtc()
              .toIso8601String()
          : current.expiresAtIso,
      providerCode: providerCode,
      status: PurchaseStatus.success,
      amount: 0,
      currencyCode: '৳',
    );
  }

  @override
  Future<SubscriptionModel> restorePurchases() async {
    // Native IAP restore is funneled through the MethodChannel; this
    // datasource reads the resulting entitlement from Firestore.
    return getCurrentSubscription();
  }

  @override
  Future<SubscriptionModel> cancelSubscription() async {
    final SubscriptionModel current = await getCurrentSubscription();
    if (current.tier == SubscriptionTier.free) return current;
    final SubscriptionModel updated = current.copyWith(
      autoRenews: false,
      status: SubscriptionStatus.cancelled,
    );
    if (_firestore != null) {
      await _currentRef()
          .set(<String, dynamic>{...updated.toMap()}, SetOptions(merge: true));
    }
    return updated;
  }

  SubscriptionModel _freeSubscription() {
    return const SubscriptionModel(
      tier: SubscriptionTier.free,
      status: SubscriptionStatus.active,
      renewsAtIso: '',
      expiresAtIso: '',
      autoRenews: false,
      transactionId: '',
    );
  }
}