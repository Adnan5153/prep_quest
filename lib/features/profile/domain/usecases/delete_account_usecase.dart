import '../../../../shared/typedefs/result.dart';
import '../repositories/profile_repository.dart';

/// Deletes the user's account and clears all local state.
class DeleteAccountUseCase {
  const DeleteAccountUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<void>> call() async {
    final Result<void> result = await _repository.deleteAccount();
    if (result.isSuccess) {
      await _repository.clearCache();
    }
    return result;
  }
}
