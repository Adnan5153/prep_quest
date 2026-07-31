import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../../core/constants/firestore_keys.dart';
import '../../../../core/errors/error_handler.dart';
import '../../domain/entities/coin_transaction.dart';

/// Persistence boundary for the `users/{uid}/coin_ledger/{txId}`
/// subcollection. The ledger is append-only: each [CoinService]
/// grant produces exactly one document, keyed by the
/// `{source}:{sourceId}` [CoinTransactionEntity.sourceKey].
abstract class CoinLedgerRepository {
  /// Subscribes to the latest [limit] transactions for [uid], ordered
  /// by `createdAt desc`. Emits an empty list when the subcollection
  /// does not exist yet. Errors surface as [CacheFailure].
  Stream<List<CoinTransactionEntity>> watch(String uid, {int limit = 50});

  /// One-shot read of the latest [limit] transactions for [uid].
  Future<List<CoinTransactionEntity>> list(String uid, {int limit = 50});

  /// Appends [entity] to the in-memory or Firestore-backed ledger.
  /// The Firestore implementation writes inside the caller's
  /// transaction via [DocumentReference] so the balance write and
  /// the ledger write commit together; the in-memory implementation
  /// stores the entity in a process-local map.
  Future<void> append({
    required String uid,
    required CoinTransactionEntity entity,
  });

  /// Returns a Firestore [DocumentReference] for the ledger doc the
  /// caller wants to write inside an existing transaction. Only
  /// meaningful for the Firestore implementation; the in-memory
  /// repo throws.
  DocumentReference<Map<String, dynamic>> referenceFor({
    required String uid,
    required String transactionId,
  });
}

/// Firestore-backed [CoinLedgerRepository]. Selected when
/// [FirebaseConfig.isPlatformConfigured] is `true`.
class FirestoreCoinLedgerRepositoryImpl implements CoinLedgerRepository {
  const FirestoreCoinLedgerRepositoryImpl(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _ledger(String uid) {
    return _firestore
        .collection(FirestoreKeys.users)
        .doc(uid)
        .collection(FirestoreKeys.coinLedgerSubcollection);
  }

  @override
  Stream<List<CoinTransactionEntity>> watch(String uid, {int limit = 50}) {
    return _ledger(uid)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (QuerySnapshot<Map<String, dynamic>> snapshot) =>
              snapshot.docs
                  .map(
                    (QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                        CoinTransactionEntity.fromMap(<String, dynamic>{
                      ...doc.data(),
                      'id': doc.id,
                    }),
                  )
                  .toList(growable: false),
        )
        .handleError(
          (Object error, StackTrace stackTrace) => throw ErrorHandler.map(
            error,
            stackTrace,
          ),
        );
  }

  @override
  Future<List<CoinTransactionEntity>> list(String uid, {int limit = 50}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _ledger(uid)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs
          .map(
            (QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                CoinTransactionEntity.fromMap(<String, dynamic>{
              ...doc.data(),
              'id': doc.id,
            }),
          )
          .toList(growable: false);
    } catch (error, stackTrace) {
      throw ErrorHandler.map(error, stackTrace);
    }
  }

  @override
  Future<void> append({
    required String uid,
    required CoinTransactionEntity entity,
  }) async {
    try {
      final DocumentReference<Map<String, dynamic>> ref = _ledger(uid)
          .doc(entity.id.isEmpty ? null : entity.id);
      await ref.set(entity.toMap(), SetOptions(merge: true));
    } catch (error, stackTrace) {
      throw ErrorHandler.map(error, stackTrace);
    }
  }

  @override
  DocumentReference<Map<String, dynamic>> referenceFor({
    required String uid,
    required String transactionId,
  }) {
    return _ledger(uid).doc(transactionId.isEmpty ? null : transactionId);
  }
}

/// In-memory [CoinLedgerRepository] used when the platform is not
/// configured for Firebase (offline dev, tests) and as a baseline
/// before any authenticated session lands. Emits through [controller]
/// so providers wired to this repo receive realtime updates without
/// depending on Firestore.
class InMemoryCoinLedgerRepository implements CoinLedgerRepository {
  InMemoryCoinLedgerRepository();

  final Map<String, List<CoinTransactionEntity>> _byUid =
      <String, List<CoinTransactionEntity>>{};
  final Map<String, StreamController<List<CoinTransactionEntity>>>
      _controllers = <String, StreamController<List<CoinTransactionEntity>>>{};

  StreamController<List<CoinTransactionEntity>> _controller(String uid) {
    return _controllers.putIfAbsent(
      uid,
      () => StreamController<List<CoinTransactionEntity>>.broadcast(),
    );
  }

  List<CoinTransactionEntity> _snapshot(String uid) {
    final List<CoinTransactionEntity> entries =
        List<CoinTransactionEntity>.from(_byUid[uid] ?? const <CoinTransactionEntity>[]);
    entries.sort(
      (CoinTransactionEntity a, CoinTransactionEntity b) =>
          b.createdAt.compareTo(a.createdAt),
    );
    return entries;
  }

  @override
  Stream<List<CoinTransactionEntity>> watch(String uid, {int limit = 50}) {
    return _controller(uid).stream.map(
          (List<CoinTransactionEntity> entries) =>
              entries.length > limit ? entries.sublist(0, limit) : entries,
        );
  }

  @override
  Future<List<CoinTransactionEntity>> list(String uid, {int limit = 50}) async {
    final List<CoinTransactionEntity> entries = _snapshot(uid);
    return entries.length > limit ? entries.sublist(0, limit) : entries;
  }

  @override
  Future<void> append({
    required String uid,
    required CoinTransactionEntity entity,
  }) async {
    final List<CoinTransactionEntity> existing =
        List<CoinTransactionEntity>.from(_byUid[uid] ?? <CoinTransactionEntity>[]);
    existing.add(entity);
    _byUid[uid] = existing;
    _controller(uid).add(_snapshot(uid));
  }

  @override
  DocumentReference<Map<String, dynamic>> referenceFor({
    required String uid,
    required String transactionId,
  }) {
    throw UnsupportedError(
      'In-memory ledger cannot be used inside a Firestore transaction.',
    );
  }

  void close() {
    for (final StreamController<List<CoinTransactionEntity>> c
        in _controllers.values) {
      c.close();
    }
    _controllers.clear();
    _byUid.clear();
  }
}
