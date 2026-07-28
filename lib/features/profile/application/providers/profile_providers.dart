/// Application-layer providers for the profile feature.
///
/// Re-exports the canonical providers so the folder matches the
/// `application/providers/` layout in the feature template. The
/// implementation lives in `presentation/providers/profile_providers.dart`.
library;

export '../../presentation/providers/profile_providers.dart' show
    profileRemoteDataSourceProvider,
    profileLocalDataSourceProvider,
    profileRepositoryProvider,
    getUserProfileUseCaseProvider,
    updateUserProfileUseCaseProvider,
    uploadAvatarUseCaseProvider,
    deleteAccountUseCaseProvider,
    profileControllerProvider,
    profileStateProvider;
