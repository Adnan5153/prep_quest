import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';
import '../../../gamification/domain/entities/badge_entry.dart';
import '../../data/datasources/firestore_profile_remote_datasource.dart';
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
/// Returns the **real** [FirestoreProfileRemoteDataSource] whenever
/// Firebase is configured AND the active auth session has a uid —
/// profile data is then read straight from `users/{uid}/profile/current`.
/// When Firebase is not configured (unit tests, hot-reload sessions,
/// or a fresh dev machine without `google-services.json`) the provider
/// falls back to [MockProfileRemoteDataSource] so the app still boots.
/// While the user is unauthenticated the provider returns a no-op mock
/// so the widget tree can resolve before sign-in completes.
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>(
  (ref) {
    if (FirebaseConfig.isPlatformConfigured) {
      final String? uid = ref.watch(authStateProvider).user?.id;
      if (uid != null && uid.isNotEmpty) {
        return FirestoreProfileRemoteDataSource(uid: uid);
      }
    }
    final MockProfileRemoteDataSource instance = MockProfileRemoteDataSource();
    ref.onDispose(instance.dispose);
    return instance;
  },
);

/// Provider for the local profile cache.
///
/// Kept as the in-memory mock — the local cache is a forward-looking
/// seam for Hive-backed offline reads. The mock satisfies the
/// contract so feature code can resolve the provider today; once a
/// Hive-backed implementation lands the swap is a single line.
final profileLocalDataSourceProvider = Provider<ProfileLocalDataSource>(
  (ref) => MockProfileLocalDataSource(),
);

/// Provider for the repository contract.
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(
    remote: ref.watch(profileRemoteDataSourceProvider),
    local: ref.watch(profileLocalDataSourceProvider),
    ref: ref,
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
