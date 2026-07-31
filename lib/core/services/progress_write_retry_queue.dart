import 'package:cloud_firestore/cloud_firestore.dart';

/// Payload key that marks a [PendingWrite] as targeting the coin
/// ledger (a `users/{uid}/coin_ledger/{txId}` doc) rather than the
/// default `progression/current` doc. Consumed by
/// [ProgressWriteRetryQueue.flush] to route the write correctly.
const String kLedgerMarker = '__coin_ledger__';

/// Holds a single pending Firestore write that failed at runtime (most
/// commonly because the device is offline). [UserProgressService]
/// enqueues every best-effort write that throws; the queue is
/// periodically flushed (typically from `bootstrap.dart` after a
/// connectivity change).
///
/// The queue keeps data in-memory only — persistence of pending writes
/// is out of scope for Phase 34, but the seam is in place so a Hive
/// box can back this in a future phase.
class ProgressWriteRetryQueue {
  ProgressWriteRetryQueue();

  final List<PendingWrite> _pending = <PendingWrite>[];

  bool get isEmpty => _pending.isEmpty;
  int get length => _pending.length;

  /// Append a failed write. The [path] argument is the full collection
  /// reference string so the queue can replay the exact same target.
  void enqueue(PendingWrite write) {
    if (write.payload.isEmpty) return;
    _pending.add(write);
  }

  /// Re-apply every queued write against [firestore]. Returns the
  /// number of writes that succeeded; the rest are kept in the queue
  /// for the next attempt. Coin-ledger writes (those carrying
  /// [kLedgerMarker] in their payload) are routed to the coin-ledger
  /// subcollection instead of the default `progression/current` doc.
  Future<int> flush(FirebaseFirestore firestore) async {
    if (_pending.isEmpty) return 0;
    int succeeded = 0;
    final List<PendingWrite> remaining = <PendingWrite>[];
    for (final PendingWrite write in _pending) {
      try {
        if (write.payload.containsKey(kLedgerMarker)) {
          final String collection =
              (write.payload['__collection__'] as String?) ?? write.collection;
          final String documentId =
              (write.payload['__txId__'] as String?) ?? write.documentId;
          final Map<String, dynamic> payload =
              Map<String, dynamic>.from(write.payload)
                ..remove(kLedgerMarker)
                ..remove('__collection__')
                ..remove('__txId__');
          await firestore
              .collection(collection)
              .doc(documentId)
              .set(payload, SetOptions(merge: true));
        } else {
          await firestore
              .collection(write.collection)
              .doc(write.documentId)
              .set(write.payload, SetOptions(merge: true));
        }
        succeeded += 1;
      } catch (_) {
        remaining.add(write);
      }
    }
    _pending
      ..clear()
      ..addAll(remaining);
    return succeeded;
  }

  void clear() => _pending.clear();
}

/// One pending Firestore write captured by [ProgressWriteRetryQueue].
class PendingWrite {
  const PendingWrite({
    required this.collection,
    required this.documentId,
    required this.payload,
  });

  final String collection;
  final String documentId;
  final Map<String, dynamic> payload;
}
