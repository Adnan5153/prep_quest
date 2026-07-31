import '../../domain/entities/auth_identity_seed.dart';
import '../models/app_user_model.dart';

/// Contract every remote app-user data source must satisfy.
///
/// Two implementations exist:
/// * [FirestoreAppUserRemoteDataSource] — production Firestore-backed
///   source. Persists to `users/{uid}/app_user/current`.
/// * [MockAppUserRemoteDataSource] — in-memory replacement used during
///   development and tests.
abstract class AppUserRemoteDataSource {
  Future<AppUserModel> fetchOrCreate(
    String uid, {
    AuthIdentitySeed? identity,
  });

  Future<void> patch(String uid, Map<String, dynamic> fields);

  Future<void> delete(String uid);
}