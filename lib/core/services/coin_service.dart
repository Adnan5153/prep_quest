import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/authentication/presentation/providers/auth_providers.dart';
import '../../features/authentication/presentation/states/auth_state.dart';
import '../../features/profile/domain/entities/coin_transaction.dart';
import '../../features/profile/domain/entities/user_profile.dart';
import '../../features/profile/presentation/controllers/profile_controller.dart';
import '../../features/profile/presentation/providers/profile_providers.dart';
import '../../features/profile/presentation/states/profile_state.dart';
import '../../shared/typedefs/result.dart';
import '../config/firebase_config.dart';
import '../constants/firestore_keys.dart';
import '../errors/error_handler.dart';
import '../errors/failures.dart';
import 'progress_write_retry_queue.dart';
import 'user_progress_service.dart';

/// Authoritative writer for the user's coin balance.
///
/// Every coin delta — quiz reward, daily login, mission, level-up
/// bonus, chest, achievement, badge, refund — flows through this
/// service so the dual-counter problem from Phase 39 (where the
/// gamification engine mutated `UserRewardsState.totalCoins` in
/// parallel with `ProgressionEntity.coins`) cannot recur. Phase 41
/// collapses to a single canonical balance stored on
/// `users/{uid}/progression/current.coins` and an append-only ledger
/// on `users/{uid}/coin_ledger/{txId}`.
///
/// All transactions are keyed by `"{source}:{sourceId}"` so replays,
/// retries, and double-fired listeners cannot double-credit. The
/// ledger write and the balance write commit inside one Firestore
/// transaction; on offline failure the retry queue catches both
/// payloads (the queue routes ledger docs by [kLedgerMarker]).
class CoinService {
  CoinService(this._ref);

  final Ref _ref;

  /// Reads the canonical coin balance from the in-memory profile.
  /// Returns `0` if no profile has been loaded yet.
  int balance() {
    final UserProfile? profile = _ref.read(profileControllerProvider).profile;
    return profile?.progression.coins ?? 0;
  }

  /// Live stream of the user's coin balance. Re-emits whenever the
  /// profile controller updates the progression document. Consumers
  /// should prefer the `coinBalanceProvider` selector over calling
  /// this directly — the provider wiring avoids the lifecycle gotchas
  /// of subscribing to a `StateNotifier` from outside `ref.listen`.
  Stream<int> watchBalance() {
    final ProfileController controller =
        _ref.read(profileControllerProvider.notifier);
    return controller.stream.map(
      (ProfileState state) => state.profile?.progression.coins ?? 0,
    );
  }

  /// Credits the user's balance by [amount] from a non-quiz source.
  /// Honours dedup via [CoinTransactionEntity.sourceKey] so a re-fire
  /// from a synchronously-mounted listener or a queued replay cannot
  /// double-credit.
  Future<Result<CoinTransactionEntity>> grant({
    required CoinTransactionSource source,
    required String sourceId,
    required int amount,
    String? reason,
    Map<String, dynamic>? metadata,
    CoinTransactionType type = CoinTransactionType.reward,
  }) async {
    if (amount <= 0) {
      return Result<CoinTransactionEntity>.failure(
        const ValidationFailure('Grant amount must be positive.'),
      );
    }
    final String? uid = _activeUid();
    final CoinTransactionEntity seed = CoinTransactionEntity(
      id: '',
      uid: uid ?? '',
      type: type,
      source: source,
      sourceId: sourceId,
      amount: amount,
      balanceAfter: 0,
      reason: reason,
      metadata: metadata ?? const <String, dynamic>{},
      createdAt: DateTime.now().toUtc(),
    );
    if (_isGuest()) {
      return _grantGuest(seed);
    }
    if (uid == null) {
      return Result<CoinTransactionEntity>.failure(
        const AuthenticationFailure('No active user.'),
      );
    }
    if (!FirebaseConfig.isPlatformConfigured) {
      return _grantGuest(seed, uid: uid);
    }
    final FirebaseFirestore? firestore = FirebaseConfig.firestore;
    if (firestore == null) {
      return _grantGuest(seed, uid: uid);
    }
    return _grantAuthenticated(uid: uid, firestore: firestore, seed: seed);
  }

  /// Debits the user's balance by [amount]. Rejects overspend with
  /// [InsufficientCoinsFailure]. Honours the same dedup invariants as
  /// [grant] by treating each spend as a fresh
  /// `spend:{source}:{sourceId}` ledger entry.
  Future<Result<CoinTransactionEntity>> spend({
    required CoinTransactionSource source,
    required String sourceId,
    required int amount,
    String? reason,
    Map<String, dynamic>? metadata,
  }) async {
    if (amount <= 0) {
      return Result<CoinTransactionEntity>.failure(
        const ValidationFailure('Spend amount must be positive.'),
      );
    }
    final int currentBalance = balance();
    if (currentBalance < amount) {
      return Result<CoinTransactionEntity>.failure(
        InsufficientCoinsFailure(
          'Not enough coins to complete this action.',
          shortfall: amount - currentBalance,
        ),
      );
    }
    final CoinTransactionEntity seed = CoinTransactionEntity(
      id: '',
      uid: _activeUid() ?? '',
      type: CoinTransactionType.spend,
      source: source,
      sourceId: sourceId,
      amount: amount,
      balanceAfter: 0,
      reason: reason,
      metadata: metadata ?? const <String, dynamic>{},
      createdAt: DateTime.now().toUtc(),
    );
    final String? uid = _activeUid();
    if (_isGuest() || uid == null) {
      return _grantGuest(seed);
    }
    if (!FirebaseConfig.isPlatformConfigured) {
      return _grantGuest(seed, uid: uid);
    }
    final FirebaseFirestore? firestore = FirebaseConfig.firestore;
    if (firestore == null) {
      return _grantGuest(seed, uid: uid);
    }
    return _grantAuthenticated(uid: uid, firestore: firestore, seed: seed);
  }

  /// Credits back a previously-spent amount. Uses
  /// `refund:{sourceId}` so the same refund cannot be applied twice.
  Future<Result<CoinTransactionEntity>> refund({
    required CoinTransactionSource source,
    required String sourceId,
    required int amount,
    String? reason,
    Map<String, dynamic>? metadata,
  }) {
    return grant(
      source: source,
      sourceId: 'refund:$sourceId',
      amount: amount,
      reason: reason ?? 'Refund',
      metadata: metadata,
      type: CoinTransactionType.refund,
    );
  }

  /// Phase 42 hook — replay any queued guest grants that were made
  /// before the user signed in with a real Firebase identity.
  /// Currently a no-op stub; Phase 42 wires the real upgrade flow.
  Future<void> replayQueuedGuestGrants(String uid) async {
    if (kDebugMode) {
      debugPrint(
        '[CoinService] replayQueuedGuestGrants($uid) is a Phase 42 hook.',
      );
    }
  }

  /// Performs the credit inside a single Firestore transaction so
  /// the balance doc and the ledger doc commit together. Exposed
  /// (package-internal) so `UserProgressService._transactionalProgression`
  /// can include a quiz reward inside its existing transaction.
  Future<CoinTransactionEntity> runGrantInTransaction({
    required Transaction tx,
    required DocumentReference<Map<String, dynamic>> progressionRef,
    required DocumentReference<Map<String, dynamic>> ledgerRef,
    required CoinTransactionEntity seed,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>> progressionSnap =
        await tx.get(progressionRef);
    final Map<String, dynamic> progressionData =
        progressionSnap.data() ?? <String, dynamic>{};
    final int existingCoins =
        (progressionData['coins'] as num?)?.toInt() ?? 0;
    final QuerySnapshot<Map<String, dynamic>> dedup = await ledgerRef.parent
        .where('sourceKey', isEqualTo: seed.sourceKey)
        .limit(1)
        .get();
    if (dedup.docs.isNotEmpty) {
      throw DuplicateRewardFailure(
        'Reward already applied for ${seed.sourceKey}.',
        sourceKey: seed.sourceKey,
      );
    }
    final int signedDelta = seed.signedDelta;
    final int newBalance = (existingCoins + signedDelta).clamp(0, 1 << 31);
    tx.set(
      progressionRef,
      <String, dynamic>{
        'coins': newBalance,
        'lastUpdatedAt': DateTime.now().toUtc().toIso8601String(),
      },
      SetOptions(merge: true),
    );
    final CoinTransactionEntity committed = CoinTransactionEntity(
      id: ledgerRef.id,
      uid: seed.uid,
      type: seed.type,
      source: seed.source,
      sourceId: seed.sourceId,
      amount: seed.amount,
      balanceAfter: newBalance,
      reason: seed.reason,
      metadata: seed.metadata,
      createdAt: seed.createdAt,
    );
    tx.set(ledgerRef, committed.toMap(), SetOptions(merge: true));
    return committed;
  }

  Future<Result<CoinTransactionEntity>> _grantAuthenticated({
    required String uid,
    required FirebaseFirestore firestore,
    required CoinTransactionEntity seed,
  }) async {
    try {
      final DocumentReference<Map<String, dynamic>> progressionRef =
          firestore
              .collection(FirestoreKeys.users)
              .doc(uid)
              .collection(FirestoreKeys.progressionSubcollection)
              .doc(FirestoreKeys.currentDocId);
      final DocumentReference<Map<String, dynamic>> ledgerRef = firestore
          .collection(FirestoreKeys.users)
          .doc(uid)
          .collection(FirestoreKeys.coinLedgerSubcollection)
          .doc();
      final CoinTransactionEntity committed =
          await firestore.runTransaction<CoinTransactionEntity>(
        (Transaction tx) async {
          return runGrantInTransaction(
            tx: tx,
            progressionRef: progressionRef,
            ledgerRef: ledgerRef,
            seed: seed,
          );
        },
      );
      _mirrorLocally(committed);
      return Result<CoinTransactionEntity>.success(committed);
    } on DuplicateRewardFailure catch (failure) {
      return Result<CoinTransactionEntity>.failure(failure);
    } catch (error, stackTrace) {
      _enqueueRetry(uid, seed);
      return Result<CoinTransactionEntity>.failure(
        ErrorHandler.map(error, stackTrace),
      );
    }
  }

  Result<CoinTransactionEntity> _grantGuest(
    CoinTransactionEntity seed, {
    String? uid,
  }) {
    final int nextBalance =
        (balance() + seed.signedDelta).clamp(0, 1 << 31);
    final CoinTransactionEntity committed = CoinTransactionEntity(
      id: _localId(seed),
      uid: uid ?? seed.uid,
      type: seed.type,
      source: seed.source,
      sourceId: seed.sourceId,
      amount: seed.amount,
      balanceAfter: nextBalance,
      reason: seed.reason,
      metadata: seed.metadata,
      createdAt: seed.createdAt,
    );
    _mirrorLocally(committed);
    return Result<CoinTransactionEntity>.success(committed);
  }

  void _mirrorLocally(CoinTransactionEntity committed) {
    final ProfileController controller =
        _ref.read(profileControllerProvider.notifier);
    final UserProfile? current = _ref.read(profileControllerProvider).profile;
    if (current == null) return;
    final ProgressionEntity nextProgression = current.progression.copyWith(
      coins: committed.balanceAfter,
    );
    controller.replaceLocalProfile(current.copyWith(progression: nextProgression));
  }

  void _enqueueRetry(String uid, CoinTransactionEntity seed) {
    final String txId = _localId(seed);
    _ref.read(userProgressServiceProvider).retryQueue.enqueue(
          PendingWrite(
            collection: '${FirestoreKeys.users}/$uid'
                '/${FirestoreKeys.coinLedgerSubcollection}',
            documentId: txId,
            payload: <String, dynamic>{
              kLedgerMarker: true,
              '__collection__':
                  '${FirestoreKeys.users}/$uid'
                      '/${FirestoreKeys.coinLedgerSubcollection}',
              '__txId__': txId,
              ...seed.toMap(),
            },
          ),
        );
  }

  String _localId(CoinTransactionEntity seed) {
    return '${seed.source.id}-${seed.sourceId}'
        '-${seed.createdAt.microsecondsSinceEpoch}';
  }

  bool _isGuest() {
    final AuthState auth = _ref.read(authStateProvider);
    if (!auth.isAuthenticated) return true;
    final String id = auth.user?.id ?? '';
    final String email = auth.user?.email ?? '';
    return id.isEmpty || email.isEmpty;
  }

  String? _activeUid() {
    final AuthState auth = _ref.read(authStateProvider);
    final String id = auth.user?.id ?? '';
    return id.isEmpty ? null : id;
  }
}
