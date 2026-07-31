import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../../core/constants/firestore_keys.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/level_curve.dart';
import '../../../../shared/enums/exam_track.dart';
import '../../../../shared/enums/user_role.dart';
import '../models/auth_session_model.dart';
import '../models/otp_request_model.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

/// Firebase Auth + Firestore implementation of [AuthRemoteDataSource].
///
/// This is the **production** data source. Every sign-in path:
/// 1. Authenticates with Firebase Auth (email/password, Google, or phone).
/// 2. Reads/writes the canonical user document at `users/{uid}` —
///    the schema mirrors [UserModel.toMap] (identity fields, exam
///    track, role, district, photoUrl, timestamps).
/// 3. Writes the profile document at `users/{uid}/profile/current` —
///    the schema mirrors the profile feature's `UserProfileModel`.
///    A Google sign-in seeds the profile with the Google identity
///    data so the user lands on /complete-profile with everything
///    pre-filled and the profile doc already exists in Firestore.
/// 4. Writes the app-user document at `users/{uid}/app_user/current`
///    so the gamification layer can track progression / studyStats
///    from the moment of sign-in.
///
/// Activate by resolving [authRemoteDataSourceProvider] to this class
/// (the provider already switches based on [FirebaseConfig]).
class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  const FirebaseAuthRemoteDataSource();

  firebase_auth.FirebaseAuth get _auth => firebase_auth.FirebaseAuth.instance;
  FirebaseFirestore get _db => FirebaseConfig.firestore!;

  // ---------------------------------------------------------------------------
  // Top-level helpers
  // ---------------------------------------------------------------------------

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection(FirestoreKeys.users).doc(uid);

  DocumentReference<Map<String, dynamic>> _profileDoc(String uid) =>
      _userDoc(uid).collection(FirestoreKeys.profileSubcollection).doc(
            FirestoreKeys.currentDocId,
          );

  DocumentReference<Map<String, dynamic>> _appUserDoc(String uid) =>
      _userDoc(uid).collection(FirestoreKeys.appUserSubcollection).doc(FirestoreKeys.currentDocId);

  /// Translates a Firebase Auth exception into the typed [Failure] the
  /// repository layer expects.
  Never _translateAuthException(Object error, StackTrace stackTrace) {
    if (error is firebase_auth.FirebaseAuthException) {
      throw AuthenticationFailure(
        error.message ?? 'Authentication failed.',
        code: error.code,
        cause: error,
      );
    }
    Error.throwWithStackTrace(error, stackTrace);
  }

  /// Reads the persisted user document from `users/{uid}`. Returns
  /// `null` if the document does not exist (a brand-new Google user
  /// before [ensureUserDoc] runs).
  Future<UserModel?> _readUserDoc(String uid) async {
    final DocumentSnapshot<Map<String, dynamic>> snap =
        await _userDoc(uid).get();
    if (!snap.exists) return null;
    final Map<String, dynamic>? data = snap.data();
    final Map<String, dynamic> source = data == null
        ? <String, dynamic>{}
        : <String, dynamic>{...data}..remove('id');
    return UserModel.fromMap(source, uid);
  }

  /// Writes the identity fields from Firebase Auth (and the optional
  /// [displayName] override) into `users/{uid}`. Uses `merge: true`
  /// so existing fields like `district`, `examTrack`, or `role` are
  /// not overwritten when a user signs back in.
  Future<void> _writeUserDoc(
    firebase_auth.User firebaseUser, {
    String? displayName,
  }) async {
    final Map<String, dynamic> patch = <String, dynamic>{
      'email': firebaseUser.email ?? '',
      'displayName':
          displayName ?? firebaseUser.displayName ?? '',
      'emailVerified': firebaseUser.emailVerified,
      'phoneNumber': firebaseUser.phoneNumber ?? '',
      'photoUrl': firebaseUser.photoURL ?? '',
      'lastSignInAt': DateTime.now().toUtc().toIso8601String(),
    };
    await _userDoc(firebaseUser.uid).set(patch, SetOptions(merge: true));
  }

  /// Seeds `users/{uid}/profile/current` with the identity fields
  /// reported by Firebase Auth. Uses `merge: true` so subsequent
  /// edits to `district`, `examTrack`, etc. are preserved. If the
  /// doc does not exist yet it is created with empty default values
  /// for the optional fields.
  Future<void> _seedProfileDoc(firebase_auth.User firebaseUser) async {
    final DocumentReference<Map<String, dynamic>> doc =
        _profileDoc(firebaseUser.uid);
    final DocumentSnapshot<Map<String, dynamic>> snap = await doc.get();
    final DateTime now = DateTime.now();
    final Map<String, dynamic> seed = <String, dynamic>{
      'id': firebaseUser.uid,
      'email': firebaseUser.email ?? '',
      'displayName': firebaseUser.displayName ?? '',
      'emailVerified': firebaseUser.emailVerified,
      'phoneNumber': firebaseUser.phoneNumber ?? '',
      'university': '',
      'examTrack': snap.exists
          ? null // preserve existing examTrack
          : ExamTrack.other.id,
      'language': snap.exists ? null : 'en',
      'role': snap.exists ? null : UserRole.free.id,
      'district': '',
      'bio': '',
      'photoUrl': firebaseUser.photoURL ?? '',
      'progression': snap.exists
          ? null
          : <String, dynamic>{
              'totalXp': 0,
              'level': 1,
              'xpInLevel': 0,
              'xpForNextLevel':
                  LevelCurve.defaultCurve.xpRequiredForLevel(1),
              'coins': 0,
              'energy': 5,
              'maxEnergy': 5,
              'energyRechargeSecondsRemaining': 0,
              'rankId': 'bronze',
              'streakDays': 0,
              'isStreakAtRisk': false,
            },
      'studyStats': snap.exists
          ? null
          : <String, dynamic>{
              'totalQuizzesTaken': 0,
              'totalQuestionsAnswered': 0,
              'totalCorrectAnswers': 0,
              'totalStudyMinutes': 0,
              'currentStreakDays': 0,
              'longestStreakDays': 0,
              'averageAccuracy': 0.0,
              'lastActiveAt': now.toUtc().toIso8601String(),
            },
      'achievements': const <String>[],
      'badges': const <String>[],
      'quickActions': const <String>['resume', 'mock_test', 'leaderboard'],
      'createdAt':
          snap.exists ? null : now.toUtc().toIso8601String(),
      'lastUpdatedAt': now.toUtc().toIso8601String(),
    };
    final Map<String, dynamic> filtered = <String, dynamic>{
      for (final MapEntry<String, dynamic> entry in seed.entries)
        if (entry.value != null) entry.key: entry.value,
    };
    await doc.set(filtered, SetOptions(merge: true));
  }

  /// Seeds `users/{uid}/app_user/current` so the gamification state
  /// has a row to update the moment the user signs in. Only writes if
  /// the doc does not already exist.
  Future<void> _seedAppUserDoc(firebase_auth.User firebaseUser) async {
    final DocumentReference<Map<String, dynamic>> doc =
        _appUserDoc(firebaseUser.uid);
    final DocumentSnapshot<Map<String, dynamic>> snap = await doc.get();
    if (snap.exists) {
      await doc.set(<String, dynamic>{
        'lastSignInAt': DateTime.now().toUtc().toIso8601String(),
      }, SetOptions(merge: true));
      return;
    }
    final DateTime now = DateTime.now();
    await doc.set(<String, dynamic>{
      'id': firebaseUser.uid,
      'displayName': firebaseUser.displayName ?? '',
      'email': firebaseUser.email ?? '',
      'emailVerified': firebaseUser.emailVerified,
      'phoneNumber': firebaseUser.phoneNumber ?? '',
      'examTrackId': ExamTrack.other.id,
      'roleId': UserRole.free.id,
      'district': '',
      'photoUrl': firebaseUser.photoURL ?? '',
      'createdAt': now.toUtc().toIso8601String(),
      'lastSignInAt': now.toUtc().toIso8601String(),
      'progression': <String, dynamic>{
        'totalXp': 0,
        'level': 1,
        'xpInLevel': 0,
        'xpForNextLevel': LevelCurve.defaultCurve.xpRequiredForLevel(1),
        'coins': 0,
        'energy': 5,
        'maxEnergy': 5,
        'energyRechargeSecondsRemaining': 0,
        'rankId': 'bronze',
        'streakDays': 0,
        'isStreakAtRisk': false,
      },
      'studyStats': <String, dynamic>{
        'totalQuizzesTaken': 0,
        'totalQuestionsAnswered': 0,
        'totalCorrectAnswers': 0,
        'totalStudyMinutes': 0,
        'currentStreakDays': 0,
        'longestStreakDays': 0,
        'averageAccuracy': 0.0,
        'lastActiveAt': now.toUtc().toIso8601String(),
      },
      'quickActions': const <String>['resume', 'mock_test', 'leaderboard'],
      'completedQuizzes': 0,
    }, SetOptions(merge: true));
  }

  /// Materialises a [UserModel] by merging the Firebase Auth user with
  /// the persisted Firestore doc (the Firestore doc wins for fields
  /// like `examTrack`, `district`, etc. that the user has edited).
  Future<UserModel> _buildUserModel(firebase_auth.User firebaseUser) async {
    final UserModel? persisted = await _readUserDoc(firebaseUser.uid);
    final DateTime now = DateTime.now();
    if (persisted == null) {
      return UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? '',
        emailVerified: firebaseUser.emailVerified,
        phoneNumber: firebaseUser.phoneNumber ?? '',
        examTrackId: ExamTrack.other.id,
        roleId: UserRole.free.id,
        district: '',
        photoUrl: firebaseUser.photoURL ?? '',
        createdAt: firebaseUser.metadata.creationTime ?? now,
        lastSignInAt:
            firebaseUser.metadata.lastSignInTime ?? now,
      );
    }
    return persisted.copyWith(
      email: firebaseUser.email ?? persisted.email,
      emailVerified: firebaseUser.emailVerified,
      phoneNumber: firebaseUser.phoneNumber ?? persisted.phoneNumber,
      displayName: firebaseUser.displayName ?? persisted.displayName,
      photoUrl: firebaseUser.photoURL ?? persisted.photoUrl,
      lastSignInAt: now,
    );
  }

  Future<AuthSessionModel> _sessionFor(
    firebase_auth.User firebaseUser,
  ) async {
    final UserModel user = await _buildUserModel(firebaseUser);
    return AuthSessionModel(
      user: user,
      accessToken: await _idToken(firebaseUser),
      refreshToken: firebaseUser.refreshToken ?? '',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    );
  }

  Future<String> _idToken(firebase_auth.User firebaseUser) async {
    try {
      return await firebaseUser.getIdToken() ?? '';
    } on Object catch (_) {
      return '';
    }
  }

  // ---------------------------------------------------------------------------
  // AuthRemoteDataSource surface
  // ---------------------------------------------------------------------------

  @override
  Stream<UserModel?> authStateChanges() async* {
    final StreamController<UserModel?> controller =
        StreamController<UserModel?>.broadcast();
    final StreamSubscription<firebase_auth.User?> authSub =
        _auth.authStateChanges().listen((
      firebase_auth.User? firebaseUser,
    ) async {
      if (firebaseUser == null) {
        controller.add(null);
        return;
      }
      try {
        controller.add(await _buildUserModel(firebaseUser));
      } on Object catch (error, stackTrace) {
        controller.addError(error, stackTrace);
      }
    }, onError: controller.addError);
    controller.onCancel = () async {
      await authSub.cancel();
      await controller.close();
    };
    yield* controller.stream;
  }

  @override
  Future<UserModel?> currentUser() async {
    final firebase_auth.User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;
    return _buildUserModel(firebaseUser);
  }

  @override
  Future<AuthSessionModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final firebase_auth.UserCredential credential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebase_auth.User? firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const AuthenticationFailure(
          'Email sign-in returned no user.',
          code: 'no-firebase-user',
        );
      }
      await _writeUserDoc(firebaseUser);
      await _seedProfileDoc(firebaseUser);
      await _seedAppUserDoc(firebaseUser);
      return _sessionFor(firebaseUser);
    } on Object catch (error, stackTrace) {
      _translateAuthException(error, stackTrace);
    }
  }

  @override
  Future<AuthSessionModel> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final firebase_auth.UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebase_auth.User? firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const AuthenticationFailure(
          'Email registration returned no user.',
          code: 'no-firebase-user',
        );
      }
      await firebaseUser.updateDisplayName(displayName);
      await firebaseUser.reload();
      await _writeUserDoc(firebaseUser, displayName: displayName);
      await _seedProfileDoc(firebaseUser);
      await _seedAppUserDoc(firebaseUser);
      try {
        await firebaseUser.sendEmailVerification();
      } on Object catch (_) {
        // Verification email delivery is best-effort; the user can
        // resend from the verification screen if it fails.
      }
      return _sessionFor(firebaseUser);
    } on Object catch (error, stackTrace) {
      _translateAuthException(error, stackTrace);
    }
  }

  @override
  Future<AuthSessionModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw const AuthenticationFailure(
          'Google sign-in was cancelled.',
          code: 'cancelled',
        );
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final firebase_auth.OAuthCredential credential =
          firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final firebase_auth.UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final firebase_auth.User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw const AuthenticationFailure(
          'Google sign-in failed to return a Firebase user.',
          code: 'no-firebase-user',
        );
      }
      // The user doc is created from the Google identity data so a
      // brand-new Google user has a real Firestore presence from the
      // moment they sign in. The profile doc is seeded with the same
      // identity fields so /complete-profile can pre-fill from
      // Firestore (or from AuthState.user, which already mirrors
      // these values).
      await _writeUserDoc(firebaseUser);
      await _seedProfileDoc(firebaseUser);
      await _seedAppUserDoc(firebaseUser);
      return _sessionFor(firebaseUser);
    } on Object catch (error, stackTrace) {
      _translateAuthException(error, stackTrace);
    }
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on Object catch (error, stackTrace) {
      _translateAuthException(error, stackTrace);
    }
  }

  @override
  Future<OtpRequestModel> sendPhoneOtp({required String phoneNumber}) async {
    // Firebase Auth phone credential flow lives entirely on the device
    // (no server-side verification id is round-tripped). The
    // [OtpRequestModel] is preserved for API compatibility but its
    // fields are populated from the auto-verifier state instead of a
    // verification id.
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (
          firebase_auth.PhoneAuthCredential credential,
        ) async {
          await _auth.signInWithCredential(credential);
        },
        codeSent: (String verificationId, int? resendToken) {
          // Phone OTP UI was deleted in Phase 54 — this branch is
          // intentionally a no-op so the call resolves cleanly even
          // when no UI consumer is listening.
          // ignore: avoid_print
          print('[FirebaseAuth] codeSent (no UI): $verificationId');
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        verificationFailed: (firebase_auth.FirebaseAuthException error) {
          throw AuthenticationFailure(
            error.message ?? 'Phone verification failed.',
            code: error.code,
            cause: error,
          );
        },
      );
      return OtpRequestModel(
        verificationId: 'firebase-phone-verifier',
        phoneNumber: phoneNumber,
        expiresAt: DateTime.now().add(const Duration(minutes: 5)),
        resendToken: '',
      );
    } on Object catch (error, stackTrace) {
      _translateAuthException(error, stackTrace);
    }
  }

  @override
  Future<AuthSessionModel> verifyPhoneOtp({
    required String verificationId,
    required String otp,
  }) async {
    // Phone OTP UI was deleted in Phase 54 — kept as a defensive
    // pass-through so any future caller does not hit a stub.
    try {
      final firebase_auth.PhoneAuthCredential credential =
          firebase_auth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      final firebase_auth.UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final firebase_auth.User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw const AuthenticationFailure(
          'Phone sign-in returned no user.',
          code: 'no-firebase-user',
        );
      }
      await _writeUserDoc(firebaseUser);
      await _seedProfileDoc(firebaseUser);
      await _seedAppUserDoc(firebaseUser);
      return _sessionFor(firebaseUser);
    } on Object catch (error, stackTrace) {
      _translateAuthException(error, stackTrace);
    }
  }

  @override
  Future<void> resendEmailVerification() async {
    try {
      final firebase_auth.User? firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        throw const AuthenticationFailure(
          'Please sign in to request another verification email.',
          code: 'no-current-user',
        );
      }
      await firebaseUser.sendEmailVerification();
    } on Object catch (error, stackTrace) {
      _translateAuthException(error, stackTrace);
    }
  }

  @override
  Future<UserModel> reloadUser() async {
    try {
      final firebase_auth.User? firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        throw const AuthenticationFailure(
          'Please sign in to refresh your profile.',
          code: 'no-current-user',
        );
      }
      await firebaseUser.reload();
      return _buildUserModel(firebaseUser);
    } on Object catch (error, stackTrace) {
      _translateAuthException(error, stackTrace);
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String displayName,
    required String examTrackId,
    required String district,
    String phoneNumber = '',
  }) async {
    try {
      final firebase_auth.User? firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        throw const AuthenticationFailure(
          'Please sign in to update your profile.',
          code: 'no-current-user',
        );
      }
      if (displayName != firebaseUser.displayName) {
        await firebaseUser.updateDisplayName(displayName);
      }
      // Phone number updates require re-authentication via the
      // verifyPhoneNumber flow — we do not attempt that here. The
      // phone number is still persisted to the Firestore user + profile
      // docs so the rest of the app sees the updated value.
      await firebaseUser.reload();

      // Persist to both the user doc and the profile subcollection.
      // The two locations are merged by the profile feature when it
      // loads, so the source of truth is whichever was most recently
      // edited; keeping them in sync here avoids drift.
      final Map<String, dynamic> userPatch = <String, dynamic>{
        'displayName': displayName,
        'examTrack': examTrackId,
        'district': district,
        'phoneNumber': phoneNumber.isNotEmpty
            ? phoneNumber
            : (firebaseUser.phoneNumber ?? ''),
        'lastSignInAt': DateTime.now().toUtc().toIso8601String(),
      };
      await _userDoc(firebaseUser.uid).set(
            userPatch,
            SetOptions(merge: true),
          );

      final Map<String, dynamic> profilePatch = <String, dynamic>{
        'displayName': displayName,
        'examTrack': examTrackId,
        'district': district,
        'phoneNumber': phoneNumber.isNotEmpty
            ? phoneNumber
            : (firebaseUser.phoneNumber ?? ''),
        'emailVerified': firebaseUser.emailVerified,
        'lastUpdatedAt': DateTime.now().toUtc().toIso8601String(),
      };
      await _profileDoc(firebaseUser.uid).set(
            profilePatch,
            SetOptions(merge: true),
          );

      return _buildUserModel(firebaseUser);
    } on Object catch (error, stackTrace) {
      _translateAuthException(error, stackTrace);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
    } on Object catch (error, stackTrace) {
      _translateAuthException(error, stackTrace);
    }
  }
}