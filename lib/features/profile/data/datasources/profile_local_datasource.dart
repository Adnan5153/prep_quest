import '../models/user_profile_model.dart';

/// Local cache for the profile document.
///
/// Production implementations use Hive / SharedPreferences. Tests and
/// development use the in-memory [MockProfileLocalDataSource].
abstract class ProfileLocalDataSource {
  Future<UserProfileModel?> read();
  Future<void> write(UserProfileModel model);
  Future<void> clear();
}