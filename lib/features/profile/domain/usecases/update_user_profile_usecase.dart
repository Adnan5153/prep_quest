import '../../../../shared/typedefs/result.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Persists the editable portion of the profile.
class UpdateUserProfileUseCase {
  const UpdateUserProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<UserProfile>> call(ProfileUpdateEntity update) {
    return _repository.updateProfile(update);
  }
}
