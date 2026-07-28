import 'dart:async';
import 'dart:math';

import 'package:uuid/uuid.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/enums/exam_track.dart';
import '../../../../shared/enums/user_role.dart';
import '../../../../shared/validators/email_validator.dart';
import '../../../../shared/validators/password_validator.dart';
import '../../../../shared/validators/phone_validator.dart';
import '../models/auth_session_model.dart';
import '../models/otp_request_model.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

/// In-memory authentication data source used during development and
/// tests. Mirrors the Firebase Auth API surface so production can
/// swap implementations via dependency injection without touching the
/// application/presentation layer.
///
/// Behaviour summary:
/// * Stores "registered" users in memory; the "database" is reset on
///   process restart. Production swaps in [FirebaseAuthRemoteDataSource].
/// * Phone OTP codes are emitted by the repository (printed to debug
///   log) so QA can complete the flow without an SMS provider.
/// * All write paths simulate a 600 ms network round-trip.
class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  MockAuthRemoteDataSource({Duration? latency})
      : _latency = latency ?? const Duration(milliseconds: 600) {
    _bootstrap();
  }

  final Duration _latency;
  final Uuid _uuid = const Uuid();
  final Random _random = Random();
  final StreamController<UserModel?> _controller =
      StreamController<UserModel?>.broadcast();

  final Map<String, _MockAccount> _accounts = <String, _MockAccount>{};
  final Map<String, String> _otpByVerificationId = <String, String>{};
  UserModel? _currentUser;

  void _bootstrap() {
    final DateTime now = DateTime.now();
    final UserModel demo = UserModel(
      id: 'demo-user',
      email: 'demo@prepquest.app',
      displayName: 'Demo Learner',
      emailVerified: true,
      phoneNumber: '+8801700000000',
      examTrackId: ExamTrack.bcs.id,
      roleId: UserRole.free.id,
      district: 'Dhaka',
      photoUrl: '',
      createdAt: now,
      lastSignInAt: now,
    );
    _accounts[demo.email.toLowerCase()] = _MockAccount(
      user: demo,
      password: 'Password1',
    );
  }

  @override
  Stream<UserModel?> authStateChanges() async* {
    yield _currentUser;
    yield* _controller.stream;
  }

  @override
  Future<UserModel?> currentUser() async {
    await _wait();
    return _currentUser;
  }

  @override
  Future<AuthSessionModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await _wait();
    if (!EmailValidator.isValid(email)) {
      throw const AuthenticationFailure(
        'Please enter a valid email address.',
        code: 'invalid-email',
      );
    }
    if (!PasswordValidator.meetsLength(password)) {
      throw const AuthenticationFailure(
        'Incorrect password. Please try again.',
        code: 'invalid-credential',
      );
    }
    final _MockAccount? account = _accounts[email.toLowerCase()];
    if (account == null || account.password != password) {
      throw const AuthenticationFailure(
        'No account found for that email or the password is incorrect.',
        code: 'invalid-credential',
      );
    }
    final UserModel refreshed = account.user.copyWith(
      lastSignInAt: DateTime.now(),
    );
    _accounts[email.toLowerCase()] = account.copyWith(user: refreshed);
    _setCurrentUser(refreshed);
    return _session(refreshed);
  }

  @override
  Future<AuthSessionModel> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    await _wait();
    if (!EmailValidator.isValid(email)) {
      throw const AuthenticationFailure(
        'Please enter a valid email address.',
        code: 'invalid-email',
      );
    }
    if (!PasswordValidator.isValid(password)) {
      throw const AuthenticationFailure(
        'Password must be at least 8 characters and include a letter and a number.',
        code: 'weak-password',
      );
    }
    final String normalized = email.toLowerCase();
    if (_accounts.containsKey(normalized)) {
      throw const AuthenticationFailure(
        'An account already exists for that email.',
        code: 'email-already-in-use',
      );
    }
    final DateTime now = DateTime.now();
    final UserModel user = UserModel(
      id: _uuid.v4(),
      email: email,
      displayName: displayName,
      emailVerified: false,
      phoneNumber: '',
      examTrackId: ExamTrack.other.id,
      roleId: UserRole.free.id,
      district: '',
      photoUrl: '',
      createdAt: now,
      lastSignInAt: now,
    );
    _accounts[normalized] = _MockAccount(user: user, password: password);
    _setCurrentUser(user);
    return _session(user);
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    await _wait();
    if (!EmailValidator.isValid(email)) {
      throw const AuthenticationFailure(
        'Please enter a valid email address.',
        code: 'invalid-email',
      );
    }
    final _MockAccount? account = _accounts[email.toLowerCase()];
    if (account == null) {
      throw const AuthenticationFailure(
        'No account found for that email.',
        code: 'user-not-found',
      );
    }
  }

  @override
  Future<OtpRequestModel> sendPhoneOtp({required String phoneNumber}) async {
    await _wait();
    if (!PhoneValidator.isValid(phoneNumber)) {
      throw const AuthenticationFailure(
        'Please enter a valid Bangladeshi phone number.',
        code: 'invalid-phone',
      );
    }
    final String verificationId = _uuid.v4();
    final String code = _generateOtp();
    _otpByVerificationId[verificationId] = code;
    // QA hook: codes are also printed so testers can complete flows
    // without an SMS provider.
    // ignore: avoid_print
    print('[MockAuth] OTP for $phoneNumber: $code');
    return OtpRequestModel(
      verificationId: verificationId,
      phoneNumber: PhoneValidator.normalize(phoneNumber),
      expiresAt: DateTime.now().add(const Duration(minutes: 5)),
      resendToken: _uuid.v4(),
    );
  }

  @override
  Future<AuthSessionModel> verifyPhoneOtp({
    required String verificationId,
    required String otp,
  }) async {
    await _wait();
    final String? expected = _otpByVerificationId[verificationId];
    if (expected == null) {
      throw const AuthenticationFailure(
        'This verification session has expired. Request a new code.',
        code: 'invalid-verification',
      );
    }
    if (expected != otp.trim()) {
      throw const AuthenticationFailure(
        'The code you entered is incorrect.',
        code: 'invalid-otp',
      );
    }
    _otpByVerificationId.remove(verificationId);
    final String phone = '+880${_random.nextInt(90000000) + 10000000}';
    final DateTime now = DateTime.now();
    final UserModel user = UserModel(
      id: _uuid.v4(),
      email: '',
      displayName: '',
      emailVerified: false,
      phoneNumber: phone,
      examTrackId: ExamTrack.other.id,
      roleId: UserRole.free.id,
      district: '',
      photoUrl: '',
      createdAt: now,
      lastSignInAt: now,
    );
    _accounts['phone:$phone'] = _MockAccount(user: user, password: '');
    _setCurrentUser(user);
    return _session(user);
  }

  @override
  Future<void> resendEmailVerification() async {
    await _wait();
    final UserModel? user = _currentUser;
    if (user == null) {
      throw const AuthenticationFailure(
        'Please sign in to request another verification email.',
        code: 'no-current-user',
      );
    }
  }

  @override
  Future<UserModel> reloadUser() async {
    await _wait();
    final UserModel? user = _currentUser;
    if (user == null) {
      throw const AuthenticationFailure(
        'Please sign in to refresh your profile.',
        code: 'no-current-user',
      );
    }
    final UserModel refreshed = user.copyWith(lastSignInAt: DateTime.now());
    _setCurrentUser(refreshed);
    return refreshed;
  }

  @override
  Future<UserModel> updateProfile({
    required String displayName,
    required String examTrackId,
    required String district,
    String phoneNumber = '',
  }) async {
    await _wait();
    final UserModel? user = _currentUser;
    if (user == null) {
      throw const AuthenticationFailure(
        'Please sign in to update your profile.',
        code: 'no-current-user',
      );
    }
    final UserModel updated = user.copyWith(
      displayName: displayName,
      examTrackId: examTrackId,
      district: district,
      phoneNumber: phoneNumber.isNotEmpty ? phoneNumber : user.phoneNumber,
      emailVerified: user.email.isEmpty ? user.emailVerified : true,
    );
    _setCurrentUser(updated);
    if (updated.email.isNotEmpty) {
      _accounts[updated.email.toLowerCase()] = _MockAccount(
        user: updated,
        password: _accounts[updated.email.toLowerCase()]?.password ?? '',
      );
    }
    return updated;
  }

  @override
  Future<void> signOut() async {
    await _wait();
    _setCurrentUser(null);
  }

  void dispose() {
    _controller.close();
  }

  AuthSessionModel _session(UserModel user) {
    final DateTime now = DateTime.now();
    return AuthSessionModel(
      user: user,
      accessToken: _uuid.v4(),
      refreshToken: _uuid.v4(),
      expiresAt: now.add(const Duration(hours: 1)),
    );
  }

  String _generateOtp() {
    final int value = _random.nextInt(900000) + 100000;
    return value.toString();
  }

  Future<void> _wait() async {
    await Future<void>.delayed(_latency);
  }

  void _setCurrentUser(UserModel? user) {
    _currentUser = user;
    _controller.add(user);
  }
}

class _MockAccount {
  const _MockAccount({required this.user, required this.password});

  final UserModel user;
  final String password;

  _MockAccount copyWith({UserModel? user, String? password}) {
    return _MockAccount(
      user: user ?? this.user,
      password: password ?? this.password,
    );
  }
}