import '../entities/auth_session.dart';

abstract class AuthRepository {
  Future<AuthSession> signIn({
    required String email,
    required String password,
  });

  Future<AuthSession> verifyMfa({
    required String sessionId,
    required String code,
  });

  Future<AuthSession> signInWithSso({String? provider});

  Future<void> signOut();

  Future<AuthSession?> currentSession();

  Stream<AuthSession?> authStateChanges();
}
