import 'dart:async';

import '../../domain/entities/user_entity.dart';

/// Contract for the canonical `users/{uid}` Firestore document.
///
/// Centralises every write that touches the top-level user record so
/// the auth feature, profile feature, and any future Cloud Function
/// call-site share the same merge-update semantics. Implementations
/// must be idempotent — re-running [ensureUserDocument] on an
/// existing account never overwrites progress fields.
abstract class UserRemoteDataSource {
  /// Seeds the document if it does not exist, otherwise applies a
  /// merge-update of the supplied fields. Returns the canonical user
  /// model after the write completes.
  Future<UserEntity> ensureUserDocument({
    required String uid,
    required Map<String, dynamic> seed,
    required Map<String, dynamic> merge,
  });

  /// Merge-only update. Skips the seed branch so existing progress
  /// counters (XP / coins / level / streak) are preserved.
  Future<void> mergeUserDocument({
    required String uid,
    required Map<String, dynamic> patch,
  });

  /// Realtime stream of the user document. Emits `null` when the
  /// document is missing so callers can fall back to the auth layer.
  Stream<UserEntity?> watchUser(String uid);

  /// One-shot fetch of the user document.
  Future<UserEntity?> fetchUser(String uid);
}
