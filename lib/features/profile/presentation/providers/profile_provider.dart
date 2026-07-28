/// Legacy re-export. The canonical providers live at
/// `profile_providers.dart` (and `application/providers/`).
library;

export 'profile_providers.dart' show
    profileRemoteDataSourceProvider,
    profileLocalDataSourceProvider,
    profileRepositoryProvider,
    getUserProfileUseCaseProvider,
    updateUserProfileUseCaseProvider,
    uploadAvatarUseCaseProvider,
    deleteAccountUseCaseProvider,
    profileControllerProvider,
    profileStateProvider;
