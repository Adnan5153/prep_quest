import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/admin_exception.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_session_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final AuthRemoteDataSource _dataSource;

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _dataSource.signIn(email: email, password: password);
    } on AuthDataSourceException catch (e) {
      throw AdminAuthException(e.message, cause: e);
    }
  }

  @override
  Future<AuthSession> verifyMfa({
    required String sessionId,
    required String code,
  }) async {
    try {
      return await _dataSource.verifyMfa(userId: sessionId, code: code);
    } on AuthDataSourceException catch (e) {
      throw AdminAuthException(e.message, cause: e);
    }
  }

  @override
  Future<AuthSession> signInWithSso({String? provider}) async {
    return signIn(email: 'admin@prepquest.app', password: 'admin');
  }

  @override
  Future<void> signOut() async {
    await _dataSource.signOut();
  }

  @override
  Future<AuthSession?> currentSession() => _dataSource.currentSession();

  @override
  Stream<AuthSession?> authStateChanges() => _dataSource.watchAuthState();
}

final authRepositoryProvider = Provider<AuthRepository>((Ref ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
});

final currentAuthSessionProvider = FutureProvider<AuthSessionModel?>((Ref ref) {
  return ref.watch(authRemoteDataSourceProvider).currentSession();
});
