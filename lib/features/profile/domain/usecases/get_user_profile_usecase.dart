import '../../../../shared/typedefs/result.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Reads the cached profile and falls back to a remote fetch when
/// there's nothing locally.
class GetUserProfileUseCase {
  const GetUserProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<UserProfile>> call() async {
    final Result<UserProfile?> cached = await _repository.readCachedProfile();
    return cached.fold(
      onFailure: (failure) => Result.failure(failure),
      onSuccess: (cachedProfile) async {
        if (cachedProfile != null) {
          return Result.success(cachedProfile);
        }
        return _repository.fetchProfile();
      },
    );
  }
}
