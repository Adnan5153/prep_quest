import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../../core/constants/firestore_keys.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';
import '../../../authentication/presentation/states/auth_state.dart';

/// Bridges auth-driven identity changes (display name, photo URL,
/// email, email verification, role) into the `users/{uid}/profile/current`
/// Firestore document that the Profile feature reads from.
///
/// The Profile screen subscribes to that document via its realtime
/// stream, so once we merge the auth identity fields in, every
/// Profile widget (avatar, header, badges) updates instantly without
/// any extra plumbing. Existing progress fields (XP / coins / level /
/// streak) are never overwritten because every write uses
/// `SetOptions(merge: true)`.
class UserProfileSyncService {
  UserProfileSyncService(this._ref);

  final Ref _ref;

  ProviderSubscription<AuthState>? _authSubscription;
  UserEntity? _lastSynced;

  void start() {
    _authSubscription ??= _ref.listen<AuthState>(
      authStateProvider,
      (AuthState? previous, AuthState next) {
        final UserEntity? user = next.user;
        if (user == null) return;
        if (_lastSynced != null &&
            _lastSynced!.id == user.id &&
            _lastSynced!.displayName == user.displayName &&
            _lastSynced!.email == user.email &&
            _lastSynced!.emailVerified == user.emailVerified &&
            _lastSynced!.photoUrl == user.photoUrl &&
            _lastSynced!.role == user.role &&
            _lastSynced!.district == user.district &&
            _lastSynced!.phoneNumber == user.phoneNumber) {
          return;
        }
        _lastSynced = user;
        _syncIdentity(user);
      },
    );
  }

  Future<void> _syncIdentity(UserEntity user) async {
    if (!FirebaseConfig.isPlatformConfigured) return;
    final FirebaseFirestore? firestore = FirebaseConfig.firestore;
    if (firestore == null) return;
    try {
      await firestore
          .collection(FirestoreKeys.users)
          .doc(user.id)
          .collection(FirestoreKeys.profileSubcollection)
          .doc('current')
          .set(_identityPatch(user), SetOptions(merge: true));
    } catch (_) {/* best-effort — profile fallback still works */}
  }

  Map<String, dynamic> _identityPatch(UserEntity user) {
    final String now = DateTime.now().toUtc().toIso8601String();
    return <String, dynamic>{
      'uid': user.id,
      'email': user.email,
      'displayName': user.displayName,
      'emailVerified': user.emailVerified,
      'phoneNumber': user.phoneNumber,
      'photoUrl': user.photoUrl,
      'examTrackId': user.examTrack.id,
      'role': user.role.id,
      'district': user.district,
      'lastLogin': now,
      'lastSignInAt': now,
      'updatedAt': now,
    };
  }
}

final userProfileSyncServiceProvider =
    Provider<UserProfileSyncService>((ref) {
  final UserProfileSyncService service = UserProfileSyncService(ref);
  service.start();
  return service;
});
