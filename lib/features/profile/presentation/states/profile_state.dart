import 'package:flutter/foundation.dart';

import '../../domain/entities/user_profile.dart';

/// Incremental lifecycle of the profile state machine.
enum ProfileStatus {
  /// Initial — never been fetched.
  unknown,

  /// Loading the profile for the first time.
  initialLoading,

  /// Profile loaded successfully.
  ready,

  /// Saving / uploading / deleting.
  mutating,

  /// Failed to load.
  error,
}

/// Immutable snapshot of the profile feature.
@immutable
class ProfileState {
  const ProfileState({
    required this.status,
    this.profile,
    this.errorMessage,
    this.lastSuccessMessage,
  });

  const ProfileState.unknown()
      : status = ProfileStatus.unknown,
        profile = null,
        errorMessage = null,
        lastSuccessMessage = null;

  final ProfileStatus status;
  final UserProfile? profile;
  final String? errorMessage;
  final String? lastSuccessMessage;

  bool get isReady => status == ProfileStatus.ready && profile != null;
  bool get isWorking =>
      status == ProfileStatus.initialLoading ||
      status == ProfileStatus.mutating;

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    String? errorMessage,
    bool clearError = false,
    String? lastSuccessMessage,
    bool clearSuccess = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastSuccessMessage:
          clearSuccess ? null : (lastSuccessMessage ?? this.lastSuccessMessage),
    );
  }
}