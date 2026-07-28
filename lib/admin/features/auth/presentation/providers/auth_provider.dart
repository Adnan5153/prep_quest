import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/admin_exception.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_usecase.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier(this._repository) : super(AuthState.unknown) {
    _bootstrap();
  }

  final AuthRepository _repository;
  StreamSubscription<AuthSession?>? _subscription;

  Future<void> _bootstrap() async {
    final AuthSession? session = await _repository.currentSession();
    if (session == null) {
      state = AuthState.unauthenticated;
    } else if (session.isMfaRequired) {
      state = AuthState(status: AuthStatus.awaitingMfa, session: session);
    } else if (session.isExpired) {
      state = AuthState.unauthenticated;
    } else {
      state = AuthState(status: AuthStatus.authenticated, session: session);
    }
    _subscription = _repository.authStateChanges().listen((AuthSession? s) {
      if (s == null) {
        state = AuthState.unauthenticated;
      } else if (s.isMfaRequired) {
        state = AuthState(status: AuthStatus.awaitingMfa, session: s);
      } else {
        state = AuthState(status: AuthStatus.authenticated, session: s);
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(clearError: true);
    try {
      final SignInResult result = await SignInUseCase(_repository)(
        SignInParams(email: email, password: password),
      );
      if (result.requiresMfa) {
        state = AuthState(
          status: AuthStatus.awaitingMfa,
          session: result.session,
        );
      } else {
        state = AuthState(status: AuthStatus.authenticated, session: result.session);
      }
    } on AdminException catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.message,
      );
    }
  }

  Future<void> verifyMfa(String code) async {
    final AuthSession? pending = state.session;
    if (pending == null) return;
    try {
      final AuthSession verified = await _repository.verifyMfa(
        sessionId: pending.userId,
        code: code,
      );
      state = AuthState(status: AuthStatus.authenticated, session: verified);
    } on AdminException catch (e) {
      state = state.copyWith(errorMessage: e.message);
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = AuthState.unauthenticated;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((Ref ref) {
  return AuthStateNotifier(ref.watch(authRepositoryProvider));
});

final authRouterRefreshProvider = Provider<ValueNotifier<int>>((Ref ref) {
  final ValueNotifier<int> notifier = ValueNotifier<int>(0);
  ref.listen<AuthState>(authStateProvider, (_, _) => notifier.value++);
  ref.onDispose(notifier.dispose);
  return notifier;
});
