/// Identity information handed to the user-account repository at
/// sign-in time. This is the minimal set of fields the auth provider
/// (Firebase Auth, Google, etc.) makes available immediately after a
/// fresh sign-in — the account repository uses it to back-fill empty
/// fields on the persisted user document.
class AuthIdentitySeed {
  const AuthIdentitySeed({
    this.displayName = '',
    this.email = '',
    this.emailVerified = false,
    this.phoneNumber = '',
    this.photoUrl = '',
    DateTime? createdAt,
  }) : _createdAt = createdAt;

  final String displayName;
  final String email;
  final bool emailVerified;
  final String phoneNumber;
  final String photoUrl;
  final DateTime? _createdAt;

  /// Only populated when the auth provider reports it (e.g. for Google
  /// sign-in). Falls back to `null` for phone-only sign-ins.
  DateTime? get createdAt => _createdAt;
}