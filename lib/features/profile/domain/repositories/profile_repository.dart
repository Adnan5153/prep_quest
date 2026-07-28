import '../../../../shared/typedefs/result.dart';
import '../entities/user_profile.dart';

/// Contract every profile repository must satisfy.
///
/// Two implementations exist:
/// * [ProfileRepositoryImpl] — composes a remote + local data source.
/// * (Tests) — in-memory fake. Lives in the test folder.
abstract class ProfileRepository {
  /// Returns the cached profile for the active user, or `null` if
  /// nothing has been fetched yet.
  Future<Result<UserProfile?>> readCachedProfile();

  /// Fetches the latest profile from the backend (typically Firestore).
  Future<Result<UserProfile>> fetchProfile();

  /// Streams realtime updates to the active user's profile. Backends
  /// that don't support realtime can emit once via [fetchProfile].
  Stream<UserProfile> watchProfile();

  /// Persists the editable parts of the profile (identity, exam goal,
  /// language, etc.).
  Future<Result<UserProfile>> updateProfile(ProfileUpdateEntity update);

  /// Uploads a new avatar image and returns the resulting profile.
  Future<Result<UserProfile>> uploadAvatar({required String imagePath});

  /// Removes the account from the local cache and triggers a server
  /// delete.
  Future<Result<void>> deleteAccount();

  /// Clears any cached profile. Used on sign-out.
  Future<Result<void>> clearCache();
}
