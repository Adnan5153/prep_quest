// ignore_for_file: prefer_initializing_formals

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';
import '../../data/datasources/firebase_subscription_remote_datasource.dart';
import '../../data/datasources/subscription_remote_datasource.dart';
import '../../data/repositories/subscription_repository_impl.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../domain/usecases/cancel_subscription.dart';
import '../../domain/usecases/check_premium_access.dart';
import '../../domain/usecases/get_current_subscription.dart';
import '../../domain/usecases/get_plans.dart';
import '../../domain/usecases/purchase_subscription.dart';
import '../../domain/usecases/restore_purchases.dart';

// ---------------------------------------------------------------------------
// Wiring
// ---------------------------------------------------------------------------

/// Subscription remote data source.
///
/// Production reads plans from the top-level `subscription_plans`
/// collection and the entitlement from
/// `users/{uid}/subscription/current` via
/// [FirebaseSubscriptionRemoteDatasource]. The MethodChannel-based mock
/// is the offline fallback (tests / unconfigured dev).
final Provider<SubscriptionRemoteDatasource> subscriptionRemoteDataSourceProvider =
    Provider<SubscriptionRemoteDatasource>((Ref ref) {
  if (FirebaseConfig.isPlatformConfigured) {
    final String? uid = ref.watch(authStateProvider).user?.id;
    if (uid != null && uid.isNotEmpty) {
      return FirebaseSubscriptionRemoteDatasource(uid: uid);
    }
  }
  return MockSubscriptionRemoteDatasource();
});

final Provider<SubscriptionLocalDatasource> subscriptionLocalDataSourceProvider =
    Provider<SubscriptionLocalDatasource>((Ref ref) {
  return MockSubscriptionLocalDatasource();
});

final Provider<SubscriptionRepository> subscriptionRepositoryProvider =
    Provider<SubscriptionRepository>((Ref ref) {
  return SubscriptionRepositoryImpl(
    remote: ref.watch(subscriptionRemoteDataSourceProvider),
    local: ref.watch(subscriptionLocalDataSourceProvider),
  );
});

final Provider<GetPlans> getPlansUseCaseProvider =
    Provider<GetPlans>((Ref ref) {
  return GetPlans(ref.watch(subscriptionRepositoryProvider));
});

final Provider<GetCurrentSubscription> getCurrentSubscriptionUseCaseProvider =
    Provider<GetCurrentSubscription>((Ref ref) {
  return GetCurrentSubscription(ref.watch(subscriptionRepositoryProvider));
});

final Provider<PurchaseSubscription> purchaseSubscriptionUseCaseProvider =
    Provider<PurchaseSubscription>((Ref ref) {
  return PurchaseSubscription(ref.watch(subscriptionRepositoryProvider));
});

final Provider<RestorePurchases> restorePurchasesUseCaseProvider =
    Provider<RestorePurchases>((Ref ref) {
  return RestorePurchases(ref.watch(subscriptionRepositoryProvider));
});

final Provider<CancelSubscription> cancelSubscriptionUseCaseProvider =
    Provider<CancelSubscription>((Ref ref) {
  return CancelSubscription(ref.watch(subscriptionRepositoryProvider));
});

final Provider<CheckPremiumAccess> checkPremiumAccessUseCaseProvider =
    Provider<CheckPremiumAccess>((Ref ref) {
  return CheckPremiumAccess(ref.watch(subscriptionRepositoryProvider));
});

// ---------------------------------------------------------------------------
// State + controller
// ---------------------------------------------------------------------------

enum SubscriptionLoadStatus { initial, loading, ready, purchasing, restoring, error }

class SubscriptionState {
  const SubscriptionState({
    required this.status,
    required this.plans,
    required this.subscription,
    required this.isPremium,
    this.errorMessage,
    this.lastPurchase,
  });

  factory SubscriptionState.initial() {
    return const SubscriptionState(
      status: SubscriptionLoadStatus.initial,
      plans: <SubscriptionPlanEntity>[],
      subscription: null,
      isPremium: false,
    );
  }

  final SubscriptionLoadStatus status;
  final List<SubscriptionPlanEntity> plans;
  final SubscriptionEntity? subscription;
  final bool isPremium;
  final String? errorMessage;
  final PurchaseEntity? lastPurchase;

  SubscriptionState copyWith({
    SubscriptionLoadStatus? status,
    List<SubscriptionPlanEntity>? plans,
    SubscriptionEntity? subscription,
    bool? isPremium,
    String? errorMessage,
    bool clearError = false,
    PurchaseEntity? lastPurchase,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      plans: plans ?? this.plans,
      subscription: subscription ?? this.subscription,
      isPremium: isPremium ?? this.isPremium,
      errorMessage:
          clearError ? null : (errorMessage ?? this.errorMessage),
      lastPurchase: lastPurchase ?? this.lastPurchase,
    );
  }
}

class SubscriptionController extends StateNotifier<SubscriptionState> {
  SubscriptionController({
    required GetPlans getPlans,
    required GetCurrentSubscription getCurrentSubscription,
    required PurchaseSubscription purchaseSubscription,
    required RestorePurchases restorePurchases,
    required CancelSubscription cancelSubscription,
    required CheckPremiumAccess checkPremiumAccess,
  })  : _getPlans = getPlans,
        _getCurrentSubscription = getCurrentSubscription,
        _purchaseSubscription = purchaseSubscription,
        _restorePurchases = restorePurchases,
        _cancelSubscription = cancelSubscription,
        _checkPremiumAccess = checkPremiumAccess,
        super(SubscriptionState.initial());

  final GetPlans _getPlans;
  final GetCurrentSubscription _getCurrentSubscription;
  final PurchaseSubscription _purchaseSubscription;
  final RestorePurchases _restorePurchases;
  final CancelSubscription _cancelSubscription;
  final CheckPremiumAccess _checkPremiumAccess;

  Future<void> bootstrap() async {
    state = state.copyWith(status: SubscriptionLoadStatus.loading, clearError: true);
    try {
      final List<SubscriptionPlanEntity> plans = await _getPlans();
      final SubscriptionEntity current = await _getCurrentSubscription();
      final bool isPremium = await _checkPremiumAccess();
      state = state.copyWith(
        status: SubscriptionLoadStatus.ready,
        plans: plans,
        subscription: current,
        isPremium: isPremium,
      );
    } on Object catch (e) {
      state = state.copyWith(
        status: SubscriptionLoadStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refreshPlans() async {
    try {
      final List<SubscriptionPlanEntity> plans = await _getPlans();
      state = state.copyWith(plans: plans, clearError: true);
    } on Object catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Kicks off a purchase and refreshes the locally cached entitlement
  /// when the gateway reports success.
  Future<PurchaseEntity> purchase({
    required String planId,
    required String providerCode,
  }) async {
    state = state.copyWith(
      status: SubscriptionLoadStatus.purchasing,
      clearError: true,
    );
    try {
      final PurchaseEntity result = await _purchaseSubscription(
        planId: planId,
        providerCode: providerCode,
      );
      final SubscriptionEntity current = await _getCurrentSubscription();
      final bool isPremium = await _checkPremiumAccess();
      state = state.copyWith(
        status: SubscriptionLoadStatus.ready,
        subscription: current,
        isPremium: isPremium,
        lastPurchase: result,
      );
      return result;
    } on Object catch (e) {
      state = state.copyWith(
        status: SubscriptionLoadStatus.error,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<SubscriptionEntity> restore() async {
    state = state.copyWith(
      status: SubscriptionLoadStatus.restoring,
      clearError: true,
    );
    try {
      final SubscriptionEntity current = await _restorePurchases();
      final bool isPremium = await _checkPremiumAccess();
      state = state.copyWith(
        status: SubscriptionLoadStatus.ready,
        subscription: current,
        isPremium: isPremium,
      );
      return current;
    } on Object catch (e) {
      state = state.copyWith(
        status: SubscriptionLoadStatus.error,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<SubscriptionEntity> cancel() async {
    try {
      final SubscriptionEntity current = await _cancelSubscription();
      final bool isPremium = await _checkPremiumAccess();
      state = state.copyWith(
        subscription: current,
        isPremium: isPremium,
        clearError: true,
      );
      return current;
    } on Object catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      rethrow;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final StateNotifierProvider<SubscriptionController, SubscriptionState>
    subscriptionControllerProvider =
    StateNotifierProvider<SubscriptionController, SubscriptionState>((Ref ref) {
  return SubscriptionController(
    getPlans: ref.watch(getPlansUseCaseProvider),
    getCurrentSubscription:
        ref.watch(getCurrentSubscriptionUseCaseProvider),
    purchaseSubscription:
        ref.watch(purchaseSubscriptionUseCaseProvider),
    restorePurchases: ref.watch(restorePurchasesUseCaseProvider),
    cancelSubscription: ref.watch(cancelSubscriptionUseCaseProvider),
    checkPremiumAccess: ref.watch(checkPremiumAccessUseCaseProvider),
  );
});

/// Convenience selector so feature gates (e.g. AI tutor limit banner)
/// can read premium status without watching the entire controller.
final Provider<bool> isPremiumProvider = Provider<bool>((Ref ref) {
  return ref.watch(
    subscriptionControllerProvider.select(
      (SubscriptionState s) => s.isPremium,
    ),
  );
});