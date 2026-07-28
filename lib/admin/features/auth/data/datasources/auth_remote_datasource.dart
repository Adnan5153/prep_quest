import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/enums/workflow_state.dart';
import '../models/auth_session_model.dart';

class AuthCredentials {
  const AuthCredentials({
    required this.userId,
    required this.email,
    required this.displayName,
    required this.role,
    this.mfaSecret = '000000',
    this.password = 'admin',
  });

  final String userId;
  final String email;
  final String displayName;
  final AdminRole role;
  final String mfaSecret;
  final String password;
}

abstract class AuthRemoteDataSource {
  Future<AuthSessionModel> signIn({
    required String email,
    required String password,
  });

  Future<AuthSessionModel> verifyMfa({
    required String userId,
    required String code,
  });

  Future<void> signOut();

  Future<AuthSessionModel?> currentSession();

  Stream<AuthSessionModel?> watchAuthState();
}

class InMemoryAuthDataSource implements AuthRemoteDataSource {
  InMemoryAuthDataSource() {
    _directory.addAll(<AuthCredentials>[
      const AuthCredentials(
        userId: 'usr_admin',
        email: 'admin@prepquest.app',
        displayName: 'Platform Admin',
        role: AdminRole.admin,
        mfaSecret: '123456',
      ),
      const AuthCredentials(
        userId: 'usr_author',
        email: 'author@prepquest.app',
        displayName: 'Author One',
        role: AdminRole.author,
      ),
      const AuthCredentials(
        userId: 'usr_reviewer',
        email: 'reviewer@prepquest.app',
        displayName: 'Reviewer One',
        role: AdminRole.reviewer,
      ),
      const AuthCredentials(
        userId: 'usr_publisher',
        email: 'publisher@prepquest.app',
        displayName: 'Publisher One',
        role: AdminRole.publisher,
      ),
      const AuthCredentials(
        userId: 'usr_auditor',
        email: 'auditor@prepquest.app',
        displayName: 'Auditor One',
        role: AdminRole.auditor,
      ),
      const AuthCredentials(
        userId: 'usr_viewer',
        email: 'viewer@prepquest.app',
        displayName: 'Viewer One',
        role: AdminRole.viewer,
      ),
    ]);
  }

  final List<AuthCredentials> _directory = <AuthCredentials>[];
  final StreamController<AuthSessionModel?> _controller =
      StreamController<AuthSessionModel?>.broadcast();
  AuthSessionModel? _active;

  AuthCredentials? _lookup(String email) {
    final String normalised = email.trim().toLowerCase();
    for (final AuthCredentials c in _directory) {
      if (c.email.toLowerCase() == normalised) return c;
    }
    return null;
  }

  @override
  Future<AuthSessionModel> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 240));
    final AuthCredentials? c = _lookup(email);
    if (c == null) {
      throw const AuthDataSourceException('No account for that email');
    }
    if (c.password != password) {
      throw const AuthDataSourceException('Incorrect password');
    }
    final DateTime now = DateTime.now();
    final AuthSessionModel session = AuthSessionModel(
      userId: c.userId,
      email: c.email,
      displayName: c.displayName,
      role: c.role,
      issuedAt: now,
      expiresAt: now.add(const Duration(hours: 8)),
      mfaVerified: false,
    );
    _active = session;
    _controller.add(session);
    return session;
  }

  @override
  Future<AuthSessionModel> verifyMfa({
    required String userId,
    required String code,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final AuthCredentials? c = _directory
        .where((AuthCredentials entry) => entry.userId == userId)
        .cast<AuthCredentials?>()
        .firstWhere((AuthCredentials? e) => e != null, orElse: () => null);
    if (c == null) {
      throw const AuthDataSourceException('Session expired');
    }
    if (code.trim() != c.mfaSecret) {
      throw const AuthDataSourceException('Invalid verification code');
    }
    final AuthSessionModel upgraded = AuthSessionModel(
      userId: c.userId,
      email: c.email,
      displayName: c.displayName,
      role: c.role,
      issuedAt: _active?.issuedAt ?? DateTime.now(),
      expiresAt: _active?.expiresAt ?? DateTime.now().add(const Duration(hours: 8)),
      mfaVerified: true,
      tenantId: _active?.tenantId,
    );
    _active = upgraded;
    _controller.add(upgraded);
    return upgraded;
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    _active = null;
    _controller.add(null);
  }

  @override
  Future<AuthSessionModel?> currentSession() async => _active;

  @override
  Stream<AuthSessionModel?> watchAuthState() => _controller.stream;
}

class AuthDataSourceException implements Exception {
  const AuthDataSourceException(this.message);
  final String message;
  @override
  String toString() => message;
}

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((Ref ref) {
  final InMemoryAuthDataSource ds = InMemoryAuthDataSource();
  ref.onDispose(ds._controller.close);
  return ds;
});
