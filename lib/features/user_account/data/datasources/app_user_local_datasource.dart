import '../models/app_user_model.dart';

/// Contract every local (on-device) app-user data source must satisfy.
///
/// The default implementation writes through to Hive so the user can
/// stay signed-in across app restarts. Tests substitute an in-memory
/// implementation to keep assertions deterministic.
abstract class AppUserLocalDataSource {
  Future<AppUserModel?> read();
  Future<void> write(AppUserModel model);
  Future<void> clear();
}