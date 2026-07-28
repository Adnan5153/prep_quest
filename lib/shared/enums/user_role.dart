/// Authorization roles available in Prep Quest.
///
/// The default role for newly registered users is [free]. Users with
/// an active subscription are elevated to [premium]. The [admin] role
/// gates access to the admin console.
enum UserRole {
  free,
  premium,
  admin;

  String get id {
    switch (this) {
      case UserRole.free:
        return 'free';
      case UserRole.premium:
        return 'premium';
      case UserRole.admin:
        return 'admin';
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.free:
        return 'Free';
      case UserRole.premium:
        return 'Premium';
      case UserRole.admin:
        return 'Admin';
    }
  }

  static UserRole fromId(String? value) {
    if (value == null) return UserRole.free;
    for (final UserRole role in UserRole.values) {
      if (role.id == value) return role;
    }
    return UserRole.free;
  }
}
