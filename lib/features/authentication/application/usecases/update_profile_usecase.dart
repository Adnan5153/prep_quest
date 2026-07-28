import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

/// Use case: persist the post-sign-up profile details.
class UpdateProfileUseCase {
  const UpdateProfileUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<UserEntity>> call({
    required String displayName,
    required String examTrackId,
    required String district,
    String phoneNumber = '',
  }) {
    return _repository.updateProfile(
      displayName: displayName,
      examTrackId: examTrackId,
      district: district,
      phoneNumber: phoneNumber,
    );
  }
}