import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore_for_file: prefer_initializing_formals

import '../../../../core/errors/failures.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import '../../domain/usecases/upload_avatar_usecase.dart';
import '../states/profile_state.dart';

/// State notifier for the profile feature.
///
/// Coordinates the use cases and converts [Failure]s into
/// user-readable messages. Widgets never call repositories directly.
class ProfileController extends StateNotifier<ProfileState> {
  ProfileController({
    required GetUserProfileUseCase getProfile,
    required UpdateUserProfileUseCase updateProfile,
    required UploadAvatarUseCase uploadAvatar,
    required DeleteAccountUseCase deleteAccount,
  })  : _getProfile = getProfile,
        _updateProfile = updateProfile,
        _uploadAvatar = uploadAvatar,
        _deleteAccount = deleteAccount,
        super(const ProfileState.unknown());

  final GetUserProfileUseCase _getProfile;
  final UpdateUserProfileUseCase _updateProfile;
  final UploadAvatarUseCase _uploadAvatar;
  final DeleteAccountUseCase _deleteAccount;

  Future<void> load() async {
    state = state.copyWith(
      status: ProfileStatus.initialLoading,
      clearError: true,
    );
    final Result<UserProfile> result = await _getProfile();
    if (!mounted) return;
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: _messageFor(failure),
        );
      },
      onSuccess: (profile) {
        state = state.copyWith(
          status: ProfileStatus.ready,
          profile: profile,
          clearError: true,
        );
      },
    );
  }

  Future<void> updateProfile(ProfileUpdateEntity update) async {
    state = state.copyWith(
      status: ProfileStatus.mutating,
      clearError: true,
    );
    final Result<UserProfile> result = await _updateProfile(update);
    if (!mounted) return;
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          status: ProfileStatus.ready,
          errorMessage: _messageFor(failure),
        );
      },
      onSuccess: (profile) {
        state = state.copyWith(
          status: ProfileStatus.ready,
          profile: profile,
          lastSuccessMessage: 'Profile updated.',
          clearError: true,
        );
      },
    );
  }

  Future<void> uploadAvatar({required String imagePath}) async {
    state = state.copyWith(
      status: ProfileStatus.mutating,
      clearError: true,
    );
    final Result<UserProfile> result =
        await _uploadAvatar(imagePath: imagePath);
    if (!mounted) return;
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          status: ProfileStatus.ready,
          errorMessage: _messageFor(failure),
        );
      },
      onSuccess: (profile) {
        state = state.copyWith(
          status: ProfileStatus.ready,
          profile: profile,
          lastSuccessMessage: 'Avatar updated.',
          clearError: true,
        );
      },
    );
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(
      status: ProfileStatus.mutating,
      clearError: true,
    );
    final Result<void> result = await _deleteAccount();
    if (!mounted) return;
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          status: ProfileStatus.ready,
          errorMessage: _messageFor(failure),
        );
      },
      onSuccess: (_) {
        state = const ProfileState.unknown();
      },
    );
  }

  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }

  Future<void> refresh() => load();

  String _messageFor(Failure failure) => failure.message;
}
