import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/admin_exception.dart';
import '../../../../core/validators/validators.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class SignInParams {
  const SignInParams({required this.email, required this.password});

  final String email;
  final String password;
}

class SignInResult {
  const SignInResult({required this.session, required this.requiresMfa});

  final AuthSession session;
  final bool requiresMfa;
}

class SignInUseCase {
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  Future<SignInResult> call(SignInParams params) async {
    final String? emailError = EmailValidator.validate(params.email);
    if (emailError != null) {
      throw AdminValidationException(emailError, field: 'email');
    }
    if (params.password.isEmpty) {
      throw const AdminValidationException('Password is required', field: 'password');
    }
    final AuthSession session = await _repository.signIn(
      email: params.email.trim(),
      password: params.password,
    );
    return SignInResult(session: session, requiresMfa: session.isMfaRequired);
  }
}

final signInUseCaseProvider = Provider<SignInUseCase>((Ref ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
});
