import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/user_progress_service.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../../profile/presentation/providers/profile_providers.dart';

/// Local mirror of the canonical `pendingLevelRewards` list, filtered
/// to unclaimed rewards. The UI watches this provider to pop the
/// `LevelRewardDialog` one entry at a time. Remote persistence is
/// delegated to [UserProgressService.claimLevelReward] so the same
/// Firestore transaction guarantees the rest of the funnel relies on
/// still apply.
final levelRewardQueueProvider =
    StateNotifierProvider<LevelRewardQueueNotifier, List<PendingLevelReward>>(
  (Ref ref) => LevelRewardQueueNotifier(ref),
);

class LevelRewardQueueNotifier extends StateNotifier<List<PendingLevelReward>> {
  LevelRewardQueueNotifier(this._ref) : super(const <PendingLevelReward>[]) {
    state = _snapshotFromProfile(_ref.read(profileControllerProvider).profile);
    _ref.listen<UserProfile?>(
      profileControllerProvider.select(
        (s) => s.profile,
      ),
      (UserProfile? previous, UserProfile? next) {
        state = _snapshotFromProfile(next);
      },
    );
  }

  final Ref _ref;

  List<PendingLevelReward> _snapshotFromProfile(UserProfile? profile) {
    if (profile == null) return const <PendingLevelReward>[];
    return List<PendingLevelReward>.unmodifiable(
      profile.progression.unclaimedRewards,
    );
  }

  /// Removes the reward from the local queue and tells the canonical
  /// service to persist the claim. The state is updated optimistically
  /// before the Firestore write completes.
  Future<void> markClaimed(PendingLevelReward reward) async {
    state = state
        .where((PendingLevelReward existing) =>
            !(existing.level == reward.level &&
                existing.queuedAt == reward.queuedAt))
        .toList(growable: false);
    await _ref.read(userProgressServiceProvider).claimLevelReward(reward);
  }
}
