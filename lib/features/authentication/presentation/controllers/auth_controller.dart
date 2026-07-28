import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/enums/exam_track.dart';
import '../../../../shared/enums/user_role.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../states/auth_state.dart';

/// Central state notifier for the authentication feature.
///
/// The controller:
/// 1. Subscribes to [AuthRepository.authStateChanges] so the entire
///    app reacts to remote sign-in / sign-out events.
/// 2. Exposes single-purpose methods (signIn, register, etc.) that
///    handle every async detail and bubble success / failure into
///    [AuthState].
/// 3. Translates [Failure]s into user-friendly messages via
///    [Failure.message].
///
/// Widgets never talk to the repository directly — they always go
/// through the controller so business logic stays out of the UI.
class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository) : super(const AuthState.unknown()) {
    _bootstrap();
  }

  final AuthRepository _repository;
  StreamSubscription<UserEntity?>? _authSubscription;
  bool _isAuthenticationBypassed = false;

  Future<void> _bootstrap() async {
    if (_isAuthenticationBypassed) return;
    final Result<UserEntity?> result = await _repository.currentUser();
    if (_isAuthenticationBypassed) return;
    result.fold(
      onFailure: (failure) {
        state = const AuthState.unauthenticated();
      },
      onSuccess: (currentUser) {
        if (currentUser == null) {
          state = const AuthState.unauthenticated();
          return;
        }
        _applyUser(currentUser, emitStatus: true);
      },
    );
    _authSubscription = _repository.authStateChanges().listen((user) {
      if (_isAuthenticationBypassed) return;
      if (user == null) {
        if (mounted) {
          state = const AuthState.unauthenticated();
        }
        return;
      }
      _applyUser(user, emitStatus: true);
    });
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(clearError: true, isWorking: true);
    final Result<AuthSessionEntity> result = await _repository.signInWithEmail(
      email: email,
      password: password,
    );
    if (!mounted) return;
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          isWorking: false,
          errorMessage: _messageFor(failure),
        );
      },
      onSuccess: (session) {
        _applySession(session);
      },
    );
  }

  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = state.copyWith(clearError: true, isWorking: true);
    final Result<AuthSessionEntity> result = await _repository.registerWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
    if (!mounted) return;
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          isWorking: false,
          errorMessage: _messageFor(failure),
        );
      },
      onSuccess: (session) {
        _applySession(
          session,
          successMessage:
              'Account created! Please verify your email to continue.',
        );
      },
    );
  }

  Future<void> sendPasswordReset({required String email}) async {
    state = state.copyWith(clearError: true, isWorking: true);
    final Result<void> result =
        await _repository.sendPasswordReset(email: email);
    if (!mounted) return;
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          isWorking: false,
          errorMessage: _messageFor(failure),
        );
      },
      onSuccess: (_) {
        state = state.copyWith(
          isWorking: false,
          lastSuccessMessage:
              'If an account exists for $email, a reset link has been sent.',
          clearError: true,
        );
      },
    );
  }

  Future<void> sendPhoneOtp({required String phoneNumber}) async {
    state = state.copyWith(
      clearError: true,
      clearPendingPhoneOtp: true,
      isWorking: true,
    );
    final Result<dynamic> result =
        await _repository.sendPhoneOtp(phoneNumber: phoneNumber);
    if (!mounted) return;
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          isWorking: false,
          errorMessage: _messageFor(failure),
        );
      },
      onSuccess: (request) {
        state = state.copyWith(
          isWorking: false,
          pendingPhoneOtp: request,
          lastSuccessMessage:
              'A 6-digit code has been sent to $phoneNumber.',
          clearError: true,
        );
      },
    );
  }

  Future<void> verifyPhoneOtp({
    required String verificationId,
    required String otp,
  }) async {
    state = state.copyWith(clearError: true, isWorking: true);
    final Result<AuthSessionEntity> result = await _repository.verifyPhoneOtp(
      verificationId: verificationId,
      otp: otp,
    );
    if (!mounted) return;
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          isWorking: false,
          errorMessage: _messageFor(failure),
        );
      },
      onSuccess: (session) {
        _applySession(session, successMessage: 'Phone verified!');
      },
    );
  }

  Future<void> resendEmailVerification() async {
    state = state.copyWith(clearError: true, isWorking: true);
    final Result<void> result = await _repository.resendEmailVerification();
    if (!mounted) return;
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          isWorking: false,
          errorMessage: _messageFor(failure),
        );
      },
      onSuccess: (_) {
        state = state.copyWith(
          isWorking: false,
          lastSuccessMessage: 'Verification email resent. Check your inbox.',
          clearError: true,
        );
      },
    );
  }

  Future<void> reloadCurrentUser() async {
    state = state.copyWith(clearError: true, isWorking: true);
    final Result<void> result = await _repository.reloadUser();
    if (!mounted) return;
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          isWorking: false,
          errorMessage: _messageFor(failure),
        );
      },
      onSuccess: (_) async {
        final Result<UserEntity?> current = await _repository.currentUser();
        if (!mounted) return;
        current.fold(
          onFailure: (failure) {
            state = state.copyWith(
              isWorking: false,
              errorMessage: _messageFor(failure),
            );
          },
          onSuccess: (user) {
            if (user == null) {
              state = const AuthState.unauthenticated();
              return;
            }
            _applyUser(user, emitStatus: true);
          },
        );
      },
    );
  }

  Future<void> updateProfile({
    required String displayName,
    required ExamTrack examTrack,
    required String district,
    String phoneNumber = '',
  }) async {
    state = state.copyWith(clearError: true, isWorking: true);
    final Result<UserEntity> result = await _repository.updateProfile(
      displayName: displayName,
      examTrackId: examTrack.id,
      district: district,
      phoneNumber: phoneNumber,
    );
    if (!mounted) return;
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          isWorking: false,
          errorMessage: _messageFor(failure),
        );
      },
      onSuccess: (user) {
        _applyUser(user, emitStatus: true);
        state = state.copyWith(
          isWorking: false,
          lastSuccessMessage: 'Profile saved!',
          clearError: true,
        );
      },
    );
  }

  Future<void> signOut() async {
    _isAuthenticationBypassed = false;
    state = state.copyWith(isWorking: true);
    final Result<void> result = await _repository.signOut();
    if (!mounted) return;
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          isWorking: false,
          errorMessage: _messageFor(failure),
        );
      },
      onSuccess: (_) {
        state = const AuthState.unauthenticated();
      },
    );
  }

  /// Short-circuits the entire authentication procedure and lands the
  /// user directly on the Playground as a fully-signed-in demo
  /// learner. Intended for the "I already have an account" entry
  /// point on the welcome screen so QA (and users who already have a
  /// session in another way) can skip the email/phone verification
  /// flow during development.
  void bypassAuthentication() {
    final DateTime now = DateTime.now();
    final UserEntity demoUser = UserEntity(
      id: 'demo-user',
      email: 'demo@prepquest.app',
      displayName: 'Demo Learner',
      emailVerified: true,
      phoneNumber: '+8801700000000',
      examTrack: ExamTrack.bcs,
      role: UserRole.free,
      district: 'Dhaka',
      photoUrl: '',
      createdAt: now,
      lastSignInAt: now,
    );
    final AuthSessionEntity demoSession = AuthSessionEntity(
      user: demoUser,
      accessToken: 'local-bypass-token',
      refreshToken: 'local-bypass-refresh-token',
      expiresAt: now.add(const Duration(hours: 12)),
    );
    _isAuthenticationBypassed = true;
    _applySession(
      demoSession,
      successMessage: 'Signed in as Demo Learner.',
    );
  }

  /// Manual bootstrap. Useful for tests that want to start the
  /// controller in a known state.
  Future<void> refresh() => _bootstrap();

  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }

  void _applySession(
    AuthSessionEntity session, {
    String? successMessage,
  }) {
    final UserEntity user = session.user;
    final AuthStatus status = _statusFor(user);
    state = state.copyWith(
      status: status,
      user: user,
      session: session,
      clearPendingPhoneOtp: true,
      isWorking: false,
      lastSuccessMessage: successMessage,
      clearError: true,
    );
  }

  void _applyUser(UserEntity user, {bool emitStatus = false}) {
    final AuthStatus status = _statusFor(user);
    state = state.copyWith(
      status: emitStatus ? status : state.status,
      user: user,
      session: state.session ?? _placeholderSession(user),
      isWorking: false,
      clearError: true,
    );
  }

  AuthStatus _statusFor(UserEntity user) {
    if (!user.hasCompletedProfile) {
      return AuthStatus.profileIncomplete;
    }
    if (!user.emailVerified && user.email.isNotEmpty) {
      return AuthStatus.emailVerificationRequired;
    }
    if (user.role == UserRole.admin) {
      return AuthStatus.authenticated;
    }
    return AuthStatus.authenticated;
  }

  AuthSessionEntity _placeholderSession(UserEntity user) {
    return AuthSessionEntity(
      user: user,
      accessToken: '',
      refreshToken: '',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    );
  }

  String _messageFor(Failure failure) {
    return failure.message;
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}