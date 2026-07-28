import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../gamification/domain/entities/badge_entry.dart';
import '../../data/datasources/mock_profile_local_datasource.dart';
import '../../data/datasources/mock_profile_remote_datasource.dart';
import '../../data/datasources/profile_local_datasource.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import '../../domain/usecases/upload_avatar_usecase.dart';
import '../controllers/profile_controller.dart';
import '../states/profile_state.dart';
import '../utils/achievement_mapper.dart';

/// Provider for the remote profile data source.
///
/// Defaults to the in-memory mock so the app boots without Firebase
/// wired in. Production overrides this with a Firestore-backed
/// implementation.
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>(
  (ref) {
    final MockProfileRemoteDataSource instance = MockProfileRemoteDataSource();
    ref.onDispose(instance.dispose);
    return instance;
  },
);

/// Provider for the local profile cache.
final profileLocalDataSourceProvider = Provider<ProfileLocalDataSource>(
  (ref) => MockProfileLocalDataSource(),
);

/// Provider for the repository contract.
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(
    remote: ref.watch(profileRemoteDataSourceProvider),
    local: ref.watch(profileLocalDataSourceProvider),
  ),
);

/// Provider for the "get profile" use case.
final getUserProfileUseCaseProvider = Provider<GetUserProfileUseCase>(
  (ref) => GetUserProfileUseCase(ref.watch(profileRepositoryProvider)),
);

/// Provider for the "update profile" use case.
final updateUserProfileUseCaseProvider = Provider<UpdateUserProfileUseCase>(
  (ref) => UpdateUserProfileUseCase(ref.watch(profileRepositoryProvider)),
);

/// Provider for the "upload avatar" use case.
final uploadAvatarUseCaseProvider = Provider<UploadAvatarUseCase>(
  (ref) => UploadAvatarUseCase(ref.watch(profileRepositoryProvider)),
);

/// Provider for the "delete account" use case.
final deleteAccountUseCaseProvider = Provider<DeleteAccountUseCase>(
  (ref) => DeleteAccountUseCase(ref.watch(profileRepositoryProvider)),
);

/// State notifier for the profile feature.
final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>(
  (ref) => ProfileController(
    getProfile: ref.watch(getUserProfileUseCaseProvider),
    updateProfile: ref.watch(updateUserProfileUseCaseProvider),
    uploadAvatar: ref.watch(uploadAvatarUseCaseProvider),
    deleteAccount: ref.watch(deleteAccountUseCaseProvider),
  ),
);

/// Convenience provider that exposes the current profile (or `null`).
final profileStateProvider = Provider<ProfileState>(
  (ref) => ref.watch(profileControllerProvider),
);

/// Unlocked badges for the current profile, mapped to the gamification
/// `BadgeEntry` type so the existing reward widgets can render them.
final profileBadgesProvider = Provider<List<BadgeEntry>>((ref) {
  final ProfileState state = ref.watch(profileControllerProvider);
  final UserProfile? profile = state.profile;
  if (profile == null) return const <BadgeEntry>[];
  return profile.badges
      .map(AchievementMapper.toBadgeEntry)
      .toList(growable: false);
});

/// True when the active profile is on the premium tier.
final profileIsPremiumProvider = Provider<bool>((ref) {
  final ProfileState state = ref.watch(profileControllerProvider);
  return state.profile?.role == 'premium';
});
