import '../../domain/entities/user_profile.dart';
import '../models/user_profile_model.dart';

/// Contract for the remote profile data source.
///
/// In production this is implemented by a Firestore-backed class that
/// listens to the user's profile document. In development and tests
/// the [MockProfileRemoteDataSource] is wired up instead.
abstract class ProfileRemoteDataSource {
  /// Returns the latest profile, throwing on network/permission errors.
  Future<UserProfileModel> fetchProfile();

  /// Streams realtime updates. Backends without realtime can emit
  /// once via [fetchProfile] inside the stream.
  Stream<UserProfileModel> watchProfile();

  /// Persists a profile update.
  Future<UserProfileModel> updateProfile({
    required String userId,
    required ProfileUpdateEntity update,
  });

  /// Uploads an avatar and returns the updated profile.
  Future<UserProfileModel> uploadAvatar({
    required String userId,
    required String imagePath,
  });

  /// Deletes the profile document. Implementations must be idempotent.
  Future<void> deleteProfile({required String userId});
}