import '../../../../shared/typedefs/result.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Uploads a user-selected avatar image and returns the updated profile.
class UploadAvatarUseCase {
  const UploadAvatarUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<UserProfile>> call({required String imagePath}) {
    return _repository.uploadAvatar(imagePath: imagePath);
  }
}
